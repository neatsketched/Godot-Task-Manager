@tool
extends Object
class_name TaskUtil

static func get_object_name(obj: Variant) -> String:
	if obj is Callable:
		var method_name: String
		if obj.is_custom():
			return "LambdaFunc"
		else:
			method_name = str(obj.get_method())
			return get_object_name(obj.get_object()) + '(%s)' % method_name

	elif obj is Object:
		var script: Script = null
		if obj is Script:
			script = obj
		elif obj.get_script():
			script = obj.get_script()
		if script:
			return script.resource_path.get_file()
		
		if obj is Resource and obj.resource_name:
			return obj.resource_name
		
		var obj_name = obj.get("name")
		if not obj_name:
			obj_name = obj.get_class()
		return obj_name
	
	return str(obj)

## Gets all children of a node of the given type.
static func get_children_of_type(node: Node, type, recursive := false) -> Array[Node]:
	var children: Array[Node] = []
	for child in node.get_children():
		if is_instance_of(child, type):
			children.append(child)
		if recursive:
			children.append_array(get_children_of_type(child, type, true))
	return children
