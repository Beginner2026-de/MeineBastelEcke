@tool
extends Node2D
class_name Welle
signal get_data_from_haupt_control(key: String)
#Für die Linien berechnung
var global_time: float = 0.0
var points_for_line: Array  = []
# Hilfsvariable, um Re-Entry-Schleifen beim Zeichnen zu verhindern
var _is_updating_size: bool = false

var canvas_size: Vector2 = Vector2(400, 200)
var margin: Vector2 = Vector2(10, 10)


var visible_cycles: float
var frequency : float
var amplitude: float
var num_points: int 

var abstand: float = 1.0

var background_color: Color = Color(0.15, 0.15, 0.2, 0.5)
var border_color: Color = Color(0.4, 0.6, 1.0)
var line_color: Color = Color(0.2, 0.9, 0.4)
var center_line_color: Color = Color(0.3, 0.3, 0.4)

func _on_data_node_data_changed(key: String, value: Variant) -> void:
	#print("Einkommende Daten= Variabel ",key ," Wert ", value)
	if key == "frequency":
		frequency = value
	if key == "amplitude":
		amplitude = value
	if key == "num_points":
		num_points = int(value)
		start_line()
	if key == "visible_cycles":
		visible_cycles = value
		anpassung_der_wellen_punkte()
		

func _ready() -> void:
	var manager: Node = SinusWellen # Oder über Pfad / Gruppe suchen
	if manager and manager.has_signal("set_new_point_wellen_ersteller"):
		manager.set_new_point_wellen_ersteller.connect(setup_redraw)

	
func start_line() -> void:
	points_for_line.clear()
	var center_y: float = canvas_size.y / 2.0
	
	if  num_points == 0:
		get_data_from_haupt_control.emit("num_points")	 
	if num_points > 0:
		for i: int in range(num_points):
			# Initialisiere jeden Punkt als Vector2 auf der Nulllinie (center_y)
			points_for_line.append(Vector2(i * abstand, center_y))

func setup_redraw(p_time: float) -> void:
	# p_time umbenannt, damit die Member-Variable global_time angesprochen wird
	global_time = p_time
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
	var points: PackedVector2Array = _calculate_wave_points()
	
	if points.size() > 1:
		draw_polyline(points, line_color, 2.5, true)
var punkt_der_gesendet_wird:float
func _calculate_wave_points() -> PackedVector2Array:
	var result_points: Array = PackedVector2Array()
	var center_y: float = canvas_size.y / 2.0
	
	# Fallback, falls das Array noch nicht initialisiert wurde
	if points_for_line.is_empty():
		return result_points
		
	# 1. Alle vorhandenen y-Werte um eine Position nach links verschieben
	# Wir überschreiben Index i mit dem Wert von Index i + 1
	for i: int in range(points_for_line.size() - 1):
		points_for_line[i].y = points_for_line[i + 1].y
	
	# 2. Den NEUEN Sinus-Wert für den ganz rechten Punkt berechnen
	# ACHTUNG: new_point muss ein Vector2 sein, nicht nur ein float!
	var last_index: int = points_for_line.size() - 1
	var last_x: float = points_for_line[last_index].x
	
	var new_y_point: float = center_y - (sin(frequency * global_time) * amplitude)
	punkt_der_gesendet_wird = sin(frequency * global_time) * amplitude
	points_for_line[last_index] = Vector2(last_x, new_y_point)
	# 3. Das erstelle Array in ein PackedVector2Array umwandeln und mit Rand/Margin versehen
	for point: Vector2 in points_for_line:
		result_points.append(point + Vector2(margin.x, 0))
	return result_points

func get_new_y_point_and_num_points()-> Array:
	#print("punkt_der_gesendet_wird ",punkt_der_gesendet_wird)
	#print("num points ", points_for_line.size())
	return [punkt_der_gesendet_wird, points_for_line.size()]
	
func anpassung_der_wellen_punkte()-> void:
	var center_y: float = canvas_size.y / 2.0
	var neu_punkte_anzahl:int  = roundi(visible_cycles * num_points)
	var aktuelle_punkte_anzahl: int = points_for_line.size()
	
	if neu_punkte_anzahl == 0:
		points_for_line.clear()
		#points_for_line.append(Vector2(1 * abstand, center_y))
		return
	while aktuelle_punkte_anzahl != neu_punkte_anzahl:
		if aktuelle_punkte_anzahl > neu_punkte_anzahl:
			points_for_line.pop_at(0)
			aktuelle_punkte_anzahl -= 1
		if aktuelle_punkte_anzahl < neu_punkte_anzahl:
			points_for_line.append(Vector2(aktuelle_punkte_anzahl * abstand, center_y))
			aktuelle_punkte_anzahl += 1
	print("Neue Punkte-Anzahl: ", points_for_line.size())
		
func _update_canvas_size() -> void:
	var width: float = (num_points * visible_cycles) + (margin.x * 2)
	var height: float = (amplitude * 2.0) + (margin.y * 2)
	
	# Verhindert, dass die Zuweisung erneut queue_redraw() auslöst
	_is_updating_size = true
	canvas_size = Vector2(width, height)
	_is_updating_size = false
