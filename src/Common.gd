extends Node
# ==============================================
# 共通ノード.
# ==============================================
class_name Common

static var _speed_rate:float = 1.0 # ゲーム全体の速度倍率. 1.0が通常速度. 0.5なら半速, 2.0なら倍速になる.
static var _slow_timer:float = 0.0 # スローの残り時間. 秒数で指定.
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
			continue
		var dist = node.position.distance_to(enemy.position)
		if dist < nearestDist:
			nearestDist = dist
			nearest = enemy
	return nearest

static func start_slow_motion():
	_speed_rate = 0.5 # 半速にする.
	_slow_timer = 1.0 # スローの残り時間. 秒数で指定.

static func update_slow_motion(delta: float):
	if _slow_timer > 0.0:
		_slow_timer -= delta
		if _slow_timer <= 0.0:
			_speed_rate = 1.0 # 通常速度に戻す.

static func get_speed_rate() -> float:
	# 現在の速度倍率を取得する関数.
	return _speed_rate
