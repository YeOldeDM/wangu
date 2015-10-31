extends Node

func format_time(t):
	#convert time into 'hr:min:sec' format (String)
	var seconds = t
	var minutes = int(t/60)
	var hours = int(minutes / 60)
	
	seconds -= minutes*60
	minutes -= hours*60
	
	if hours < 10:
		hours = str("0",hours)
	if minutes < 10:
		minutes = str("0",minutes)
	if seconds < 10:
		seconds = str("0",seconds)
	
	return str(hours,":",minutes,":",seconds)