extends Node
# ==============================================
# 共通ノード.
# ==============================================
class_name Common

static var _player:Player = null # プレイヤー.
static var _layers:Dictionary[String, CanvasLayer] = {} # レイヤーの辞書. レイヤー名をキーにしてCanvasLayerを格納.

# レイヤーの登録.
static func register_layers(layers: Dictionary[String, CanvasLayer]):
	# レイヤーを登録する関数.
	_layers = layers

# レイヤーの取得.
static func get_layer(layerName: String) -> CanvasLayer:
	# レイヤーを取得する関数. 存在しない場合はnullを返す.
	if layerName in _layers:
		return _layers[layerName]
	else:
		return null

# プレイヤーの登録.
static func register_player(player: Player):
	# プレイヤーを登録する関数.
	_player = player

# プレイヤーの取得.
static func get_player() -> Player:
	return _player

# 狙い撃ち角度の取得.
static func get_aim(note: Node2D) -> float:
	var player = get_player()
	if player == null:
		return 0.0
	var dir = player.position - note.position
	return rad_to_deg(atan2(-dir.y, dir.x)) # Y軸は下向きなので符号を反転させる.
