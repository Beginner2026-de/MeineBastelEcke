extends GraphNode
class_name DataNode

signal data_changed(key: String, value: Variant)

class NodeData:
	var frequency: float = 2.0
	var amplitude: float = 50.0
	var visible_cycles: float = 2.0
	var num_points: int = 300

# Instanz der Datenklasse erzeugen
var local_data: NodeData = NodeData.new()
func _ready() -> void:
	for inhalt in local_data.get_property_list():
		if inhalt.usage &  PROPERTY_USAGE_SCRIPT_VARIABLE:
			var key: String = inhalt.name
			var value: Variant = local_data.get(key)
			print("wert ", value, "key ", key)
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


func _on_fre_eingabe_1_text_changed(new_text: String) -> void:
	set_data("frequency",float(new_text))


func _on_amp_eingabe_1_text_changed(new_text: String) -> void:
	set_data("amplitude",float(new_text))


func _on_n_zklen_text_changed(new_text: String) -> void:
	set_data("visible_cycles", float(new_text))


func _on_node_2d_get_data_from_haupt_control(key: String) -> Variant:
	for inhalt in local_data.get_property_list():
		if inhalt.usage &  PROPERTY_USAGE_SCRIPT_VARIABLE:
			if inhalt.name == key:
				var value: Variant = local_data.get(key)
				return value
	return
			
