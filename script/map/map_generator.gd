class_name MapGenerator
extends RefCounted

var start_node : MapNode
var dimension : Vector2i = Vector2i(12, 8)
var dungeon : Array
var start_node_position : Vector2i = Vector2i(0, -1)
var critical_path_size : int = 10
var branches : int = 6
var branch_length : Vector2i = Vector2i(2, 4)
var branch_candidates : Array[MapNode]

func initialize():
	generate_map()
	place_entrance()
	generate_path(start_node, critical_path_size, "C")
	generate_branches()
	render_dungeon()

func place_entrance():
	if start_node_position.x < 0 or start_node_position.x >= dimension.x:
		start_node_position.x = randi_range(0, dimension.x-1)
	if start_node_position.y < 0 or start_node_position.y >= dimension.y:
		start_node_position.y = randi_range(0, dimension.y-1)
		
	start_node = MapNode.new(start_node_position, MapNode.RoomType.START)
	dungeon[start_node_position.x][start_node_position.y] = start_node
	
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
			var new_node = MapNode.new(current, 
				MapNode.RoomType.COMBAT, marker)
			dungeon[current.x][current.y] = new_node
			new_node.neighbors.append(from)
			from.neighbors.append(new_node)
			
			if len > 1:
				branch_candidates.append(new_node)
			
			if generate_path(new_node, len - 1, marker):
				return true
			else:
				branch_candidates.erase(new_node)
				from.neighbors.erase(new_node)
				dungeon[current.x][current.y] = 0
				current -= direction
				
		direction = Vector2i(direction.y, -direction.x)
	return false
	
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
