extends TileMapLayer
# ==============================================
# マップ.
# ==============================================
class_name Map

# ----------------------------------------------
# 定数.
# ----------------------------------------------
const AREA_WIDTH := 19 # 1つのエリアの幅. セル数で指定.
const AREA_HEIGHT := 15 # 1つのエリアの高さ. セル数で指定.
const CELL_SIZE := 32.0 # 1つのセルのサイズ.
const CELL_VECTOR := Vector2(CELL_SIZE, CELL_SIZE) # 1つのセルのサイズベクトル.
const TILE_NONE = 0 # Array2Dで何もないとする番号.
const TILE_WALL = 1 # Array2Dで通行不可とする番号.
const ATLAS_COORDS_BLOCK := Vector2i(1, 0) # TileMapLayerのブロックタイル.
# ■preloads.
const FOOD_OBJ = preload("res://src/objects/Food.tscn") # エサのシーン.

# ■onready.
# AStarノードを生成
@onready var _astar_node = AStar2D.new()

# ----------------------------------------------
# メンバ変数.
# ----------------------------------------------
# タイルマップ.
var _array:Array2D = Array2D.new(AREA_WIDTH, AREA_HEIGHT) # タイルの配置を管理する2次元配列.
var _obstacles:Array[Vector2i] # 障害物の位置リスト.
var _wallables:Array[Vector2i] # 通行可能な位置リスト.
# ----------------------------------------------
# メンバ関数.
# ----------------------------------------------
# ■public関数.
# エサの配置.
func put_food() -> void:
	var list = _array.find_all(TILE_NONE) # 値が0のセルをすべて取得する.
	list.shuffle() # ランダムに並び替える.
	for i in range(min(10, list.size())):
		var cell = list[i]
		var pos = cell_to_pos(cell) # セル座標から位置に変換.
		# エサの配置.
		_spawn_food_xy(pos)

# ■private関数.
# 開始.
func _ready() -> void:
	_array.fill(TILE_WALL) # 壁で埋める.
	var start = Vector2i(1, 1)
	var end = Vector2i(AREA_WIDTH - 2, AREA_HEIGHT - 2)
	_array.dig(start, end, TILE_WALL) # スタートからゴールまで掘る.
	
	# 通路以外にもランダムで穴を開けてみる.
	for i in range(32):
		var halfX = (AREA_WIDTH-2) / 2.0
		var halfY = (AREA_HEIGHT-2) / 2.0
		var x = 1 + (randi() % int(halfX * 2))
		var y = 1 + (randi() % int(halfY * 2))
		_array.setv(x, y, TILE_NONE) # ランダムに穴を掘る.

	# タイルマップにも反映する.
	_array.foreach(func(x, y, v):
		if v == TILE_WALL:
			_set_block(x, y) # ブロックの配置.
	)

	# -----------------------
	# 以下、A*のセットアップ.
	# -----------------------
	# ブロックタイルのcell座標系リストを取得.
	_obstacles = get_used_cells_by_id(-1, ATLAS_COORDS_BLOCK)
	# 移動可能なタイルのcell座標系リストを取得.
	_wallables = _get_walkable_cells(_obstacles)
	# A*ノードに移動可能な位置を登録.
	_astar_register_walkable_cells(_wallables)
	# A*ノードに移動可能な位置の接続関係を登録.
	_astar_connect_walkable_cells(_wallables)

# ブロックの配置.
func _set_block(x:int, y:int) -> void:
	set_cell(Vector2i(x, y), 0, ATLAS_COORDS_BLOCK)

# ------------------------------------------------------------
# 以下、A* 用のコード.
# ------------------------------------------------------------
# 移動可能な位置のリストを作成する
func _get_walkable_cells(obs:Array[Vector2i] = []) -> Array[Vector2i]:
	# 結果
	var result:Array[Vector2i]
	
	# マップのすべての要素をチェックする
	for j in range(AREA_HEIGHT):
		for i in range(AREA_WIDTH):
			
			# ポイントを作成する
			var p := Vector2i(i, j)
			if p in obs:
				continue # 障害物は含めない
			
			# 移動できるので結果に登録する
			result.append(p)
			
	return result

# 移動可能な位置をA*に登録.
func _astar_register_walkable_cells(cells:Array[Vector2i]) -> void:
	# 移動可能な位置をAStarに登録する
	for p in cells:
		# 位置をインデックスに変換する
		var index = _cell_to_index(p.x, p.y)
		# 登録.
		var weight_scale = 1.0 # 重み付けしたい場合はこの値の修正が必要.
		_astar_node.add_point(index, p, weight_scale)

# 移動可能な位置の接続の構築 (斜め移動は許可しない).
func _astar_connect_walkable_cells(cells:Array[Vector2i]) -> void:
	for p in cells:
		# インデックスに変換する
		var index := _cell_to_index(p.x, p.y)
		
		# 上下左右に接続する
		var points_ralative := Array([
			Vector2(p.x + 1, p.y), # 右
			Vector2(p.x - 1, p.y), # 左
			Vector2(p.x, p.y + 1), # 下
			Vector2(p.x, p.y - 1)]) # 上
		
		# 上下左右を調べる
		for p_relative in points_ralative:
			if is_outside_map_bounds(p_relative):
				continue # 領域外なので接続できない
			# インデックスに変換
			var relative_index = _cell_to_index(p_relative.x, p_relative.y)
			
			if not _astar_node.has_point(relative_index):
				continue # 移動不可なので接続できない
			
			# インデックス同士を接続する
			# 第3引数がfalseなので、index -> relative_index への一方通行を許可
			_astar_node.connect_points(index, relative_index, false)

# 経路探索実行 (ワールド座標の移動リストを返す).
func _recalculate_path(start_pos:Vector2, end_pos:Vector2, center:bool=true) -> PackedVector2Array:
	# ワールド座標 > セル座標.
	var start_cell := pos_to_cell(start_pos, center)
	var end_cell := pos_to_cell(end_pos, center)
	# セル座標 > インデックス座標.
	var start_index := _cell_to_index(start_cell.x, start_cell.y)
	var end_index := _cell_to_index(end_cell.x, end_cell.y)
	
	# 経路探索実行.
	var point_list:PackedVector2Array = _astar_node.get_point_path(start_index, end_index)
	
	# ワールド座標に変換する
	for i in range(point_list.size()):
		point_list[i] = cell_to_pos(Vector2i(point_list[i]), center)

	return point_list

# ----------------------------------------------
# static関数.
# ----------------------------------------------
# ■private関数.
static func is_outside_map_bounds(cell: Vector2i) -> bool:
	if cell.x < 0 or cell.y < 0 or cell.x >= AREA_WIDTH or cell.y >= AREA_HEIGHT:
		return true # 領域外.
	return false
# cell座標系 -> ワールド座標系.
static func cell_to_pos(cell: Vector2i, center: bool=true) -> Vector2:
	return _cell_to_pos(cell.x, cell.y, center)

# ワールド座標系 -> cell座標系.
static func pos_to_cell(pos: Vector2, center:bool=true) -> Vector2:
	return _pos_to_cell(pos, center)

# cell座標系 -> インデックス座標系.
static func cell_to_index(cell: Vector2i) -> int:
	return _cell_to_index(cell.x, cell.y) 

# 経路探索実行.
static func recalculate_path(start_pos:Vector2, end_pos:Vector2, center:bool=true) -> PackedVector2Array:
	var map = Common.get_map()
	if is_instance_valid(map):
		return map._recalculate_path(start_pos, end_pos, center)
	return []

# デバッグ用にランダムでエサを配置する.
static func debug_spawn_foods(parent: Node):
	randomize()
	for i in range(10):
		var cell = Vector2i(randi() % AREA_WIDTH, randi() % AREA_HEIGHT)
		var pos = cell_to_pos(cell)
		var food = FOOD_OBJ.instantiate()
		food.set_attribute(Attribute.get_random()) # エサの属性をランダムに設定.
		food.position = pos
		# 現在のシーンを取得.
		parent.add_child(food)

# ■private関数.
static func _cell_to_pos(x:int, y:int, center:bool) -> Vector2:
	# セル座標からワールド座標を計算して返す.
	var base = Vector2(x * CELL_SIZE, y * CELL_SIZE)
	if center:
		# セルの中心位置を返す.
		base += CELL_VECTOR * 0.5
	return base
	
static func _pos_to_cell(pos:Vector2, center:bool) -> Vector2i:
	# ワールド座標からセル座標に変換して返す.
	var world_pos := pos
	if center:
		# セルの中心を左上に移動.
		#world_pos -= CELL_VECTOR * 0.5
		pass # 左上寄せは不要そう...
	var base := Vector2i(world_pos.x/CELL_SIZE, world_pos.y/CELL_SIZE)
	return base

static func _cell_to_index(x:int, y:int) -> int:
	# セル座標からインデックス座標に変換する.
	var index = x + (y * AREA_WIDTH)
	return index

static func _index_to_cell(index:int) -> Vector2i:
	# インデックス座標系からセル座標系に変換する.
	return Vector2i(index%AREA_WIDTH, index/AREA_WIDTH)

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
