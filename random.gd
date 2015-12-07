
extends Node

var prefix = [
	'Robot',
	'Cyborg',
	'Ghost',
	'Zombie',
	'Ninja',
	'Skeletal',
	'Flying',
	'Dire',
	'Pygmy',
	'Lesser',
	'Greater',
	'Vile',
	'Laser',
	'Plasma',
	]

var animals = [
	'ant',
	'bear',
	'beaver',
	'cat',
	'chicken',
	'cheetah',
	'dog',
	'duck',
	'elephant',
	'fish',
	'goat',
	'hamster',
	'hawk',
	'kitty',
	'jelly',
	'koala',
	'llama',
	'lemure',
	'lion',
	'monkey',
	'monster',
	'owl',
	'panther',
	'penguin',
	'pirate',
	'rabbit',
	'shark',
	'snail',
	'squirrel',
	'turtle',
	'taco',
	'tiger',
	'unicorn',
	'wolf',
	'whale',
	'zebra']

func random_animal():
	randomize()
	var p = int(rand_range(0,prefix.size()))
	var a = int(rand_range(0,animals.size()))
	var b = a
	var rep = true
	while rep:
		b = int(rand_range(0,animals.size()))
		if b != a:
			rep = false
	var s = prefix[p]+' '+animals[a].capitalize()+animals[b]
	return s

