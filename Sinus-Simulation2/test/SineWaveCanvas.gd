@tool
extends Node2D

var amplitude: float = 50
var frequency: float = 20
var visible_cycles: int = 2

@export var margin: Vector2 = Vector2(20, 20)


# Berechnete Canvas-Größe
var canvas_size: Vector2 = Vector2.ZERO
func _ready() -> void:
	var manager = SinusWellen # Oder über Pfad / Gruppe suchen
	if manager and manager.has_signal("set_new_point_wellen_ersteller"):
		manager.set_new_point_wellen_ersteller.connect(_set_new_point_wellen_ersteller)


func _update_canvas_size() -> void:
	# Wellenlänge λ in Pixeln (willkürliche Basis-Skalierung, z. B. 100px pro Zyklus bei Frequenz 1.0)
	var wavelength = 200.0 / frequency
	
	# Gesamte Breite = Wellenlänge * Anzahl der Wellen + Ränder
	var width = (wavelength * visible_cycles) + (margin.x * 2)
	
	# Gesamte Höhe = 2x Amplitude (oben + unten) + Ränder
	var height = (amplitude * 2.0) + (margin.y * 2)
	
	canvas_size = Vector2(width, height)

func _set_new_point_wellen_ersteller(gloabal_time: float) -> void:
	_update_canvas_size()
	# 1. Canvas-Hintergrund & Rahmen zeichnen
	var rect = Rect2(Vector2.ZERO, canvas_size)
	draw_rect(rect, Color(0.15, 0.15, 0.2, 0.5), true) # Hintergrund
	draw_rect(rect, Color(0.4, 0.6, 1.0), false, 2.0)   # Rahmen
	
	# 2. Nulllinie (Zentriert in der Höhe)
	var center_y = canvas_size.y / 2.0
	draw_line(Vector2(margin.x, center_y), Vector2(canvas_size.x - margin.x, center_y), Color(0.3, 0.3, 0.4), 1.0)
	
	# 3. Sinus-Welle berechnen und zeichnen
	var draw_width = canvas_size.x - (margin.x * 2)
	var points = PackedVector2Array()
	var step_size = 2.0 # Pixel-Schrittweite für glatte Linie
	
	var x = 0.0
	while x <= draw_width:
		# Mathematische Formel: y = A * sin(2 * PI * f * (x / λ_base))
		var progress = x / draw_width
		var angle = progress * visible_cycles * TAU
		var y = center_y - (sin(angle * frequency* gloabal_time) * amplitude)
		
		points.append(Vector2(x + margin.x, y))
		x += step_size
	
	if points.size() > 1:
		draw_polyline(points, Color(0.2, 0.9, 0.4), 2.5, true)
