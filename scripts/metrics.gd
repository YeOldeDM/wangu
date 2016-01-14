
extends Control

var total_resource_gathered = [
	0,
	0,
	0,
	0
	]

func gather(mat,amt):
	total_resource_gathered[mat] += amt


