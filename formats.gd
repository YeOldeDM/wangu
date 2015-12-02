extends Node

func _verbose_time(t):
	var seconds = t
	var minutes = int(t/60)
	var hours = int(minutes / 60)
	var days = int(hours / 24)

	seconds -= minutes*60
	minutes -= hours*60
	days -= hours*24
	
	if days > 0:
		days = str(days,"d, ")
	else:
		days = ""

	if hours > 0:
		days = str(hours,"h, ")
	else:
		hours = ""

	if minutes > 0:
		minutes = str(minutes,"m, ")
	else:
		minutes = ""


	seconds = str(seconds,"s")

	return str(days,hours,minutes,seconds)

func _time(t):
	#format t seconds into hr:mn:sc format
	var seconds = t
	var minutes = int(t/60)
	var hours = int(minutes / 60)
	var days = int(hours / 24)

	seconds -= minutes*60
	minutes -= hours*60
	days -= hours*24

	if days <= 0:
		days = ""
	else:
		if days < 10:
			days = str("0",days,":")
		else:
			days = str(days,":")	

	if hours < 10:
		hours = str("0",hours)
	if minutes < 10:
		minutes = str("0",minutes)
	if seconds < 10:
		seconds = str("0",seconds)
	
	return str(days,hours,":",minutes,":",seconds)
	
	
func _number(n):
	var suffix = ''
	if n >= 1000000000:
		n = str(n*0.000000001).left(5)
		suffix = 'b'
	elif n >= 1000000:
		n = str(n*0.000001).left(5)
		suffix='m'
	elif n >= 10000:
		n = str(n*0.001).left(5)
		suffix = 'k'
	elif n <= 9:
		n = str(n).left(4)
	elif n <= 99:
		n = str(n).left(5)
	elif n <= 999:
		n = str(int(n)).left(6)
	else:
		n = str(n)
	return str(n,suffix)

var roman_numerals = [
		'0',
		'I',
		'II',
		'III',
		'IV',
		'V',
		'VI',
		'VII',
		'VIII',
		'IX',
		'X'
		]
var greek_abc = [
	"Alpha",
	"Beta",
	"Gamma",
	"Delta",
	"Epsilon",
	"Zeta",
	"Eta",
	"Theta",
	"Iota",
	"Kappa",
	"Lambda",
	"Mu",
	"Nu",
	"Xi",
	"Omicron",
	"Pi",
	"Rho",
	"Sigma",
	"Tau",
	"Upsilon",
	"Phi",
	"Chi",
	"Psi",
	"Omega"]
