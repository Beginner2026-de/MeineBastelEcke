class_name POPUP_ZUM_LADEN
extends PopupPanel
@onready var button_container: VBoxContainer = $"Hintergrund/MarginContainer/VBoxContainer/Spielstande container/Spielstände button container"

const neuepeicher_zelle: Resource = preload("res://utils/SaveManager/Popup_zum_laden/zeile_mit_speicherstand.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func speicherstände_button_laden(APP_NAME: String) -> void:
	var liste_der_speicherstände: PackedStringArray = SaveManager.get_list_of_speicherstände(APP_NAME)
	for speicherstand: String in liste_der_speicherstände:
		var neue_speicher_stand_zelle: Control = neuepeicher_zelle.instantiate()
		button_container.add_child(neue_speicher_stand_zelle)
		neue_speicher_stand_zelle.init(speicherstand)
		#neuer_button.text = speicherstand
		#neuer_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		

func _on_abbrechen_pressed() -> void:
	queue_free()
