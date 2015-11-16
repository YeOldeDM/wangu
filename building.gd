
extends Button

var popup = preload('building_popup.xml')

var window = null

func _ready():
	# Initialization here
	pass




func _on_Button_mouse_enter():
	var P = popup.instance()
	P.set_pos(get_viewport().get_mouse_pos())
	get_node('/root').add_child(P)
	P.popup()
	window = P

func _on_Button_mouse_exit():
	if window != null:
		window.queue_free()
		window = null
