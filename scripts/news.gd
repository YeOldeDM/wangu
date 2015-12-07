
extends Control

var newsbox
var format

func message(text,time_code=-1):
	newsbox.newline()
	newsbox.newline()
	var prefix ="  "
	if time_code >= 0:
		prefix = "<"+format._time(time_code)+">  "
	newsbox.append_bbcode(prefix+text)

func _ready():
	format = get_node('/root/formats')
	newsbox = get_node('cont/text')
	newsbox.set_scroll_follow(true)
	message("[color=green][b]Welcome to WANGU[/b][/color]")

