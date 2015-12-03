
extends Node

var format

var bank
var population
var combat
var news
var construction

var time_label
var game_time = 0.0

func _ready():
	format = get_node('/root/formats')
	#master links
	bank = get_node('Bank')
	population = get_node('population')
	combat= get_node('combat')
	news = get_node('news')
	construction = get_node('construction')
	time_label = get_node('sys_panel/time')
	
	set_process(true)


func _process(delta):
	game_time += delta
	var t = format._time(game_time)
	time_label.set_text(str("Time: ",t))
	#BANK
	bank.process(delta)
	#POPULATION
	population.process(delta)
	#COMBAT
	combat.process(delta)
	#NEWS
	
	#CONSTRUCTION

func save_game():
	pass

func load_game():
	pass

func new_game():
	pass
