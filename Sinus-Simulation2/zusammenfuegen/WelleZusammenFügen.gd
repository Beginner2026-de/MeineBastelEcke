extends GraphNode
@onready var line: Control = $"Control für signal 2"
@onready var control_1: Control = $"Control für signal 1"

var margin: Vector2 = Vector2(10, 10)

var list_for_all_data: Array = [0.0,0.0]
func receive_input_data(to_port: int, data: Array) -> void:
	#print("Port ", to_port, " data ", data)
	list_for_all_data.set(to_port,data[0])
	#print("num points zu beim zusammen füger angekommen sind ", data[1])
	#print(list_for_all_data)
	#print(list_for_all_data[0]+ list_for_all_data[1])
	control_1.resive_data(data[1],data[0])
	line.resive_data(data)
	
func get_sum_from_all_incomming_ports() -> float:
	var data_sum: float = list_for_all_data[0]+ list_for_all_data[1]
	list_for_all_data.fill(0.0)
	return data_sum
