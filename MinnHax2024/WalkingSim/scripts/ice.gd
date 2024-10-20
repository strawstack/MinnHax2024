extends TileMap

@export var gc: Node
var iceLookup = {}

func _ready():
	for tile in get_used_cells(0):
		var hashCell = gc.hashCell(Vector2(tile.x, tile.y))
		iceLookup[hashCell] = true

func isIce(cell):
	var hashCell = gc.hashCell(cell)
	return hashCell in iceLookup
