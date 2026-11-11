extends Node

func _ready() -> void:
	DateiBus.speicherstand_loeschen_gedrückt.connect(remove_speicherstand)
	DateiBus.speicherstand_umbennen.connect(_speicherstand_umbennen)
# Spielstand speichern
func save_resource(current_data: Resource, APP_NAME: String, DATA_NAME: String) -> String:
	# 1. Den Ordner-Pfad aus dem Dateipfad extrahieren (z. B. "user://wellen")
	var full_path: String = "user://" + APP_NAME + "/" + DATA_NAME + ".tres"
	var dir_path: String = full_path.get_base_dir()
	
	# 2. Ordner automatisch erstellen, falls er noch nicht existiert
	var dir_error: Error = DirAccess.make_dir_recursive_absolute(dir_path)
	if dir_error != OK:
		return "Fehler beim Erstellen des Ordners: " + str(dir_error)
	
	# 3. Jetzt erst die Datei speichern
	var error: Error = ResourceSaver.save(current_data, full_path)
	if error == OK:
		return "Spielstand erfolgreich gespeichert"
	else:
		return "Fehler beim Speichern"

func get_list_of_speicherstände(APP_NAME: String) -> PackedStringArray:
	var dir_path: String = "user://" + APP_NAME + "/"
	var liste_der_speicherstände_im_ordner: PackedStringArray = DirAccess.get_files_at(dir_path)
	var liste_der_speicherstände_mit_follen_path: Array

	for speicherstand: String in liste_der_speicherstände_im_ordner:
		liste_der_speicherstände_mit_follen_path.append(dir_path + speicherstand)
	return liste_der_speicherstände_mit_follen_path

func get_name_vom_vollen_speicher_path(voller_path: String) -> String:
	return voller_path.get_file()

func get_app_vom_vollen_speicher_path(voller_path: String) -> String:
	return voller_path.get_base_dir()

func remove_speicherstand(full_path: String) -> void:
	var error: Error = DirAccess.remove_absolute(full_path)
	if error == OK:
		DateiBus.speicherstand_geloescht.emit()

func _speicherstand_umbennen(path: String, neuer_name: String) -> Error:
	Loggie.debug("Speicherstand im SaveManager angekommen mit dem datei path ", path, "und dem neuen namen ", neuer_name)

	# 1. Dateinamen und Verzeichnis extrahieren
	var alter_file_name: String = path.get_file()
	var verzeichnis: String = path.get_base_dir()

	# 2. Den neuen vollständigen Pfad zusammenbauen
	var neuer_path_mit_name: String = verzeichnis.path_join(neuer_name + ".tres")

	# 3. Über DirAccess die Datei physikalisch auf der Festplatte umbenennen
	var dir: DirAccess = DirAccess.open(verzeichnis)
	if not dir:
		Loggie.warn("Konnte das Verzeichnis nicht öffnen: ", verzeichnis)
		return FAILED
	
	var fehler: Error = dir.rename(path, neuer_path_mit_name)

	if fehler == OK:
		Loggie.info("Speicherstand umbennannen von ", alter_file_name, " zu ", neuer_name, " in path ", neuer_path_mit_name)
		DateiBus.speicherstand_fertig_umbenant.emit()
	else:
		Loggie.warn("Fehler beim Umbenennen der Datei! Fehlercode: ", fehler)
	
	return fehler