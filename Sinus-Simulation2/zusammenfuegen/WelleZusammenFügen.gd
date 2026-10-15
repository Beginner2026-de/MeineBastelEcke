extends GraphNode
@onready var line: Control = $"Control für line"
@onready var control_1: Control = $"Control für signal 1"

var margin: Vector2 = Vector2(10, 10)

var list_for_all_data: Array = [0.0,0.0]
var list_for_all_num_points: Array = [0,0]
var canvas_size_from_ersteller: Array 

func _ready() -> void:
	# Verhindert Lücken zwischen den Ports
	add_theme_constant_override("v_separation", 0)
	
	# Die Wellenanzeige (Slot 0) füllt den Node aus
	line.size_flags_vertical = Control.SIZE_EXPAND_FILL
	
	# Das untere Control (Slot 1) wird flach gemacht, damit der Punkt nach unten rutscht
	control_1.custom_minimum_size = Vector2.ZERO
	control_1.size_flags_vertical = Control.SIZE_SHRINK_END
	canvas_size_from_ersteller.append(Vector2 (0.0,0.0))
	canvas_size_from_ersteller.append(Vector2 (0.0,0.0))

func receive_input_data(to_port: int, data: Array) -> void:
	# Daten speichern
	#print("To Port ",to_port, " Data: ", data)
	list_for_all_data[to_port] = data[0]
	list_for_all_num_points[to_port] = data[1]
	canvas_size_from_ersteller[to_port] = data[2]
	
	
func get_output_data() -> Array:
	# Wir geben die summierten Daten zurück
	var summed_amplitude: float = list_for_all_data[0] + list_for_all_data[1]
	var highest_num_points: int = max(list_for_all_num_points[0], list_for_all_num_points[1])

	var get_highest_canvas_size: Array = [canvas_size_from_ersteller[0][0]+canvas_size_from_ersteller[1][0],canvas_size_from_ersteller[0][1]+canvas_size_from_ersteller[1][1]]
	list_for_all_data.fill(0.0)
	print("Großes Canvas ", get_highest_canvas_size, "Eerste Port Canvas ", canvas_size_from_ersteller[0], "Zweite Port Canvas ", canvas_size_from_ersteller[1])
	return [summed_amplitude, highest_num_points, get_highest_canvas_size]

func _on_node_löschen_pressed() -> void:
	queue_free()

func _on_node_löschen_button_pressed() -> void:
	queue_free()


func _on_node_umbenennen_text_submitted(new_text: String) -> void:
	title = new_text
