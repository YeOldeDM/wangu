
extends Control

var game
var current_event = 0
var event_object

var events = {
	0:	{
		'condition':	null,
		'message':		"""
			You awake from your cryo-pod and climb out of the impact crater.
			The landscape around you is littered with scrap metal. Maybe you can
			do something useful with it.
			"""
	},
	
}

func reset():
	pass
	
func save():
	var saveDict = {
	
	}
	return saveDict

func restore(data):
	pass


func _ready():
	game = get_node('/root/Game')

func _set_event(E):
	event_object = events[E]

func _process_event(params):
	var passed = false
	if params[0] == 'bank':		#require a number of a resource
		var material = params[1]
		var value  = params[2]
		if game.bank.can_afford(material,value):
			passed = true
	
	return passed

func check_event():
	if int(event_object.key()) != current_event:
		_set_event(current_event)
		var passed = _process_event(event_object['condition'])
		if passed:
			call("_event_"+str(current_event))
		
func _event_0():
	pass