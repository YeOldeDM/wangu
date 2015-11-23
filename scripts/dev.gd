
extends Button

var devtools = preload('res://devtools.xml')
var window=null

func _ready():
	# Initialization here
	pass




func _on_devtool_button_toggled( pressed ):
	if pressed:
		window = devtools.instance()
		window.bank = get_parent()
		window.set_pos(Vector2(600,300))
		get_tree().get_root().add_child(window)
	else:
		window.queue_free()
		window=null
