
extends Control

var newsbox

func message(text):
	newsbox.newline()
	newsbox.newline()
	
	newsbox.append_bbcode("  "+text)

func _ready():
	newsbox = get_node('cont/text')
	newsbox.set_scroll_follow(true)
	for i in range(100):
		message("[b]BOLD[/b] tex ttext texttex tte xttext texttextte xt texttext texttext textt ex ttextt extte xtte xttexttextte xttex ttex ttextt exttext texttext")



