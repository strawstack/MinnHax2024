extends TileMap

var gc
var iceLookup = {}

func _ready():
	gc = get_tree().root.get_node("main")
	for tile in get_used_cells(0):
		var hashCell = gc.hashCell(Vector2(tile.x, tile.y))
		iceLookup[hashCell] = true

func isIce(cell):
	var hashCell = gc.hashCell(cell)
	return hashCell in iceLookup
