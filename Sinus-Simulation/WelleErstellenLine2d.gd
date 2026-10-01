extends Line2D

# 1. Lokale Variablen für jede Instanz definieren
# (Startwerte kannst du optional als Fallback aus SinusWellen laden)
var num_points: int = SinusWellen.num_points
var abstand: float = SinusWellen.abstand
var geschwindigkeit: float = SinusWellen.geschwindigkeit

var amplitude: float = 50
var frequency: float = 20
var offset_x: float = 0.0
var offset_y: float = 0.0

var bewegungs_geschwindigkeit: float = 0.0

func _ready() -> void:
	clear_points()
	start_line()

func start_line():
	for i in range(num_points):
		add_point(Vector2(i * abstand, 0))

func _process(delta: float) -> void:
	# Globale Anhalte-Abfrage (falls SinusWellen das Steuerungssignal hält)
	if SinusWellen.simulatoin_anhalten == 1:
		return

	bewegungs_geschwindigkeit += geschwindigkeit * delta

	# Punkte nach links verschieben
	for i in range(num_points - 1):
		var next_pos = get_point_position(i + 1)
		set_point_position(i, Vector2(next_pos.x - abstand, next_pos.y))
	
	# NEU: Verwendet die LOKALEN Variablen statt SinusWellen.*
	var y = amplitude * sin(frequency * bewegungs_geschwindigkeit + offset_x) + offset_y
	set_point_position(num_points - 1, Vector2((num_points - 1) * abstand, y))
	
# 2. Textänderungen in den LOKALEN Variablen der Instanz speichern
func _on_amp_eingabe_1_text_changed(new_text: String) -> void:
	amplitude = float(new_text)

func _on_fre_eingabe_1_text_changed(new_text: String) -> void:
	frequency = float(new_text)

func _on_xver_eingabe_1_text_changed(new_text: String) -> void:
	offset_x = float(new_text)

func _on_yver_eingabe_1_text_changed(new_text: String) -> void:
	offset_y = float(new_text)
