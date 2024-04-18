extends Node

var task_id: int
var task_id_2: int
var task_id_3: int


# Called when the node enters the scene tree for the first time.
func _ready():
	task_id = TaskMgr.delayed_call(2.0, print_foo, [])
	task_id_2 = TaskMgr.delayed_call(3.0, print_something, ["something"])
	TaskMgr.delayed_call(2.1, cancel_second_task, [])
	await TaskMgr.delay(0.5)
	task_id_3 = TaskMgr.process_call(process_print_call, [])
	await TaskMgr.delay(1.0)
	TaskMgr.cancel_task(task_id_3)
	await TaskMgr.delay(0.5)
	TaskMgr.delayed_call(0.5, repeating_print, [])
	var barrier: SignalBarrier = SignalBarrier.new([TaskMgr.delay(2.0), TaskMgr.delay(3.0), \
			TaskMgr.delay(4.0)], SignalBarrier.BarrierType.ALL, 1.0)
	barrier.s_complete.connect(func(): print('signal barrier done'))
	barrier.s_timeout.connect(func(): print('signal barrier timeout'))

func print_foo():
	print('Foo')

func print_something(something: String):
	print(something)

func cancel_second_task():
	TaskMgr.cancel_task(task_id_2)

func process_print_call(delta):
	print('Processing.')

func repeating_print():
	print('This is a repeating print.')
	return TaskMgr.AGAIN
