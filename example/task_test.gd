extends Node

var task: Task
var task_2: Task
var task_3: Task


# Called when the node enters the scene tree for the first time.
func _ready():
	task = Task.delayed_call(self, 2.0, print_foo)
	task_2 = Task.delayed_call(self, 3.0, print_something, ["something"])
	Task.delayed_call(self, 2.1, cancel_second_task)
	await Task.delay(0.5)
	task_3 = Task.process_call(self, process_print_call)
	await Task.delay(1.0)
	task_3 = task_3.cancel()
	await Task.delay(0.5)
	Task.delayed_call(self, 0.5, repeating_print)
	var barrier: SignalBarrier = SignalBarrier.new([Task.delay(2.0), Task.delay(3.0), \
			Task.delay(4.0)], SignalBarrier.BarrierType.ALL, 1.0)
	barrier.s_complete.connect(func(): print('signal barrier done'))
	barrier.s_timeout.connect(func(): print('signal barrier timeout'))

func print_foo():
	print('Foo')

func print_something(something: String):
	print(something)

func cancel_second_task():
	task_2 = task_2.cancel()

func process_print_call(delta):
	print('Processing.')

func repeating_print():
	print('This is a repeating print.')
	return Task.AGAIN
