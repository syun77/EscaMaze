extends TileMapLayer
# ==============================================
# マップ.
# ==============================================
class_name Map

# 定数.
const AREA_WIDTH := 19 # 1つのエリアの幅. セル数で指定.
const AREA_HEIGHT := 15 # 1つのエリアの高さ. セル数で指定.
const CELL_SIZE := 32.0 # 1つのセルのサイズ.
const CELL_VECTOR := Vector2(CELL_SIZE, CELL_SIZE) # 1つのセルのサイズベクトル.

const FOOD_OBJ = preload("res://src/objects/Food.tscn") # エサのシーン.

# タイルマップ.
var _array:Array2D = Array2D.new(AREA_WIDTH, AREA_HEIGHT) # タイルの配置を管理する2次元配列.

# 開始.
func _ready() -> void:
	_array.fill(1) # 壁で埋める.
	var start = Vector2i(1, 1)
	var end = Vector2i(AREA_WIDTH - 2, AREA_HEIGHT - 2)
	_array.dig(start, end, 1) # スタートからゴールまで掘る.
	
	# 通路以外にもランダムで穴を開けてみる.
	for i in range(32):
		var halfX = (AREA_WIDTH-2) / 2.0
		var halfY = (AREA_HEIGHT-2) / 2.0
		var x = 1 + (randi() % int(halfX * 2))
		var y = 1 + (randi() % int(halfY * 2))
		_array.setv(x, y, 0) # ランダムに穴を掘る.

	# タイルマップにも反映する.
	_array.foreach(func(x, y, v):
		if v == 1:
			_set_block(x, y) # ブロックの配置.
	)
	
# エサの配置.
func put_food() -> void:
	var list = _array.find_all(0) # 値が0のセルをすべて取得する.
	list.shuffle() # ランダムに並び替える.
	for i in range(min(10, list.size())):
		var cell = list[i]
		var pos = cell_to_pos(0, cell) # セル座標から位置に変換.
		# エサの配置.
		_spawn_food_xy(pos)

# ブロックの配置.
func _set_block(x:int, y:int) -> void:
	set_cell(Vector2i(x, y), 0, Vector2i(1, 0)) # デバッグ用にタイルを1つ置いておく.

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
		food.set_attribute(Attribute.get_random()) # エサの属性をランダムに設定.
		food.position = pos
		# 現在のシーンを取得.
		parent.add_child(food)

# エサの配置.
static func _spawn_food_xy(pos:Vector2, attr:Attribute.eAttr=Attribute.eAttr.NONE) -> void:
	if attr == Attribute.eAttr.NONE:
		attr = Attribute.get_random() # 未指定の場合はランダム.
	
	# Foodインスタンスを生成.
	var food = FOOD_OBJ.instantiate()
	food.set_attribute(Attribute.get_random()) # エサの属性をランダムに設定.
	food.position = pos
	# FoodLayerに登録.
	var layer = Common.get_layer("food")
	layer.add_child(food)
