extends Control
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
	
func start_line() -> void:
	points_for_line.clear()
	var center_y: float = canvas_size.y / 2.0

	for i: int in range(100):
		# Initialisiere jeden Punkt als Vector2 auf der Nulllinie (center_y)
		points_for_line.append(Vector2(i * abstand, center_y))


func resive_data(data: Array) ->void:
	num_points = data[1]
	new_point_y = data[0]
	add_float_ponit_to_list(new_point_y)
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
			


var liste_der_letzten_400_amplituden_punkte: Array = [0]
func add_float_ponit_to_list(new_float_point:float) -> void:
	var länge_der_liste: int = liste_der_letzten_400_amplituden_punkte.size()
	if länge_der_liste >= 600:
		liste_der_letzten_400_amplituden_punkte.remove_at(0)
		liste_der_letzten_400_amplituden_punkte.append(new_float_point)
	else:
		liste_der_letzten_400_amplituden_punkte.append(new_float_point)


func _update_canvas_size() -> void:
	var max_amplitude: float = 0.0
	for val in liste_der_letzten_400_amplituden_punkte:
		max_amplitude = max(max_amplitude, abs(val))
	
	var width_of_canvas: float = (num_points * abstand) + (margin.x * 2)
	var height: float = (max_amplitude * 2.0) + (margin.y * 2)
	
	# Mindesthöhe
	height = max(height, 40.0)

	_is_updating_size = true
	var new_size = Vector2(width_of_canvas, height)
	if custom_minimum_size != new_size:
		custom_minimum_size = new_size
		# Optional: GraphNode zum Schrumpfen zwingen
		var parent = get_parent()
		if parent is GraphNode:
			parent.size = Vector2.ZERO
	_is_updating_size = false
