extends Control
@onready var manager: GraphEdit = get_node("/root/SinusSimulation2/GraphEdit")
@onready var graphnode: GraphNode = get_parent() as GraphNode

#Für die Linien berechnung
var global_time: float = 0.0
var points_for_line: Array  = []
# Hilfsvariable, um Re-Entry-Schleifen beim Zeichnen zu verhindern
var _is_updating_size: bool = false

var canvas_size: Vector2 = Vector2(400, 200)
var margin: Vector2 = Vector2(10, 10)

var new_point_y: float
var num_points: int = 0

var abstand: float = 1.0

var background_color: Color = Color(0.15, 0.15, 0.2, 0.5)
var border_color: Color = Color(0.4, 0.6, 1.0)
var line_color: Color = Color(0.2, 0.9, 0.4)
var center_line_color: Color = Color(0.3, 0.3, 0.4)

func _ready() -> void:
	start_line()
	if manager and manager.has_signal("set_new_point_wellen_zusammen_steller"):
		manager.set_new_point_wellen_zusammen_steller.connect(draw_new_point)
	
func start_line() -> void:
	points_for_line.clear()
	var center_y: float = canvas_size.y / 2.0

	for i: int in range(100):
		# Initialisiere jeden Punkt als Vector2 auf der Nulllinie (center_y)
		points_for_line.append(Vector2(i * abstand, center_y))

func draw_new_point() -> void:
	var data: Array = graphnode.get_output_data()
	num_points = data[1]
	new_point_y = data[0]
	canvas_size = Vector2(data[2][0],data[2][1])
	_update_canvas_size()
	queue_redraw()



# --- HAUPT-ZEICHENMETHODE ---
func _draw() -> void:
	# SICHERHEITS-CHECK
	if not _are_colors_valid():
		return
		
	# Wir zeichnen den Hintergrund basierend auf der tatsächlichen Größe des Controls
	_draw_background_and_border()
	_draw_center_line()
	_draw_wave()


func _are_colors_valid() -> bool:
	return (background_color is Color and 
			border_color is Color and 
			line_color is Color and 
			center_line_color is Color)


# --- HILFSFUNKTIONEN ---

func _draw_background_and_border() -> void:
	var rect: Rect2 = Rect2(Vector2.ZERO, size)
	draw_rect(rect, background_color, true)
	draw_rect(rect, border_color, false, 2.0)


func _draw_center_line() -> void:
	var center_y: float = size.y / 2.0
	# Mittellinie über die gesamte Breite ziehen
	draw_line(Vector2(0, center_y), Vector2(size.x, center_y), center_line_color, 1.0)


func _draw_wave() -> void:
	if num_points != 0 and points_for_line.size() > 0:
		var points_to_draw: PackedVector2Array = _calculate_wave_points()
	
		if points_to_draw.size() > 1:
			draw_polyline(points_to_draw, line_color, 2.5, true)
		
func _calculate_wave_points() -> PackedVector2Array:
	var result_points: PackedVector2Array = PackedVector2Array()

	if num_points != points_for_line.size():
		anpassung_der_wellen_punkte()
		
	for i: int in range(points_for_line.size() - 1):
		points_for_line[i].y = points_for_line[i + 1].y
	
	var last_index: int = points_for_line.size() - 1
	points_for_line[last_index].y = new_point_y
	
	var center_y: float = size.y / 2.0
	
	for point: Vector2 in points_for_line:
		# Wir nutzen margin.x als Offset von links
		# center_y - point.y sorgt dafür, dass die Welle um die Mitte schwingt
		result_points.append(Vector2(point.x + margin.x, center_y - point.y))
	return result_points

	
func anpassung_der_wellen_punkte() -> void:
	var neu_punkte_anzahl: int = num_points
	var aktuelle_punkte_anzahl: int = points_for_line.size()
	while aktuelle_punkte_anzahl != neu_punkte_anzahl:
		if aktuelle_punkte_anzahl > neu_punkte_anzahl:
			points_for_line.pop_at(0)
			aktuelle_punkte_anzahl -= 1
		elif aktuelle_punkte_anzahl < neu_punkte_anzahl:
			# Initialisiere mit 0.0 als Offset von der Mittellinie
			points_for_line.append(Vector2(aktuelle_punkte_anzahl * abstand, 0.0))
			aktuelle_punkte_anzahl += 1
			
	for i: int in range(points_for_line.size()):
		points_for_line[i].x = i * abstand
			

func _update_canvas_size() -> void:
	_is_updating_size = true
	#canvas_size = Vector2(width_of_canvas, height)

	if custom_minimum_size != canvas_size:
		custom_minimum_size = canvas_size
		# Den GraphNode zum Schrumpfen zwingen
		var parent: Node = get_parent()
		while parent != null:
			if parent is GraphNode:
				parent.size = Vector2.ZERO
				break
			parent = parent.get_parent()
	_is_updating_size = false
	return


func _on_foldable_container_folding_changed(_is_folded: bool) -> void:
	queue_redraw()