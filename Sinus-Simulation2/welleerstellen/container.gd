@tool
extends Container # Oder Control
signal  get_data_from_haupt_control(key: String)
var margin: Vector2 = Vector2(10, 10)

var frequency :float
var num_points :int
var amplitude :float
var visible_cycles:float

func _ready() -> void:
	get_data_from_haupt_control.emit("visible_cycles")	 
	get_data_from_haupt_control.emit("num_points")	
	aktualisiere_fenster_groesse()
	
# Berechnet die Mindestgröße für den Parent-GraphNode/HBoxContainer
func aktualisiere_fenster_groesse() -> void:
	# 1. Benötigte Höhe: 2x Amplitude (oben + unten Peak) + Ränder
	var min_height: int = int((amplitude * 2.0) + (margin.y * 2.0))
	var min_width: int = int((num_points * visible_cycles) + (margin.x * 3.0))
	
	# Den Container anweisen, sich mindestens so groß zu machen
	custom_minimum_size = (Vector2(min_width,min_height))
	size = custom_maximum_size
	
		# 2. Den übergeordneten Node suchen
	var parent: Node = get_parent()
	
	# SCHLEIFE: Wir suchen nach oben, ob dieses Element in einem GraphNode steckt
	while parent != null:
		if parent is GraphNode:
			# Wenn wir den GraphNode gefunden haben, zwingen wir IHN zum Schrumpfen!
			parent.size = Vector2.ZERO 
			break # Schleife beenden
		
		# Falls noch nicht gefunden, eine Ebene höher im Baum schauen
		parent = parent.get_parent()
	queue_redraw()

#
func _on_data_node_data_changed(key: String, value: Variant) -> void:
	#print("Einkommende Daten= Variabel ",key ," Wert ", value)
	if key == "frequency":
		frequency = value
	if key == "amplitude":
		amplitude = value
	if key == "num_points":
		num_points = int(value)
	if key == "visible_cycles":
		visible_cycles = float(value)
	
	aktualisiere_fenster_groesse()
