
extends PopupPanel

# member variables here, example:
# var a=2
# var b="textvar"

func _ready():
	# Initialization here
	pass




func _on_PopupPanel_about_to_show(name,level,description):
	get_node('name').set_text(name)
	get_node('level').set_text(str("Level ",str(level)))
	get_node('text').clear()
	get_node('text').add_text(description)