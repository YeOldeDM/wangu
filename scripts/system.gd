
extends Panel

var game			#Game node
var options			#options gui button
var options_dialog	#options dialog box

var fullscreen = false
func _set_screen_mode():
	OS.set_window_fullscreen(fullscreen)

func _ready():
	game = get_parent()
	options = get_node('options')
	options_dialog = get_node('options/options_dialog')
	_set_screen_mode()



func _on_options_pressed():
	if not options.is_disabled():
		raise()
		options_dialog.raise()
		options_dialog.popup()
		options.set_disabled(true)


func _on_options_dialog_focus_exit():
	if options.is_disabled():
		options.set_disabled(false)


func _on_autoload_check_toggled( pressed ):
	game.autoload = pressed
	prints("Auto-load", game.autoload)


func _on_autosave_check_toggled( pressed ):
	if pressed == true:
		game.autosave_interval = options_dialog.get_node('autosave_check/length').get_value()
	game.autosave = pressed

func _on_apply_pressed():
	fullscreen = options_dialog.get_node('fullscreen_check').is_pressed()
	_set_screen_mode()


func _on_options_dialog_about_to_show():
	game.is_menu_open = true

	options_dialog.get_node('autoload_check').set_pressed(game.autoload)
	options_dialog.get_node('autosave_check').set_pressed(game.autosave)
	options_dialog.get_node('autosave_check/length').set_value(game.autosave_interval)
	options_dialog.get_node('fullscreen_check').set_pressed(fullscreen)


func _on_options_dialog_popup_hide():
	options.set_disabled(false)
	game.is_menu_open = false


func _on_options_dialog_focus_enter():
	options_dialog.raise()
	game.raise()


func _on_length_value_changed( value ):
	if game.autosave:
		game.autosave_interval = int(value)
