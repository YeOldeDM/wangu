
extends Control

var total_resource_gathered = [
	0,
	0,
	0,
	0
	]

var total_bots = 0

var total_kills = 0
var total_miniboss_kills = 0
var total_megaboss_kills = 0

func gather(mat,amt):
	total_resource_gathered[mat] += amt

func reset():
	for i in total_resource_gathered:
		i=0

func save():
	var saveNodes = {
		'total_resource_gathered':	total_resource_gathered,
		'total_bots':	total_bots
		}
	return saveNodes

func restore(source):
	total_resource_gathered = source['total_resource_gathered']
	total_bots = source['total_bots']
