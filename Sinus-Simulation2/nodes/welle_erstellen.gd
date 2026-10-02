extends GraphNode

func get_output_data():
	
	print("output data")
	return get_node("Sinus1bereich/Control/WelleErstellenLine2d").get_new_point()
