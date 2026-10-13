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
	queue_redraw()

# --- HAUPT-ZEICHENMETHODE ---
func _draw() -> void:
	# SICHERHEITS-CHECK: Zeichne nur, wenn alle Farbobjekte gültige Color-Instanzen sind
	if not _are_colors_valid():
		return
		
	_update_canvas_size()
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
	var rect: Rect2 = Rect2(Vector2.ZERO, canvas_size)
	draw_rect(rect, background_color, true)
	draw_rect(rect, border_color, false, 2.0)


func _draw_center_line() -> void:
	var center_y: float = canvas_size.y / 2.0
	var start_point: Vector2 = Vector2(margin.x, center_y)
	var end_point: Vector2 = Vector2(canvas_size.x - margin.x, center_y)
	
	draw_line(start_point, end_point, center_line_color, 1.0)


func _draw_wave() -> void:
	if num_points != 0:
		var points_to_draw: PackedVector2Array = _calculate_wave_points()
	
		if points_to_draw.size() >= 0:
			#print(points_to_draw)
			draw_polyline(points_to_draw, line_color, 2.5, true)
		
func _calculate_wave_points() -> PackedVector2Array:
	var result_points: Array = PackedVector2Array()

	# Fallback, falls das Array noch nicht initialisiert wurde
	#if points_for_line.is_empty():
	#	return result_points
	if num_points != points_for_line.size():
		anpassung_der_wellen_punkte()
		
	# 1. Alle vorhandenen y-Werte um eine Position nach links verschieben
	# Wir überschreiben Index i mit dem Wert von Index i + 1
	for i: int in range(points_for_line.size() - 1):
		points_for_line[i].y = points_for_line[i + 1].y
	
	# 2. Den NEUEN Sinus-Wert für den ganz rechten Punkt berechnen
	# ACHTUNG: new_point muss ein Vector2 sein, nicht nur ein float!
	#print(points_for_line.size())
	var last_index: int = points_for_line.size() - 1
	var last_x: float = points_for_line[last_index].x
	
	points_for_line[last_index] = Vector2(last_x, new_point_y)
	# 3. Das erstelle Array in ein PackedVector2Array umwandeln und mit Rand/Margin versehen
	for point: Vector2 in points_for_line:
		result_points.append(point + Vector2(margin.x, 0))
	return result_points

	
func anpassung_der_wellen_punkte() -> void:
	var center_y: float = canvas_size.y / 2.0
		
	var neu_punkte_anzahl: int = num_points
	var aktuelle_punkte_anzahl: int = points_for_line.size()
	while aktuelle_punkte_anzahl != neu_punkte_anzahl:
		if aktuelle_punkte_anzahl > neu_punkte_anzahl:
			points_for_line.pop_at(0)
			aktuelle_punkte_anzahl -= 1
		elif aktuelle_punkte_anzahl < neu_punkte_anzahl:
			points_for_line.append(Vector2(aktuelle_punkte_anzahl * abstand, center_y))
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
	var width_of_canvas: float = (num_points) + (margin.x * 2)
	var height: float = (liste_der_letzten_400_amplituden_punkte.max() * 2.0) + (margin.y * 2)

	_is_updating_size = true
	canvas_size = Vector2(width_of_canvas, height)
	# Wichtig für Controls im GraphNode:
	custom_minimum_size = canvas_size 
	_is_updating_size = false
