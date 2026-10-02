extends GraphNode
@onready var linie = %"WellezusammenFügen"
func receive_input_data(to_port, data):
	print("Port ", to_port, " data ", data)
	linie.print_new_ponit(data)
