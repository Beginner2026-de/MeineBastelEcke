extends GraphNode
class_name CustomNode

# Wird aufgerufen, wenn der Node seine Daten an den nächsten weitergibt
func get_output_data() -> Variant:
	# Beispiel: Inhalt eines LineEdit-Feldes oder ein verarbeiteter Wert
	var input_field = $LineEdit
	return input_field.text if input_field else "Standard-Daten"

# Wird aufgerufen, wenn dieser Node Daten von einem vorherigen Node empfängt
func receive_input_data(port: int, data: Variant) -> void:
	print("Node %s hat Daten empfangen: %s" % [name, str(data)])
	
	# Verarbeite die Daten und aktualisiere ggf. eigene Inhalte
	process_logic(data)

func process_logic(incoming_data: Variant) -> void:
	# Hier machst du deine ComfyUI-ähnliche Logik (z. B. Bildverarbeitung, Mathe, Text)
	$LabelResult.text = "Empfangen: " + str(incoming_data)

func _ready() -> void:
	# Slot 0 (erstes Kind-Element): Left-Input = true, Type = 0 | Right-Output = true, Type = 0
	# Type definiert den Datentyp (z. B. 0 für String, 1 für Image) – nur gleiche Types verbinden sich.
	set_slot(0, true, 0, Color.BLUE, true, 0, Color.GREEN)
