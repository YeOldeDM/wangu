
extends Control

var game
var current_event = 0
var event_object

var events = {
	0:	{
		'condition':	['bank','metal',10],
		'message':		"""
			You awake from your cryo-pod and climb out of the impact crater.
			The landscape around you is littered with scrap metal. Maybe you can
			do something useful with it.
			"""
	},
	
}




func _ready():
	game = get_node('/root/Game')

func _set_event(E):
	event_object = events[E]

func check_event():
	if int(event_object.key()) != current_event:
		_set_event(current_event)