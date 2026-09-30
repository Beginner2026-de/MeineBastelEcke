extends OptionButton

func _on_item_selected(index: int) -> void:
	ThemeManager.GetColorForThemesByIndex(index)
