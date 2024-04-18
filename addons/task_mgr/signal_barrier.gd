extends Object
class_name SignalBarrier

signal s_complete
signal s_timeout

enum BarrierType { ANY, ALL }

@export var _signal_arr: Array[Signal] = []
@export var _barrier_type: BarrierType = BarrierType.ALL
@export var _timeout_time: float = 0.0
var _signals_completed: Array[Signal] = []
var _timeout_task_id: int = 0
var _has_timed_out: bool = false


func _init(p_signal_arr: Array[Signal] = [], p_barrier_type := BarrierType.ALL, p_timeout_time := 0.0) -> void:
	_signal_arr = p_signal_arr
	_barrier_type = p_barrier_type
	_timeout_time = p_timeout_time
	_connect_to_signals()
	if _timeout_time > 0.0:
		_timeout_task_id = TaskMgr.delayed_call(_timeout_time, _timeout)

func _connect_to_signals() -> void:
	if _signal_arr.size() == 0:
		# Emit immediately if we got no signals
		s_complete.emit()
		return

	for s: Signal in _signal_arr:
		s.connect(func(a1=null, a2=null, a3=null, a4=null, a5=null): _got_signal_emit(s))

func _got_signal_emit(s: Signal) -> void:
	if _has_timed_out:
		return

	if s not in _signals_completed:
		_signals_completed.append(s)
	if _barrier_type == BarrierType.ANY or _signals_completed.size() == _signal_arr.size():
		s_complete.emit()
		TaskMgr.cancel_task(_timeout_task_id)
		free.call_deferred()

func _timeout() -> void:
	_has_timed_out = true
	s_timeout.emit()
	free.call_deferred()
