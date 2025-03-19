# Godot Tasks
A Task addon for Godot, designed after the TaskMgr feature within the Panda3D game engine

## Setup
To setup, simply download the repository and drag the addons folder into the root directory of your Godot project.
If you already have an addons folder, simply drag the task_mgr folder into the addons folder of your Godot project.

After that is complete, go to Project -> Project Settings -> Plugins and click enable on the "Task" plugin.

## Examples
### Task.delayed_call(self, 1.0, test_function)
Delays the `test_function` function from being called for 1 second.
### Task.process_call(self, test_function)
Begins calling the `test_function` function every frame, as if called from a `_process` function. Note that the first argument of the function call will always be a `delta` argument.
### Task.delay(0.5)
Acts as a shorthand for `get_tree().create_timer(0.5).timeout`. May be awaited.

## Other Uses
`Task.delayed_call` and `Task.process_call` return a Task object that is added as a child of the current node. Use this with `cancel_task` to cancel currently running tasks from activating.
