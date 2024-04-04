@tool
extends EditorPlugin

const AUTOLOAD_NAME = "TaskMgr"


func _enter_tree():
	add_autoload_singleton(AUTOLOAD_NAME, "res://addons/task_mgr/task_mgr.gd")

func _exit_tree():
	remove_autoload_singleton(AUTOLOAD_NAME)
