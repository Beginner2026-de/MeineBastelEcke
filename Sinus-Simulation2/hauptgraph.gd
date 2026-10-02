extends GraphEdit

# Ein Verzeichnis, das speichert, welches Node-Skript welches Ergebnis liefert
var node_outputs: Dictionary = {}
var Liste_der_verbundenen_nodes_paare = []


func _ready() -> void:
	# Signale verbinden, um Verbindungen zu verwalten
	connection_request.connect(_on_connection_request)
	disconnection_request.connect(_on_disconnection_request)
	
func _process(delta: float) -> void:
			
	for i in Liste_der_verbundenen_nodes_paare:		
		transfer_data(i[0], i[1], i[2], i[3])

func _on_connection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	# Optische Verbindung im Graph erzeugen
	connect_node(from_node, from_port, to_node, to_port)
	
	Liste_der_verbundenen_nodes_paare.append([from_node, from_port, to_node, to_port])
	
func _on_disconnection_request(from_node: StringName, from_port: int, to_node: StringName, to_port: int) -> void:
	Liste_der_verbundenen_nodes_paare.erase([from_node, from_port, to_node, to_port])
	disconnect_node(from_node, from_port, to_node, to_port)

func transfer_data(from_node_name: StringName, _from_port: int, to_node_name: StringName, to_port: int) -> void:
	var source_node = get_node(NodePath(from_node_name))
	var target_node = get_node(NodePath(to_node_name))
	
	# 1. Daten vom Quell-Node abrufen
	var output_data = source_node.get_output_data()
	
	# 2. Daten an den Ziel-Node übergeben und dort verarbeiten
	target_node.receive_input_data(to_port, output_data)
