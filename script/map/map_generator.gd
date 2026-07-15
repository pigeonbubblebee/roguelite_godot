class_name MapGenerator
extends RefCounted

var start_node : MapNode
var dimension : Vector2i = Vector2i(12, 8)
var dungeon : Array
var start_node_position : Vector2i = Vector2i(0, -1)
var critical_path_size : int = 19
var branches : int = 6
var branch_length : Vector2i = Vector2i(3, 5)
var branch_candidates : Array[MapNode]

var combat_rooms = Vector2i(6, 8)
var combat_rooms_gap = Vector2i(1, 2)

var current_combat_room_gap = 0
var current_combat_rooms = 0

var critical_path : Array[MapNode]
var branch_paths : Dictionary = {}

func initialize():
	generate_map()
	place_entrance()
	
	current_combat_rooms = randi_range(combat_rooms.x, combat_rooms.y)
	current_combat_room_gap = randi_range(combat_rooms_gap.x, combat_rooms_gap.y)
	
	generate_path(start_node, critical_path_size, "C")
	generate_branches()
	decorate_path()
	add_random_connections(0.15)
	render_dungeon()
	
func decorate_path():
	set_room(
		critical_path[0],
		MapNode.RoomType.BOSS
	)
	set_room(
		critical_path[1],
		MapNode.RoomType.REST
	)
	
	var rest_candidates = branch_paths.keys()
	
	var branch = rest_candidates.pick_random()
	set_room(
		random_unused(branch_paths[branch].slice(1)),
		MapNode.RoomType.REST
	)
	rest_candidates.erase(branch)
	branch = rest_candidates.pick_random()
	set_room(
		random_unused(branch_paths[branch].slice(1)),
		MapNode.RoomType.REST
	)
	
	for b in branch_paths.values():
		var choices = b.slice(1, b.size() - 1)
		if randf() < 0.75:
			set_room(
				random_unused(choices),
				MapNode.RoomType.COMBAT
			)
			
	var branch_end_candidates = branch_paths.keys()
	for i in range(3):
		branch = branch_end_candidates.pick_random()
		set_room(
			branch_paths[branch][0],
			MapNode.RoomType.ELITE
		)
		branch_end_candidates.erase(branch)
	for i in range(2):
		branch = branch_end_candidates.pick_random()
		set_room(
			branch_paths[branch][0],
			MapNode.RoomType.TREASURE
		)
		branch_end_candidates.erase(branch)
	branch = branch_end_candidates.pick_random()
	set_room(
		branch_paths[branch][0],
		MapNode.RoomType.SHOP
	)
	branch_end_candidates.erase(branch)
	
	var occ_amount = randi_range(2,3)

	var whole_dungeon = []
	var combat_nodes = []

	whole_dungeon.append_array(critical_path)
	for b in branch_paths.values():
		whole_dungeon.append_array(b)
	combat_nodes = whole_dungeon.filter(func(n):
		return n.type == MapNode.RoomType.COMBAT
	)
	combat_nodes.shuffle()
	whole_dungeon = whole_dungeon.filter(func(n):
		return n.type == MapNode.RoomType.EMPTY
	)
	whole_dungeon.shuffle()

	for i in min(occ_amount, whole_dungeon.size()):
		whole_dungeon[i].type = MapNode.RoomType.OCCASION
	for i in range(2):
		combat_nodes[i].type = MapNode.RoomType.KEY

func place_entrance():
	if start_node_position.x < 0 or start_node_position.x >= dimension.x:
		start_node_position.x = randi_range(0, dimension.x-1)
	if start_node_position.y < 0 or start_node_position.y >= dimension.y:
		start_node_position.y = randi_range(0, dimension.y-1)
		
	start_node = MapNode.new(start_node_position, MapNode.RoomType.START)
	dungeon[start_node_position.x][start_node_position.y] = start_node
	
func add_random_connections(chance: float):
	for x in range(dimension.x):
		for y in range(dimension.y):
			var node = dungeon[x][y]

			if node == null:
				continue

			for dir in [Vector2i.RIGHT, Vector2i.UP]:
				var pos = Vector2i(x, y) + dir

				if pos.x < 0 or pos.x >= dimension.x:
					continue
				if pos.y < 0 or pos.y >= dimension.y:
					continue

				var other = dungeon[pos.x][pos.y]

				if not other:
					continue
					
				if not node:
					continue
					
				if node.neighbors.has(other):
					continue
					
				if node.type == MapNode.RoomType.BOSS or other.type == MapNode.RoomType.BOSS:
					continue

				if randf() < chance:
					node.neighbors.append(other)
					other.neighbors.append(node)	

func generate_path(from: MapNode, len: int, marker : String) -> bool:
	if len == 0:
		return true
	var current : Vector2i = from.position
	var direction : Vector2i 
	match randi_range(0, 3):
		0:
			direction = Vector2i.UP
		1:
			direction = Vector2i.DOWN
		2:
			direction = Vector2i.LEFT
		3:
			direction = Vector2i.RIGHT
	for i in 4:
		if (current.x + direction.x >= 0 and current.x + direction.x < dimension.x and 
			current.y + direction.y >= 0 and current.y + direction.y < dimension.y and
			not dungeon[current.x + direction.x][current.y + direction.y]):
			
			current = current + direction
			
			var node_type = MapNode.RoomType.EMPTY
			
			if marker == 'C' && current_combat_rooms > 0:
				if current_combat_room_gap == 0:
					node_type = MapNode.RoomType.COMBAT
					current_combat_rooms -= 1
					current_combat_room_gap = randi_range(combat_rooms_gap.x, combat_rooms_gap.y)
				else:
					current_combat_room_gap -= 1
			
			var new_node = MapNode.new(current, 
				node_type, marker)
			dungeon[current.x][current.y] = new_node
			new_node.neighbors.append(from)
			from.neighbors.append(new_node)
			
			if len > 1:
				branch_candidates.append(new_node)
			
			if generate_path(new_node, len - 1, marker):
				if marker == "C":
					critical_path.append(new_node)
				else:
					if !branch_paths.has(marker):
						branch_paths[marker] = []
					branch_paths[marker].append(new_node)
				return true
			else:
				branch_candidates.erase(new_node)
				from.neighbors.erase(new_node)
				dungeon[current.x][current.y] = 0
				current -= direction
				
		direction = Vector2i(direction.y, -direction.x)
	return false
	
func random_unused(nodes:Array) -> MapNode:
	nodes = nodes.filter(func(n): return n.type == MapNode.RoomType.EMPTY)
	if nodes.is_empty():
		return null
	return nodes.pick_random()
	
func set_room(node:MapNode, type):
	if node:
		node.type = type
	
func generate_branches():
	var branches_created : int = 0
	var candidate : MapNode
	while branches_created < branches and branch_candidates.size():
		candidate = branch_candidates[randi_range(0, branch_candidates.size()-1)]
		if generate_path(candidate, randi_range(branch_length.x, branch_length.y), 
			str(branches_created + 1)):
				
			branches_created += 1
		else:
			branch_candidates.erase(candidate)

func generate_map():
	for x in dimension.x:
		dungeon.append([])
		for y in dimension.y:
			dungeon[x].append(0)
	
func render_dungeon():
	var dungeon_string := ""

	for y in range(dimension.y - 1, -1, -1):
		var room_line := ""
		var connection_line := ""

		for x in range(dimension.x):
			var node = dungeon[x][y]

			# Room
			if node:
				room_line += "[" + str(node) + "]"
			else:
				room_line += "[ ]"

			# Horizontal connections
			if node and x < dimension.x - 1:
				var right = dungeon[x + 1][y]

				if right and node.neighbors.has(right):
					room_line += "-"
				else:
					room_line += " "

			else:
				room_line += " "


			# Vertical connections
			if node and y > 0:
				var down = dungeon[x][y - 1]

				if down and node.neighbors.has(down):
					connection_line += " | "
				else:
					connection_line += "   "
			else:
				connection_line += "   "


		dungeon_string += room_line + "\n"

		# Only print connection row if there is something
		if "|" in connection_line:
			dungeon_string += connection_line + "\n"

	print(dungeon_string)
