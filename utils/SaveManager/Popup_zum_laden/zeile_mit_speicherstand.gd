class_name  ZELLE_MIT_SPEICHER_STAND
extends Control

var name_des_speicherstand: Label 

var path_zu_der_datei: String
var app_name: String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	name_des_speicherstand = $PanelContainer/MarginContainer/HBoxContainer/Name_des_speicherstand
	return


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func init(datei_path:String) -> void:
	path_zu_der_datei = datei_path
	var label_name: String =  SaveManager.get_name_vom_vollen_speicher_path(datei_path)
	name_des_speicherstand.text = label_name.replace(".tres","")
	app_name = SaveManager.get_app_vom_vollen_speicher_path(datei_path)
	return

func _on_laden_pressed() -> void:
	pass # Replace with function body.




func _on_umbennenen_pressed() -> void:
	
	pass # popup zum namen ändern anzeigen.



func _on_löschen_pressed() -> void:
	DateiBus.speicherstand_loeschen_gedrückt.emit(path_zu_der_datei)
	queue_free()
