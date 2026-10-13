extends Control
var margin: Vector2 = Vector2(10, 10)

func resive_data(points: int, amplitude: float) -> void:
	add_float_ponit_to_list(amplitude)
	aktualisiere_fenster_groesse(points)

var liste_der_letzten_400_amplituden_punkte: Array
func add_float_ponit_to_list(new_float_point:float) -> void:
	var länge_der_liste: int = liste_der_letzten_400_amplituden_punkte.size()
	if länge_der_liste >= 600:
		liste_der_letzten_400_amplituden_punkte.remove_at(0)
		liste_der_letzten_400_amplituden_punkte.append(new_float_point)
	else:
		liste_der_letzten_400_amplituden_punkte.append(new_float_point)

	
	
# Berechnet die Mindestgröße für den Parent-GraphNode/HBoxContainer
func aktualisiere_fenster_groesse(points: int) -> void:
	# 1. Benötigte Höhe: 2x Amplitude (oben + unten Peak) + Ränder
	var min_height: int = int(((liste_der_letzten_400_amplituden_punkte.max() * 2)) )
	var min_width: int = int((points) + (margin.x * 3.0))
	
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
