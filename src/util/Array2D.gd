extends Node
# ==============================================
# 2次元配列クラス.
# ==============================================
class_name Array2D

var defaultValue: int = 0 # デフォルト値. 配列の初期化に使用する.
var width: int = 0 # 配列の幅.
var height: int = 0 # 配列の高さ.
var _data: Array[int] = [] # 配列のデータ. 1次元配列で管理する.

# コンストラクタ.
func _init(w: int, h: int, v:int = 0):
	width = w
	height = h
	defaultValue = v
	_data = []
	for i in range(w * h):
		_data.append(v)

# 範囲外かどうか.
func is_out_of_range(x: int, y: int) -> bool:
	return x < 0 or x >= width or y < 0 or y >= height

# 配列の値を取得する.
func getv(x: int, y: int) -> int:
	if is_out_of_range(x, y):
		return -1 # 範囲外は-1を返す.
	return _data[y * width + x]

func getv_pos(pos: Vector2i) -> int:
	return getv(pos.x, pos.y)

# 配列の値を設定する.
func setv(x: int, y: int, v: int) -> void:
	if is_out_of_range(x, y):
		return # 範囲外は無視する.
	_data[y * width + x] = v

func setv_pos(pos: Vector2i, v: int) -> void:
	setv(pos.x, pos.y, v)

# すべての要素を関数で処理する.
func foreach(function: Callable) -> void:
	for y in range(height):
		for x in range(width):
			function.call(x, y, getv(x, y))

# 指定の値で埋める.
func fill(v:int) -> void:
	for i in range(width * height):
		_data[i] = v

# 指定の値に一致している座標をすべて取得する.
func find_all(v:int) -> Array[Vector2i]:
	var result:Array[Vector2i] = []
	foreach(func(x, y, value):
		if value == v:
			result.append(Vector2i(x, y))
	)
	return result

# 値を初期化する.
func clear() -> void:
	fill(defaultValue)

func dump() -> void:
	print("[array2d]")
	for j in range(height):
		var s = ""
		for i in range(width):
			s += "%d, "%getv(i, j)
		print(s)

# 開始から終端を穴掘り法で埋める.
# @note start, end, width, heightすべてが "奇数" である必要があります (外壁ありの場合)
func dig(start:Vector2i, end:Vector2i, wall:int) -> void:
	var x = start.x
	var y = start.y
	# 開始地点を掘る.
	setv(x, y, 0)
	# 掘れるかどうかを判定する方向
	var dir_list = [
		Vector2i(-1, 0),
		Vector2i(0, -1),
		Vector2i(1, 0),
		Vector2i(0, 1)
	]

	# シャッフル
	dir_list.shuffle()

	for dir in dir_list:
		# 移動方向.
		var dx = dir.x
		var dy = dir.y
		# 2マス先が壁かどうかを見る.
		var nx = x + dx * 2
		var ny = y + dy * 2
		if is_out_of_range(nx, ny):
			continue # 範囲外は無視する.
		
		if getv(nx, ny) != wall:
			continue # すでに掘られている場所は無視する.

		# 掘る.
		setv(x + dx, y + dy, defaultValue)
		# 再帰的に掘る.
		dig(Vector2i(nx, ny), end, wall)
