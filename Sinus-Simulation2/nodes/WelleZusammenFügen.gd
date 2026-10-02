extends GraphNode

func receive_input_data(to_port, data):
	print("Port ", to_port, " data ", data)
	get_node("uid://c70ygujtkuvn7").print_new_ponit(data)
