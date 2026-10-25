extends GraphEdit
@onready var nachrichten: LineEdit = $MarginContainer2/nachrichten

# Ein Verzeichnis, das speichert, welches Node-Skript welches Ergebnis liefert
var Liste_der_verbundenen_nodes_paare: Array = []

#Signal um alle wellen ersteller ein neuen punkt zu erzeugen
signal set_new_point_wellen_ersteller(current_time:float)

#Signal um alle wellen zusammen füger ein neuen punkt zu erzeugen
signal set_new_point_wellen_zusammen_steller()
var global_time: float = 0.0
var geschwindigkeit: float = 1



func _ready() -> void:
	# Signale verbinden, um Verbindungen zu verwalten
	connection_request.connect(_on_connection_request)
	disconnection_request.connect(_on_disconnection_request)
	# NEU: Lauschen, wenn ein Node gelöscht wird
	child_exiting_tree.connect(_on_child_exiting_tree)

func _process(delta: float) -> void:
	global_time += delta * geschwindigkeit
	set_new_point_wellen_ersteller.emit(global_time)
	set_new_point_wellen_zusammen_steller.emit()

			
	for i: Array in Liste_der_verbundenen_nodes_paare:		
		transfer_data(i[0], i[1], i[2], i[3])

func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	# Optische Verbindung im Graph erzeugen
	connect_node(from_node, from_port, to_node, to_port)
	
	Liste_der_verbundenen_nodes_paare.append([from_node, from_port, to_node, to_port])
	
func _on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	Liste_der_verbundenen_nodes_paare.erase([from_node, from_port, to_node, to_port])
	disconnect_node(from_node, from_port, to_node, to_port)

func transfer_data(from_node_name: StringName, _from_port: int, to_node_name: StringName, to_port: int) -> void:
	var source_node: Node = get_node(NodePath(from_node_name))
	var target_node: Node = get_node(NodePath(to_node_name))
	
	# 1. Daten vom Quell-Node abrufen
	var output_data: Array = source_node.get_output_data()
	
	# 2. Daten an den Ziel-Node übergeben und dort verarbeiten
	target_node.receive_input_data(to_port, output_data)

# Diese Funktion wird automatisch aufgerufen, wenn ein Node gelöscht wird (queue_free)
func _on_child_exiting_tree(node: Node) -> void:
	if node is GraphNode:
		_entferne_alle_verbindungen_fuer_node(node.name)

func _entferne_alle_verbindungen_fuer_node(node_name: StringName) -> void:
	# 1. Visuelle Linien im GraphEdit trennen
	for conn: Dictionary in get_connection_list():
		if conn.from_node == node_name or conn.to_node == node_name:
			disconnect_node(conn.from_node, conn.from_port, conn.to_node, conn.to_port)
	
	# 2. Interne Liste 'Liste_der_verbundenen_nodes_paare' bereinigen
	var i: int = 0
	while i < Liste_der_verbundenen_nodes_paare.size():
		var pair: Array = Liste_der_verbundenen_nodes_paare[i]
		# Prüfen, ob der gelöschte Node Start- oder Endpunkt der Verbindung war
		if pair[0] == node_name or pair[2] == node_name:
			Liste_der_verbundenen_nodes_paare.remove_at(i)
		else:
			i += 1

func speicher_den_grapf(Speicher_name: String) -> void:
	const SpeicherStruckturWellen = preload("uid://q5irkds078yp")
	var speicher: Resource  = SpeicherStruckturWellen.new()
	
	var node_daten_liste: Array = []
	
	# 1. Alle Kinder durchgehen und nur GraphNodes herausfiltern
	for child: Node in get_children():
		if child is GraphNode:
			
			# Beispiel: Wenn du im GraphNode ein Eingabefeld (LineEdit) hast, 
			# greifst du so darauf zu (passe den Pfad an deine Node-Struktur an):
			# var input_text = child.get_node("LineEdit").text 
			
			var node_info = {
				"name": child.name,                              # Name des Nodes (wichtig zum Wiederfinden)
				"position": child.position_offset,               # WICHTIG: position_offset statt position!
				# "text_inhalt": input_text                      # Falls du innere Daten hast
			}
			node_daten_liste.append(node_info)
	
	# 2. Alle Verbindungen direkt von Godot holen
	# get_connection_list() liefert automatisch ein Array voller Dictionaries mit from, from_port, to, to_port
	var verbindungen: Array = get_connection_list()
	
	# 3. Alles in das zentrale Speicher-Objekt (SaveManager) schreiben
	speicher.graph_name = Speicher_name
	speicher.saved_nodes = node_daten_liste
	speicher.saved_connections = verbindungen
	var speicher_ort_name : String = "user://wellen/" + Speicher_name + ".tres"
	var text: String = SaveManager.save_resource(speicher,speicher_ort_name)
	print_nachricten(text)
	
func print_nachricten(text: String)-> void:
	nachrichten.visible = true
	nachrichten.text = text
	await get_tree().create_timer(4).timeout
	nachrichten.visible= false

func _on_speichern_pressed() -> void:
	# 1. Szene laden (Datentyp ist PackedScene)
	const POPUP_ZUM_SPEICHERN: PackedScene = preload("uid://cc7fyfgpo8e0f")
	
	# 2. Instanziieren (Erstellt den echten Node aus der Blaupause)
	var popup_instance: Node = POPUP_ZUM_SPEICHERN.instantiate()
	popup_instance.speicher_den_graph_mit_dem_namen.connect(speicher_den_grapf)
	# 3. Zum aktuellen Szenenbaum hinzufügen (damit es im Spiel existiert)
	get_tree().root.add_child(popup_instance)
	
	# 4. Optional: Wenn dein Pop-up ein Fenster (Window) oder ein Popup-Node ist, 
	# kannst du es direkt zentriert auf dem Bildschirm anzeigen lassen:
	if popup_instance is Window:
		popup_instance.popup_centered()
