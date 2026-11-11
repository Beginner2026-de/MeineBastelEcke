extends PopupPanel
class_name POPUP_UMBENNEN

signal speicherstand_zelle_neuer_name(name:String)

@onready var zeile_neuer_name: LineEdit  = $PanelContainer/MarginContainer/VBoxContainer/neuer_name
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	zeile_neuer_name.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_abbrechen_pressed() -> void:
	queue_free()


func _on_speichern_pressed() -> void:
	var name_zelle: String = zeile_neuer_name.text
	Loggie.debug("Speicherstand umbennen gedrückt mit dem neuen namen ", zeile_neuer_name, "emit signal zum speichern")
	speicherstand_zelle_neuer_name.emit(name_zelle)
	queue_free()



func _on_neuer_name_text_submitted(_new_text: String) -> void:
	_on_speichern_pressed()
