extends Node
# ==============================================
# 共通ノード.
# ==============================================
class_name Common

const TIMER_SLOW = 1.0 # スローになる時間.
const SLOW_SPEED_RATE_DEFAULT = 1.0 # 等速.
const SLOW_SPEED_RATE = 0.5 # スロー時の速度割合.

# ----------------------------------------------
# static 変数.
# ----------------------------------------------
static var _speed_rate:float = 1.0 # ゲーム全体の速度倍率. 1.0が通常速度. 0.5なら半速, 2.0なら倍速になる.
static var _slow_timer:float = 0.0 # スローの残り時間. 秒数で指定.
static var _player:Player = null # プレイヤー.
static var _layers:Dictionary[String, CanvasLayer] = {} # レイヤーの辞書. レイヤー名をキーにしてCanvasLayerを格納.
static var _map:Map = null # タイルマップ.

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
static func register_player(player: Player) -> void:
	# プレイヤーを登録する関数.
	_player = player

# プレイヤーの取得.
static func get_player() -> Player:
	return _player

# プレイヤーの位置を取得.
static func get_player_pos() -> Vector2:
	if is_instance_valid(_player):
		return _player.position
	return Vector2.ZERO

# マップの登録.
static func register_map(map: Map) -> void:
	_map = map
	
# マップの取得.
static func get_map() -> Map:
	return _map

# 狙い撃ち角度の取得.
static func get_aim(note: Node2D) -> float:
	var player = get_player()
	if player == null:
		return 0.0
	var dir = player.position - note.position
	return rad_to_deg(atan2(-dir.y, dir.x)) # Y軸は下向きなので符号を反転させる.

# 画面外かどうか.
static func is_out_of_screen(node:Node2D, radius:float) -> bool:
	var viewport = node.get_viewport()
	var pos = node.position
	var size = viewport.get_visible_rect().size
	if pos.x < -radius or pos.x > size.x + radius or pos.y < -radius or pos.y > size.y + radius:
		return true
	return false

# 一番近くにいる敵を取得する.
static func get_nearest_enemy(node:Node2D) -> Enemy:
	var enemyLayer = get_layer("enemy")
	if enemyLayer == null:
		return null
	var nearest:Enemy = null
	var nearestDist:float = INF
	for enemy in enemyLayer.get_children():
		if not is_instance_valid(enemy):
			continue # 無効なインスタンス.
		var dist = node.position.distance_to(enemy.position)
		if dist < nearestDist:
			# 暫定で一番近い.
			nearestDist = dist
			nearest = enemy
	return nearest

# スロー再生開始.
static func start_slow_motion():
	_speed_rate = SLOW_SPEED_RATE
	_slow_timer = TIMER_SLOW # スローの残り時間. 秒数で指定.

static func update_slow_motion(delta: float):
	if _slow_timer > 0.0:
		_slow_timer -= delta
		if _slow_timer <= 0.0:
			_speed_rate = SLOW_SPEED_RATE_DEFAULT # 通常速度に戻す.

static func get_speed_rate() -> float:
	# 現在の速度倍率を取得する関数.
	return _speed_rate
