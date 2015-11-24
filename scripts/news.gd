
extends Control

var newsbox

func message(text):
	newsbox.newline()
	newsbox.newline()
	
	newsbox.append_bbcode("  "+text)

func _ready():
	newsbox = get_node('cont/text')
	newsbox.set_scroll_follow(true)
	message("[color=green][b]Welcome to WANGU[/b][/color]")

