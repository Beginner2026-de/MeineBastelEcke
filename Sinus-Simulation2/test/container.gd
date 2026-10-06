@tool
extends Control

@onready var node = $Node2D

func _ready() -> void:
	# 1. Position ABFRAGEN:
	var me_global_pos: Vector2 = global_position  # Eigene Position des Control-Nodes
	var child_global_pos: Vector2 = node.global_position  # Position des Child-Nodes (Node2D)
	
	print("Meine globale Position: ", me_global_pos)
	print("Node2D globale Position: ", child_global_pos)
	
	# 2. Position SETZEN:
	# Sets die globale Position deines Control-Nodes auf z.B. (100, 200)
	global_position = Vector2(100, 200)
	
	# Sets die globale Position des Unter-Nodes
	#node.global_position = Vector2(150, 200)
