extends Node
## A simple Timer-based task manager that allows specifying delay times for functions,
## as well as handling frame-based functions as a standalone.

## Returning TaskMgr.AGAIN on a delayed_call function will call it again with the same delay.
const AGAIN: StringName = &"TaskMgr-AGAIN"

## The next available Task ID.
static var task_id: int = 0

## All currently in-use SceneTreeTimers used to track function delays.
var timers: Array[Timer] = []
## All currently active Tasks.
var tasks: Dictionary = {}


class Task extends Node:
	var task_id: int
	var callback: Callable
	var args: Array
	var timer: Timer
	var is_process: bool
	var start_time: float
	var pausable: bool

	func _init(p_task_id: int, p_callback: Callable, p_args: Array, p_timer: Timer,
			p_is_process: bool, p_start_time: float, p_pausable: bool):
		task_id = p_task_id
		callback = p_callback
		args = p_args
		timer = p_timer
		is_process = p_is_process
		start_time = p_start_time
		pausable = p_pausable

		if not pausable:
			process_mode = PROCESS_MODE_ALWAYS

		name = 'Task-' + str(task_id)
		if is_process:
			name += '-Process'
		if callback.get_object() is Resource:
			name += '-' + str(callback.get_object().resource_name) + '-' + str(callback.get_method())
		elif callback.get_object():
			var obj_name = callback.get_object().get("name")
			if not obj_name:
				obj_name = callback.get_object().get_class()
			name += '-' + obj_name + '-' + str(callback.get_method())
		else:
			name += '-' + str(callback.get_method())

		if timer:
			timer.timeout.connect(complete_callback)

	func complete_callback():
		var result = callback.callv(args)
		if result != null and result == TaskMgr.AGAIN:
			timer = TaskMgr._make_new_timer(start_time, not pausable)
			timer.timeout.connect(complete_callback)
		else:
			TaskMgr.cancel_task(task_id)

	func cancel():
		if timer:
			timer.timeout.disconnect(complete_callback)
	
	func _process(delta):
		if not is_process:
			return

		callback.callv([delta] + args)

#region Public Funcs

## Begins calling a function every process frame
## Functions called via process_call always have delta as the first argument.
func process_call(function: Callable, args: Array = [], pausable: bool = true) -> int:
	var new_task = _make_new_task(null, function, args, true, 0.0, pausable)
	return new_task.task_id

## Calls a function after the specified time without disrupting code execution.
func delayed_call(time: float, function: Callable, args: Array = [], pausable: bool = true) -> int:
	var new_timer = _make_new_timer(time)
	var new_task = _make_new_task(new_timer, function, args, false, time, pausable)
	new_task.add_child(new_timer)
	return new_task.task_id

## Given a Task ID, cancel the active Task with the same ID.
func cancel_task(cancel_task_id: int):
	if cancel_task_id in tasks.keys():
		var task = tasks[cancel_task_id]
		task.cancel()
		tasks.erase(cancel_task_id)
		remove_child(task)

## A simplified timer await. Does not return a Task ID and is not cancellable.
func delay(time: float) -> Signal:
	return get_tree().create_timer(time).timeout

#endregion
#region Internal Funcs

func _make_new_timer(time: float, scene_tree: bool = false) -> Timer:
	var new_timer: Timer = Timer.new()
	new_timer.wait_time = time
	new_timer.autostart = true
	var timer_done = func(t: Timer = new_timer) -> void:
		if t in timers:
			timers.erase(t)
	new_timer.timeout.connect(timer_done)
	timers.append(new_timer)
	return new_timer

func _make_new_task(timer: Timer, callback: Callable, args: Array, is_process: bool, start_time: float, pausable: bool) -> Task:
	var new_task = Task.new(_next_task_id(), callback, args, timer, is_process, start_time, pausable)
	tasks[new_task.task_id] = new_task
	add_child(new_task)
	return new_task

func _next_task_id() -> int:
	TaskMgr.task_id += 1
	return TaskMgr.task_id

#endregion
