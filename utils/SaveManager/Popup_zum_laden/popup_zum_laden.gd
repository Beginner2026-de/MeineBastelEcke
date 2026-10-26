extends Control
@onready var button_container: VBoxContainer = $"Hintergrund/MarginContainer/VBoxContainer/Spielstande container/Spielstände button container"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func speicherstände_button_laden(APP_NAME: String) -> void:
	var liste_der_speicherstände: PackedStringArray = SaveManager.get_list_of_speicherstände(APP_NAME)
	print(liste_der_speicherstände)
	for speicherstand: String in liste_der_speicherstände:
		var neuer_button: Button = Button.new()
		neuer_button.text = speicherstand
		neuer_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button_container.add_child(neuer_button)

func _on_abbrechen_pressed() -> void:
	queue_free()
