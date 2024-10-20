extends TileMap

@export var trees: TileMap
@export var waterEdge: TileMap

@export var gc: Node
var boundsLookup = {}

func _ready():
	for tile in get_used_cells(0):
		var hashCell = gc.hashCell(Vector2(tile.x, tile.y))
		boundsLookup[hashCell] = true
	
	for tile in trees.get_used_cells(0):
		var hashCell = gc.hashCell(Vector2(tile.x, tile.y))
		boundsLookup[hashCell] = true
	
	for tile in waterEdge.get_used_cells(0):
		var hashCell = gc.hashCell(Vector2(tile.x, tile.y))
		boundsLookup[hashCell] = true

func inBounds(cell):
	var hashCell = gc.hashCell(cell)
	return hashCell in boundsLookup

func addBound(cell):
	var hashCell = gc.hashCell(Vector2(cell.x, cell.y))
	boundsLookup[hashCell] = true

func removeBound(cell):
	var hashCell = gc.hashCell(Vector2(cell.x, cell.y))
	boundsLookup.erase(hashCell)
