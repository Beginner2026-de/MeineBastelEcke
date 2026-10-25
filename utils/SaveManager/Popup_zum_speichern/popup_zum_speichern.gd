extends Control

@onready var line_edit: LineEdit = $PanelContainer/MarginContainer/VBoxContainer/LineEdit
@onready var error_nachrichten: LineEdit = $"PanelContainer/MarginContainer/VBoxContainer/Error Nachrichten"

signal speicher_den_graph_mit_dem_namen(Namen:String)

func _ready() -> void:
	error_nachrichten.visible = false
	line_edit.grab_focus()

func _on_abrechen_pressed() -> void:
	queue_free()

func _on_speichern_pressed() -> void:
	var Speicher_name: String = line_edit.text
	var error: Error  = check_speicher_name(Speicher_name)
	if error == OK:
		speicher_den_graph_mit_dem_namen.emit(Speicher_name)
		queue_free()
	
func check_speicher_name(Name: String) -> Error:
	if Name.length() < 4:
		print_error_nachricht("Name ist zu kurz")
		return FAILED
	error_nachrichten.visible  = false
	return OK
		
	
func print_error_nachricht(nachricht:String) -> void:
	error_nachrichten.add_theme_color_override("font_uneditable_color",Color.RED)
	error_nachrichten.visible  = true
	error_nachrichten.text  = nachricht
