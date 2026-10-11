extends GraphNode
class_name DataNode

signal data_changed(key: String, value: Variant)

class NodeData:
	var frequency: float = 2.0
	var amplitude: float = 50.0
	var visible_cycles: float = 1.0
	var num_points: int = 225

# Instanz der Datenklasse erzeugen
var local_data: NodeData = NodeData.new()
func _ready() -> void:
	for inhalt : Dictionary in local_data.get_property_list():
		if inhalt.usage &  PROPERTY_USAGE_SCRIPT_VARIABLE:
			var key: String = inhalt.name
			var value: Variant = local_data.get(key)
			data_changed.emit(key,value)


# Setzt eine Variable dynamisch per Key-Namen und sendet das Signal
func set_data(key: String, value: Variant) -> void:
	# Prüfen, ob die Eigenschaft in NodeData existiert
	if key in local_data:
		local_data.set(key, value)
		# Signal senden (in Godot 4 bevorzugt direkte Syntax)
		data_changed.emit(key, value)
	else:
		push_error("Variable '" + key + "' existiert nicht in NodeData!")

func send_data(key: String) -> void:
	for inhalt : Dictionary in local_data.get_property_list():
		if inhalt.usage &  PROPERTY_USAGE_SCRIPT_VARIABLE:
			if inhalt.name == key:
				var value: Variant = local_data.get(key)
				data_changed.emit(key,value)

func _on_fre_eingabe_1_text_changed(new_text: String) -> void:
	set_data("frequency",float(new_text))


func _on_amp_eingabe_1_text_changed(new_text: String) -> void:
	set_data("amplitude",float(new_text))


func _on_n_zklen_text_changed(new_text: String) -> void:
	#print(type_string(typeof(float_text)))
	set_data("visible_cycles", float(new_text))


func _on_node_2d_get_data_from_haupt_control(key: String) -> void:
	send_data(key)
			
func _on_container_get_data_from_haupt_control(key: String) -> void:
	send_data(key)
	
func get_output_data() -> Array:
	return get_node("HBoxContainer/Container/Node2D").get_new_y_point_and_num_points()
