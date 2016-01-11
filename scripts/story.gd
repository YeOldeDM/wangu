
extends Control

var game
var current_event = 0
var event_object = {-1: null}

var events = {
	0:	{
		'condition':	null,
		'message':		"""
You awake from your cryo-pod and climb out of the impact crater. The landscape 
around you is littered with scrap metal. Maybe you can do something useful with it.
"""
	},
	
}

func reset():
	pass
	
func save():
	var saveDict = {
	'current_event':	current_event
	}
	return saveDict

func restore(data):
	current_event = data['current_event']
	for i in range(current_event -1):
		_reward_event(i)


func _ready():
	game = get_node('/root/Game')

func _set_event(E):
	if E in events:
		event_object = events[E]

func _reward_event(E):
	var c = "_event_"+str(E)
	if has_method(c):
		call(c)

func _process_event(params):

	if params == null:
		return true
	
	elif params[0] == 'bank':		#require a number of a resource
		var material = params[1]
		var value  = params[2]
		if game.bank.can_afford(material,value):
			return true
	return false

func check_event():
	if int(event_object.keys()[0]) != current_event:
		_set_event(current_event)
		var passed = _process_event(event_object['condition'])
		if passed:
			_reward_event(current_event)
			if int(current_event+1) in events:
				current_event += 1
		
func _event_0():
	game.news.message(event_object['message'],true)
	current_event = 1