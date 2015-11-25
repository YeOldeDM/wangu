
extends Node

var prefix = [
	'Robot',
	'Cyborg',
	'Ghost',
	'Zombie',
	'Skeletal',
	'Flying',
	'Dire',
	'Pygmy',
	'Lesser',
	'Greater']

var animals = [
	'ant',
	'bear',
	'cat',
	'chicken',
	'dog',
	'duck',
	'elephant',
	'fish',
	'goat',
	'hamster',
	'hawk',
	'jelly',
	'koala',
	'llama',
	'monkey',
	'monster',
	'owl',
	'penguin',
	'pirate',
	'rabbit',
	'shark',
	'snail',
	'squirrel',
	'turtle',
	'taco',
	'unicorn',
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

