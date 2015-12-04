
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
	var saveGame = File.new()
	saveGame.open("user://savegame.sav", File.WRITE)
	var saveNodes = {
		'time':			game_time,
		'bank':			bank.save(),
		'population':	population.save()
		}
	saveGame.store_line(saveNodes.to_json())
	saveGame.close()


func load_game():
	var saveGame = File.new()
	if !saveGame.file_exists('user://savegame.sav'):
		print("no savegame found!")
		return
	var currentline = {}
	saveGame.open('user://savegame.sav', File.READ)
	while (!saveGame.eof_reached()):
		currentline.parse_json(saveGame.get_line())
	print(currentline)
	saveGame.close()

func new_game():
	pass


func _on_save_pressed():
	save_game()


func _on_load_pressed():
	load_game()


func _on_new_pressed():
	get_node('sys_panel/new').set_disabled(true)
	get_node('sys_panel/new/reset_confirm').popup()


func _on_reset_confirm_confirmed():
	new_game()


func _on_reset_confirm_popup_hide():
	get_node('sys_panel/new').set_disabled(false)


func _on_exit_pressed():
	save_game()
	get_tree().quit()
