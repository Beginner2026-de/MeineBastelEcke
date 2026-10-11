extends GraphNode

func get_output_data() -> float:
	return get_node("Sinus1bereich/Control/WelleErstellenLine2d").get_new_point()
