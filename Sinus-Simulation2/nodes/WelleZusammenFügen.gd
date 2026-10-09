extends GraphNode

@onready var linie = %"WellezusammenFügen"

var list_for_all_data = [0.0,0.0]
func receive_input_data(to_port, data):
	#print("Port ", to_port, " data ", data)
	list_for_all_data.set(to_port,data)
	#print(list_for_all_data)
	#print(list_for_all_data[0]+ list_for_all_data[1])
	
	
	
	

func get_sum_from_all_incomming_ports():
	var data_sum: float = list_for_all_data[0]+ list_for_all_data[1]
	list_for_all_data.fill(0.0)
	return data_sum
