@tool
extends Container # Oder Control

var margin: Vector2 = Vector2(10, 10)

var amplitude: float = 50.0

var frequency: float = 20.0

var visible_cycles: float = 2.0


func _ready() -> void:
	_update_minimum_size()


# Berechnet die Mindestgröße für den Parent-GraphNode/HBoxContainer
func _update_minimum_size() -> void:
	# 1. Benötigte Höhe: 2x Amplitude (oben + unten Peak) + Ränder
	var min_height = (amplitude * 2.0) + (margin.y * 2.0)
	
	# 2. Benötigte Breite: Basiert auf der Wellenlänge und den sichtbaren Zyklen
	# Pass den Faktor (z. B. 10.0) so an, wie weit die Welle gezogen werden soll
	var wavelength = frequency * 10.0 
	var min_width = (wavelength * visible_cycles) + (margin.x * 2.0)
	
	# Den Container anweisen, sich mindestens so groß zu machen
	custom_minimum_size = Vector2(min_width, min_height)
	
	# Signalisiert dem GraphNode / HBoxContainer, das Layout neu zu berechnen
	update_minimum_size()
	queue_redraw()
