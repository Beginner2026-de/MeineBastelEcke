extends Node
#generel 
func get_num_points()->int:
	var num_points  : int = 465
	return num_points
func get_abstand()->float:
	var abstand : float = 0.5
	return abstand
func get_geschwindigkeit()->int:
	var geschwindigkeit : int = 2
	return geschwindigkeit
func get_simulatoin_anhalten()-> int:
	var simulatoin_anhalten : int = 0
	return simulatoin_anhalten

var global_time: float = 0.0

func _process(delta: float) -> void:
	global_time += delta * get_geschwindigkeit()
	set_new_point_wellen_ersteller.emit(global_time)
	set_new_point_wellen_zusammen_steller.emit()

#Signal um alle wellen ersteller ein neuen punkt zu erzeugen
signal set_new_point_wellen_ersteller(current_time:float)

#Signal um alle wellen zusammen füger ein neuen punkt zu erzeugen
signal set_new_point_wellen_zusammen_steller()
