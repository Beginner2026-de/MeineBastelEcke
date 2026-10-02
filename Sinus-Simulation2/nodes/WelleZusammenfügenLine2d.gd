extends Line2D

# 1. Lokale Variablen für jede Instanz definieren
# (Startwerte kannst du optional als Fallback aus SinusWellen laden)
var num_points: int = SinusWellen.get_num_points()
var abstand: float = SinusWellen.get_abstand()
var geschwindigkeit: float = SinusWellen.get_geschwindigkeit()

var bewegungs_geschwindigkeit: float = 0.0

func _ready() -> void:
	clear_points()
	start_line()
	var manager = SinusWellen # Oder über Pfad / Gruppe suchen
	if manager and manager.has_signal("set_new_point_wellen_zusammen_steller"):
		manager.set_new_point_wellen_zusammen_steller.connect(_set_new_point_wellen_zusammen_steller)

func start_line():
	for i in range(num_points):
		add_point(Vector2(i * abstand, 0))

func _set_new_point_wellen_zusammen_steller():
	var data = $"../..".get_sum_from_all_incomming_ports()
	# Punkte nach links verschieben
	for i in range(num_points - 1):
		var next_pos = get_point_position(i + 1)
		set_point_position(i, Vector2(next_pos.x - abstand, next_pos.y))
	
	# NEU: Verwendet die LOKALEN Variablen statt SinusWellen.*
	set_point_position(num_points - 1, Vector2((num_points - 1) * abstand, data))
