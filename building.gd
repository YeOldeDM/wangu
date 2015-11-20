
extends Button

var popup = preload('building_popup.xml')

var window = null

class Building:
	var name = "Building"
	var level = 0
	var description = "This is a generic building.This is a generic building.This is a generic building.This is a generic building.This is a generic building.This is a generic building.This is a generic building.This is a generic building.This is a generic building."
	
var building

func _ready():
	building = Building.new()
	get_node('name').set_text(building.name)
	get_node('level').set_text(str("Level ",str(building.level)))




func _on_Button_mouse_enter():
	var P = popup.instance()
	P.set_pos(get_viewport().get_mouse_pos())
	get_node('/root').add_child(P)
	P._on_PopupPanel_about_to_show(building.name,building.level,building.description)
	P.popup()
	window = P

func _on_Button_mouse_exit():
	if window != null:
		window.queue_free()
		window = null
