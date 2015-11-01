extends Node


class Building:
	var name = "Building"
	
	var description = "This is a building. It does stuff. If we keep writing text, it should wrap to the next line!"
	
	var level = 1
	
	var build_timer = 0
	var is_upgrading = false
	
	var build_time = {'base':	5, 'rate': 10}
	
	var cost = {'metal':	{'base': 0, 'rate': 0},
				'crystal':	{'base': 0, 'rate': 0},
				'fuel':		{'base': 0, 'rate': 0}}
	
	var production = {'metal':	{'base': 0, 'rate': 0},
					'crystal':	{'base': 0, 'rate': 0},
					'fuel':		{'base': 0, 'rate': 0},
					'energy':	{'base': 0, 'rate': 0}}
					
	var upkeep = 	{'metal':	{'base': 0, 'rate': 0},
					'crystal':	{'base': 0, 'rate': 0},
					'fuel':		{'base': 0, 'rate': 0},
					'energy':	{'base': 0, 'rate': 0}}
	
	func get_build_time(L=null):
		if L == null:
			L = self.level
		if L <= 1:
			return build_time['base']
		else:
			return self.get_build_time(L-1) + self.build_time['base'] + (self.build_time['rate']*(max(0,L-2)))
		
	func get(aspect='cost',resource='metal',L=1):
		if L <= 0:
			return 0
		else:
			var A = null
			if aspect == 'cost':
				A = self.cost
			elif aspect == 'production':
				A = self.production
			elif aspect == 'upkeep':
				A = self.upkeep
	
			if L <= 1:
				return A[resource]['base']
			else:
				return get(aspect,resource,L-1) + A[resource]['base'] + (A[resource]['rate'] * (max(0,L-2)))
	
	
func _ready():
	pass
