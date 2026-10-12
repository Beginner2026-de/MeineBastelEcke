extends Control




func _on_gotosettings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://settings/settings_scren.tscn")


func _on_sinus_wellen_simulation_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Sinus-Simulation2/grapfedit/sinusSimulation2.tscn")
