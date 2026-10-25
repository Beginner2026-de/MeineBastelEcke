extends Node


# Spielstand speichern
func save_resource(current_data: Resource, SAVE_PATH: String) -> String:
	# 1. Den Ordner-Pfad aus dem Dateipfad extrahieren (z. B. "user://wellen")
	var dir_path: String = SAVE_PATH.get_base_dir()
	
	# 2. Ordner automatisch erstellen, falls er noch nicht existiert
	var dir_error: Error = DirAccess.make_dir_recursive_absolute(dir_path)
	if dir_error != OK:
		return "Fehler beim Erstellen des Ordners: " + str(dir_error)
	
	# 3. Jetzt erst die Datei speichern
	var error: Error = ResourceSaver.save(current_data, SAVE_PATH)
	if error == OK:
		return "Spielstand erfolgreich gespeichert"
	else:
		return "Fehler beim Speichern"
