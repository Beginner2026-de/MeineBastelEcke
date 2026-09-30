extends Node

func GetColorForThemesByIndex(index : int):
	print("Index theme: ", index)
	var color_primary: Color 
	var color_hover: Color
	var color_bg: Color
	var color_text: Color 
	# Index 0: Dunkel / Schwarz (Dark Mode)
	if index == 0:
		color_primary = Color("#242528")   # Dunkles Blaugrau / Akzent
		color_hover = Color("#4B4D51")     # Etwas helleres Grau für Hover
		color_bg = Color("#111213")        # Tiefschwarzer / Sehr dunkler Hintergrund
		color_text = Color("#63666B")      # Sehr helles Weiß für gute Lesbarkeit

# Index 1: Hell / Weiß (Light Mode)
	elif index == 1:
		color_primary = Color("#8C8F97")   # Klare Primärfarbe (Blau)
		color_hover = Color("#B7B9BE")     # Dunkleres Blau für Hover
		color_bg = Color("#F0F1F2")        # Reines Weiß
		color_text = Color("#3B3D42")
		
	# Index 2: Braun (Warm / Cozy Earth Mode)
	elif index == 2:
		color_primary = Color("#7A3B00")   # Warmes Terracotta / Mittelbraun
		color_hover = Color("#9E4C00")     # Dunkleres Erdbraun für Hover
		color_bg = Color("#FCA700")        # Dunkles Schokoladenbraun für den Hintergrund
		color_text = Color("#3A2C1F")      # Cremeweiß / Beige für Text

	# Index 3: Blau
	elif index == 3:
		color_primary = Color("4e73df")
		color_hover = Color("2e59d9")
		color_bg = Color("1a1a24")
		color_text = Color("ffffff")
	
	apply_colors_to_theme(color_primary, color_hover, color_bg, color_text)


func apply_colors_to_theme(color_primary, color_hover, color_bg, color_text: Color, my_theme=load("res://UI/standart.tres")) -> void:
	# --- 1. BUTTONS (Button, OptionButton, MenuButton) ---
	var button_types = ["Button", "OptionButton", "MenuButton"]
	for b_type in button_types:
		# Farben
		my_theme.set_color("font_color", b_type, color_text)
		my_theme.set_color("font_hover_color", b_type, color_text)
		my_theme.set_color("font_pressed_color", b_type, color_text)
		my_theme.set_color("font_focus_color", b_type, color_text)
		
		# Eigene StyleBoxFlat für Normal-Zustand
		var btn_normal = StyleBoxFlat.new()
		btn_normal.bg_color = color_primary
		btn_normal.set_corner_radius_all(4)
		
		# Eigene StyleBoxFlat für Hover/Pressed-Zustand
		var btn_hover = StyleBoxFlat.new()
		btn_hover.bg_color = color_hover
		btn_hover.set_corner_radius_all(4)
		
		# Zuweisung
		my_theme.set_stylebox("normal", b_type, btn_normal)
		my_theme.set_stylebox("hover", b_type, btn_hover)
		my_theme.set_stylebox("pressed", b_type, btn_hover)
		my_theme.set_stylebox("focus", b_type, btn_hover)

	# --- 2. TAB CONTAINER (Reiter) ---
	my_theme.set_color("font_selected_color", "TabContainer", color_text)
	my_theme.set_color("font_unselected_color", "TabContainer", color_text.darkened(0.3))
	
	var tab_sel = StyleBoxFlat.new()
	tab_sel.bg_color = color_primary
	tab_sel.set_corner_radius_all(4)

	var tab_unsel = StyleBoxFlat.new()
	tab_unsel.bg_color = color_bg
	tab_unsel.set_corner_radius_all(4)

	var tab_hov = StyleBoxFlat.new()
	tab_hov.bg_color = color_hover
	tab_hov.set_corner_radius_all(4)

	my_theme.set_stylebox("tab_selected", "TabContainer", tab_sel)
	my_theme.set_stylebox("tab_unselected", "TabContainer", tab_unsel)
	my_theme.set_stylebox("tab_hovered", "TabContainer", tab_hov)
	my_theme.set_stylebox("panel", "TabContainer", tab_unsel)

	# --- 3. SLIDER (HSlider / VSlider) ---
	for s_type in ["HSlider", "VSlider"]:
		var slider_rail = StyleBoxFlat.new()
		slider_rail.bg_color = color_bg.lightened(0.1)
		slider_rail.set_corner_radius_all(2)

		var slider_grabber_area = StyleBoxFlat.new()
		slider_grabber_area.bg_color = color_primary
		slider_grabber_area.set_corner_radius_all(4)

		var slider_grabber_hover = StyleBoxFlat.new()
		slider_grabber_hover.bg_color = color_hover
		slider_grabber_hover.set_corner_radius_all(4)

		my_theme.set_stylebox("slider", s_type, slider_rail)
		my_theme.set_stylebox("grabber_area", s_type, slider_grabber_area)
		my_theme.set_stylebox("grabber_area_highlight", s_type, slider_grabber_hover)

	# --- 4. PANELS / HINTERGRÜNDE ---
	var panel_style = StyleBoxFlat.new()
	panel_style.bg_color = color_bg
	panel_style.set_corner_radius_all(4)

	my_theme.set_stylebox("panel", "PanelContainer", panel_style)
	my_theme.set_stylebox("panel", "Panel", panel_style)

	# --- 5. TEXT-EINGABEFELDER (LineEdit, TextEdit, CodeEdit) ---
	var input_types = ["LineEdit", "TextEdit", "CodeEdit"]
	for i_type in input_types:
		my_theme.set_color("font_color", i_type, color_text)
		my_theme.set_color("font_placeholder_color", i_type, color_text.darkened(0.4))
		
		# Eigene StyleBoxFlat für jedes Eingabefeld
		var input_style = StyleBoxFlat.new()
		input_style.bg_color = color_bg.lightened(0.05)
		input_style.set_corner_radius_all(4)
		input_style.border_width_bottom = 2
		input_style.border_color = color_primary
		
		my_theme.set_stylebox("normal", i_type, input_style)
		my_theme.set_stylebox("focus", i_type, input_style)

	my_theme.set_color("default_color", "RichTextLabel", color_text)
	my_theme.set_color("font_color", "Label", color_text)

	# --- 6. SCROLLBARS (HScrollBar / VScrollBar) ---
	for sb_type in ["HScrollBar", "VScrollBar"]:
		var sb_bg = StyleBoxFlat.new()
		sb_bg.bg_color = color_bg.darkened(0.1)
		sb_bg.set_corner_radius_all(4)

		var sb_grabber = StyleBoxFlat.new()
		sb_grabber.bg_color = color_primary
		sb_grabber.set_corner_radius_all(4)

		var sb_grabber_hover = StyleBoxFlat.new()
		sb_grabber_hover.bg_color = color_hover
		sb_grabber_hover.set_corner_radius_all(4)

		my_theme.set_stylebox("scroll", sb_type, sb_bg)
		my_theme.set_stylebox("grabber", sb_type, sb_grabber)
		my_theme.set_stylebox("grabber_highlight", sb_type, sb_grabber_hover)
		my_theme.set_stylebox("grabber_pressed", sb_type, sb_grabber_hover)

	# --- 7. POPUP MENÜS / DROPDOWNS ---
	var popup_bg = StyleBoxFlat.new()
	popup_bg.bg_color = color_bg
	popup_bg.set_corner_radius_all(4)

	var popup_hover = StyleBoxFlat.new()
	popup_hover.bg_color = color_hover
	popup_hover.set_corner_radius_all(4)

	my_theme.set_stylebox("panel", "PopupMenu", popup_bg)
	my_theme.set_color("font_color", "PopupMenu", color_text)
	my_theme.set_color("font_hover_color", "PopupMenu", color_text)
	my_theme.set_stylebox("hover", "PopupMenu", popup_hover)
