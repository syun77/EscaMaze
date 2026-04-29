extends Node2D
# ==============================================
# マップ.
# ==============================================
class_name Map

# 定数.
const AREA_WIDTH := 20 # 1つのエリアの幅. セル数で指定.
const AREA_HEIGHT := 15 # 1つのエリアの高さ. セル数で指定.
const CELL_SIZE := 32.0 # 1つのセルのサイズ.
const CELL_VECTOR := Vector2(CELL_SIZE, CELL_SIZE) # 1つのセルのサイズベクトル.

const FOOD_OBJ = preload("res://src/objects/Food.tscn") # エサのシーン.

# static関数.
static func cell_to_pos(areaid: int, cell: Vector2i, center: bool=true) -> Vector2:
	return _cell_to_pos(areaid, cell.x, cell.y, center)

static func pos_to_cell(areaid:int, x:int, y:int, center:bool=true) -> Vector2:
	return _cell_to_pos(areaid, x, y, center)

static func _cell_to_pos(areaId:int, x:int, y:int, center:bool) -> Vector2:
	# セル座標から位置を計算して返す.
	var base = Vector2(x * CELL_SIZE, y * CELL_SIZE)
	if center:
		# セルの中心位置を返す.
		base += CELL_VECTOR * 0.5
	# エリアは2x2とする.
	var i = areaId % 2
	var j = int(areaId / 2.0)
	return base + Vector2(i * AREA_WIDTH * CELL_SIZE, j * AREA_HEIGHT * CELL_SIZE)

# デバッグ用にランダムでエサを配置する.
static func debug_spawn_foods(parent: Node):
	randomize()
	for i in range(10):
		var cell = Vector2i(randi() % AREA_WIDTH, randi() % AREA_HEIGHT)
		var pos = cell_to_pos(0, cell)
		var food = FOOD_OBJ.instantiate()
		food.position = pos
		# 現在のシーンを取得.
		parent.add_child(food)
