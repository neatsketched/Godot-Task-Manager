# Godot Task Manager
A Task Manager addon for Godot, designed after the Panda3D feature of the same name

## Setup
To setup, simply download the repository and drag the addons folder into the root directory of your Godot project.
If you already have an addons folder, simply drag the task_mgr folder into the addons folder of your Godot project.

After that is complete, go to Project -> Project Settings -> Plugins and click enable on the "TaskMgr" plugin.

## Examples
### TaskMgr.delayed_call(1.0, test_function, [])
Delays the `test_function` function from being called for 1 second. Any arguments may be passed into the Array.
### TaskMgr.process_call(test_function, [])
Begins calling the `test_function` function every frame, as if called from a `_process` function. Any arguments may be passed into the Array.
### TaskMgr.delay(0.5)
Acts as a shorthand for `get_tree().create_timer(0.5).timeout`. May be awaited.

## Other Uses
`TaskMgr.delayed_call` and `TaskMgr.process_call` return an integer Task ID. Use this with `TaskMgr.cancel_task` to cancel currently running tasks from activating.
