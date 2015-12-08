
extends Node

var format

var bank
var population
var combat
var news
var construction

var time_label
var game_time = 0.0

var autosave = true
var autosave_timer = 0.0	#timer in sec
var autosave_interval = 5	#in minutes

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


#	HEARTBEAT	#
func _process(delta):
	
	#GAME CLOCK
	game_time += delta
	var t = format._time(game_time)
	time_label.set_text(str("Time: ",t))
	
	#AUTOSAVE
	if autosave:
		autosave_timer += delta
		if autosave_timer >= (autosave_interval*60):	#convert minutes > seconds
			autosave_timer = 0.0
			save_game()
			news.message("auto-saving...",game_time)
	
			#MODULE PROCESSES
	#BANK
	bank.process(delta)
	#POPULATION
	population.process(delta)
	#COMBAT
	combat.process(delta)
	#NEWS
	
	#CONSTRUCTION




#######################################
###		SAVE / RESTORE / NEW GAME	###
#######################################
func save_game():
	#Save the current game state
	var saveGame = File.new()
	#open file for writing (overwrites old file, I hope??)
	saveGame.open("user://savegame.sav", File.WRITE)
	#Get save data from all modules, put them into a GlobDick
	var saveNodes = {
		'time':			game_time,
		'bank':			bank.save(),
		'population':	population.save(),
		'construction': construction.save(),
		'combat':		combat.save()
		}
	#Write to file and close it
	saveGame.store_line(saveNodes.to_json())
	news.message("[b]Game Saved![/b]",game_time)
	saveGame.close()


func load_game():
	#Load the currently-saved game state
	#Only one save slot for now.
	var saveGame = File.new()
	#Make sure our file exists:
	if !saveGame.file_exists('user://savegame.sav'):
		print("no savegame found!")
		return
	#Dict to hold json lines
	var loadNodes = {}
	#Open file to Read
	saveGame.open('user://savegame.sav', File.READ)
	#Go through file lines and append each line to loadNodes
	while (!saveGame.eof_reached()):
		loadNodes.parse_json(saveGame.get_line())
	prints("LOADING DICTS: ",loadNodes.keys(),'\n')
	
	###	DONE GETTING DATA. NOW RESTORE THE GAME MODULES	###
	saveGame.close()
	
	#Restore global game time
	prints("Setting game Time:",format._verbose_time(loadNodes['time']))
	game_time = loadNodes['time']
	
	#1.Restore Construction/Structures
	construction.restore(loadNodes['construction'])
	
	#2.Restore Population
	population.restore(loadNodes['population'])
	
	#3.Restore Bank
	bank.restore(loadNodes['bank'])
	
	#4.Restore Combat/Map
	combat.restore(loadNodes['combat'])

	news.message("[b]Game Loaded![/b]",game_time)




func new_game():
	#Set it all back to zero!
	pass




func wipe_game():
	#Clear user://savegame.sav!
	pass



func quit_game():
	get_tree().quit()





#####################
#	CHILD SIGNALS	#
#####################

func _on_save_pressed():
	get_node('sys_panel/save').set_disabled(true)
	get_node('sys_panel/save/save_confirm').popup()

func _on_save_confirm_confirmed():
	save_game()

func _on_save_confirm_popup_hide():
	get_node('sys_panel/save').set_disabled(false)



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
	quit_game()
	

func _on_exit1_pressed():	#Quit without saving
	quit_game()
