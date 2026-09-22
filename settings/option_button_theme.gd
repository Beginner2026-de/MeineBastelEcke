extends OptionButton

func _on_item_selected(index: int) -> void:
	var list_themes = [load("res://UI/Theme/Dunkel.tres"),
	load("res://UI/Theme/Hell.tres"),
	load("res://UI/Theme/Braun.tres")]
	
	print("Index theme button " +str(index))
	get_tree().root.theme = list_themes[index]
