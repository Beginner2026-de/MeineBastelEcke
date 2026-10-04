extends Button
@onready var graph_edit: GraphEdit = owner.get_node("GraphEdit")

func _on_pressed() -> void:
	var MY_GRAPH_NODE_SCENE = preload("uid://doc504xbfauql")
	# 1. Instanz der vorbereiteten Szene erstellen
	
	var node = MY_GRAPH_NODE_SCENE.instantiate() as GraphNode

	# 2. Zum GraphEdit hinzufügen
	graph_edit.add_child(node)
	
	# 3. Position an der Mauszeiger-Position setzen (inkl. Zoom und Scroll-Offset)
	var mouse_pos := graph_edit.get_local_mouse_position()
	node.position_offset = (mouse_pos + graph_edit.scroll_offset) / graph_edit.zoom
