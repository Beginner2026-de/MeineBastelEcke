extends Node

func GetColorForThemesByIndex(index : int):
	print("Index theme: ", index)
	# --- ERWEITERTE FARBPALETTE ---
	# Hintergründe
	var color_bg_dark: Color        # Tiefste Ebene (z. B. Spiel-Hintergrund, App-Hintergrund)
	var color_bg_panel: Color       # Anhebung für Panels, Containers, Fenster

	# Interaktive Elemente (Buttons, Inputs, Slider)
	var color_surface: Color        # Normaler Zustand von Buttons / Feldern
	var color_surface_hover: Color  # Hover-Zustand (Maus bewegt sich darüber)
	var color_surface_active: Color # Pressed / Fokus-Zustand (Aktiv geklickt)

	# Akzente & Highlights
	var color_accent: Color         # Haupt-Akzentfarbe (z. B. ausgewählte Tabs, Slider-Grabber, Rahmen)
	var color_border: Color         # Subtile Ränder zur Abgrenzung von Elementen

	# Typografie / Text-Hierarchie
	var color_text_primary: Color   # Haupttext (Überschriften, wichtige Labels) - bester Kontrast
	var color_text_secondary: Color # Sekundärer Text (Untertitel, Platzhalter, Beschreibungen)

	# System-Meldungen
	var color_error: Color          # Warnungen, Abbrechen-Buttons, Fehler

	match index:
		0: # --- DUNKEL / SCHWARZ (Dark Mode) ---
			color_bg_dark        = Color("#111213") # Tiefschwarz
			color_bg_panel       = Color("#1b1c1e") # Leicht angehobenes Panel
			color_surface        = Color("#242528") # Button normal
			color_surface_hover  = Color("#35373b") # Button hover
			color_surface_active = Color("#4b4d51") # Button pressed
			color_accent         = Color("#5e81ac") # Kühles Blau als Akzent
			color_border         = Color("#2e3034") # Subtiler Rand
			color_text_primary   = Color("#e5e9f0") # Sehr helles Weiß-Grau für Haupttext
			color_text_secondary = Color("#888c94") # Gedämpftes Grau für Sekundärtext
			color_error          = Color("#bf616a") # Softes Rot

		1: # --- HELL / WEISS (Light Mode) ---
			color_bg_dark        = Color("#f0f2f5") # Softes Hellgrau als Hintergrund
			color_bg_panel       = Color("#ffffff") # Reines Weiß für Fenster/Panels
			color_surface        = Color("#e4e7eb") # Hellgrau für Buttons
			color_surface_hover  = Color("#d0d5dd") # Dunkleres Grau für Hover
			color_surface_active = Color("#b8c0cc") # Noch dunkler für Pressed
			color_accent         = Color("#1a73e8") # Material-Blau als Akzent
			color_border         = Color("#d1d5db") # Abgrenzungsränder
			color_text_primary   = Color("#111827") # Fast Schwarz für beste Lesbarkeit
			color_text_secondary = Color("#6b7280") # Mittleres Grau für Nebeninformationen
			color_error          = Color("#d93025") # Kräftiges Rot

		2: # --- BRAUN / ERDE (Warm Cozy Mode) ---
			color_bg_dark        = Color("#1f1917") # Dunkles Schokoladenbraun
			color_bg_panel       = Color("#2b221f") # Angenehmes Erdbraun
			color_surface        = Color("#3d302c") # Terracotta-Basis
			color_surface_hover  = Color("#52423c") # Helligkeitsgewinn bei Hover
			color_surface_active = Color("#69554d") # Aktivierte Fläche
			color_accent         = Color("#d97724") # Warmes Amber/Orange
			color_border         = Color("#4a3b36") # Rahmen im Ton
			color_text_primary   = Color("#f5ebd9") # Cremeweiß / Beige
			color_text_secondary = Color("#a89a8b") # Gedämpftes Sandgrau
			color_error          = Color("#c84b31") # Warmes Rostrot

		3: # --- BLAU (Modern Tech Mode) ---
			color_bg_dark        = Color("#0f172a") # Tiefes Nachtblau
			color_bg_panel       = Color("#1e293b") # Angehobenes Blau-Grau
			color_surface        = Color("#334155") # Interaktionsfläche
			color_surface_hover  = Color("#475569") # Hover
			color_surface_active = Color("#64748b") # Pressed
			color_accent         = Color("#38bdf8") # Cyan / Neonblau
			color_border         = Color("#1e293b") # Trennlinie
			color_text_primary   = Color("#f8fafc") # Strahlend Hellblau-Weiß
			color_text_secondary = Color("#94a3b8") # Gedämpftes Blau-Grau
			color_error          = Color("#f43f5e") # Neon-Rot
	
	apply_colors_to_theme(color_bg_dark,
						color_bg_panel,
						color_surface,
						color_surface_hover,
						color_surface_active,
						color_accent,
						color_border,
						color_text_primary,
						color_text_secondary)


func apply_colors_to_theme(color_bg_dark,
						color_bg_panel,
						color_surface,
						color_surface_hover,
						color_surface_active,
						color_accent,
						color_border,
						color_text_primary,
						color_text_secondary,
						my_theme=load("res://UI/standart.tres")) -> void:
							
	RenderingServer.set_default_clear_color(color_bg_dark)
	# --- 1. BUTTONS (Button, OptionButton, MenuButton) ---
	var button_types = ["Button", "OptionButton", "MenuButton"]
	for b_type in button_types:
		my_theme.set_color("font_color", b_type, color_text_primary)
		my_theme.set_color("font_hover_color", b_type, color_text_primary)
		my_theme.set_color("font_pressed_color", b_type, color_text_primary)
		my_theme.set_color("font_focus_color", b_type, color_text_primary)
		
		# Normal
		var btn_normal = StyleBoxFlat.new()
		btn_normal.bg_color = color_surface
		btn_normal.border_color = color_border
		btn_normal.border_width_bottom = 2
		btn_normal.set_corner_radius_all(4)
		
		# Hover
		var btn_hover = StyleBoxFlat.new()
		btn_hover.bg_color = color_surface_hover
		btn_hover.border_color = color_accent
		btn_hover.border_width_bottom = 2
		btn_hover.set_corner_radius_all(4)

		# Pressed
		var btn_pressed = StyleBoxFlat.new()
		btn_pressed.bg_color = color_surface_active
		btn_pressed.set_corner_radius_all(4)

		my_theme.set_stylebox("normal", b_type, btn_normal)
		my_theme.set_stylebox("hover", b_type, btn_hover)
		my_theme.set_stylebox("pressed", b_type, btn_pressed)
		my_theme.set_stylebox("focus", b_type, btn_hover)

	# --- 2. PANELS & HINTERGRÜNDE ---
	var panel_bg = StyleBoxFlat.new()
	panel_bg.bg_color = color_bg_panel
	panel_bg.border_color = color_border
	panel_bg.set_border_width_all(1)
	panel_bg.set_corner_radius_all(6)

	my_theme.set_stylebox("panel", "PanelContainer", panel_bg)
	my_theme.set_stylebox("panel", "Panel", panel_bg)

	# --- 3. TAB CONTAINER ---
	my_theme.set_color("font_selected_color", "TabContainer", color_text_primary)
	my_theme.set_color("font_unselected_color", "TabContainer", color_text_secondary)
	
	var tab_sel = StyleBoxFlat.new()
	tab_sel.bg_color = color_bg_panel
	tab_sel.border_color = color_accent
	tab_sel.border_width_top = 3
	tab_sel.set_corner_radius_all(4)

	var tab_unsel = StyleBoxFlat.new()
	tab_unsel.bg_color = color_bg_dark
	tab_unsel.set_corner_radius_all(4)

	my_theme.set_stylebox("tab_selected", "TabContainer", tab_sel)
	my_theme.set_stylebox("tab_unselected", "TabContainer", tab_unsel)
	my_theme.set_stylebox("panel", "TabContainer", panel_bg)

	# --- 4. SLIDER (HSlider / VSlider) ---
	for s_type in ["HSlider", "VSlider"]:
		var slider_rail = StyleBoxFlat.new()
		slider_rail.bg_color = color_surface
		slider_rail.set_corner_radius_all(2)

		var slider_grabber = StyleBoxFlat.new()
		slider_grabber.bg_color = color_accent
		slider_grabber.set_corner_radius_all(6)

		my_theme.set_stylebox("slider", s_type, slider_rail)
		my_theme.set_stylebox("grabber_area", s_type, slider_grabber)
		my_theme.set_stylebox("grabber_area_highlight", s_type, slider_grabber)

	# --- 5. TEXT-EINGABEFELDER & LABELS ---
	var input_types = ["LineEdit", "TextEdit", "CodeEdit"]
	for i_type in input_types:
		my_theme.set_color("font_color", i_type, color_text_primary)
		my_theme.set_color("font_placeholder_color", i_type, color_text_secondary)
		
		var input_style = StyleBoxFlat.new()
		input_style.bg_color = color_bg_dark
		input_style.border_color = color_border
		input_style.set_border_width_all(1)
		input_style.set_corner_radius_all(4)
		
		var input_focus = input_style.duplicate()
		input_focus.border_color = color_accent
		
		my_theme.set_stylebox("normal", i_type, input_style)
		my_theme.set_stylebox("focus", i_type, input_focus)

	my_theme.set_color("font_color", "Label", color_text_primary)
	my_theme.set_color("default_color", "RichTextLabel", color_text_primary)
