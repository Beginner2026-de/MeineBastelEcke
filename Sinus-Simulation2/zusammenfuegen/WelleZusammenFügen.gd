extends GraphNode
@onready var linie: Line2D = %"WellezusammenFügen"
@onready var control_1: Control = $"Control-hintergrund"

var margin: Vector2 = Vector2(10, 10)

var list_for_all_data: Array = [0.0,0.0]
func receive_input_data(to_port: int, data: Array) -> void:
	#print("Port ", to_port, " data ", data)
	list_for_all_data.set(to_port,data[0])
	print("num points zu beim zusammen füger angekommen sind ", data[1])
	#print(list_for_all_data)
	#print(list_for_all_data[0]+ list_for_all_data[1])
	control_1.send_data(data[1],data[0])
	
func get_sum_from_all_incomming_ports() -> float:
	var data_sum: float = list_for_all_data[0]+ list_for_all_data[1]
	list_for_all_data.fill(0.0)
	return data_sum
