
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
	'bean',
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
	#grab a random prefix
	var p = int(rand_range(0,prefix.size()))
	#grab a random animal name A
	var a = int(rand_range(0,animals.size()))
	#make name B == name A
	var b = a

	#Prevent duplicate names
	var rep = true
	while rep:
		#re-define B until it doesn't equal A
		b = int(rand_range(0,animals.size()))
		if b != a:
			rep = false

	#Assemble and return
	var s = prefix[p]+' '+animals[a].capitalize()+animals[b]
	return s

