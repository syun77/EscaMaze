# ==============================================
# メインシーンのルートノード.
# ==============================================
extends Node2D

# Layer.
@onready var _foodLayer: CanvasLayer = $FoodLayer # エサのレイヤー.
@onready var _hormingLayer: CanvasLayer = $HormingLayer # ホーミング弾のレイヤー.
@onready var _enemyLayer: CanvasLayer = $EnemyLayer # 敵のレイヤー.
@onready var _bulletLayer: CanvasLayer = $BulletLayer # 弾のレイヤー.
@onready var _uiLayer: CanvasLayer = $UILayer # UIのレイヤー.

# objects.
@onready var _player: Player = $Player # プレイヤー.
@onready var _camera: Camera2D = $Camera2D # カメラ.
@onready var _map: Map = $Map # マップ.

# UI
@onready var _powerLabel: Label = $UILayer/Label # パワー表示用のラベル.
@onready var _debugLavel: Label = $UILayer/Label2 # デバッグ用ラベル.

func _ready():
	# プレイヤーを登録.
	Common.register_player(_player)
	# 共通ノードにレイヤーを登録.
	Common.register_layers({
		"food": _foodLayer,
		"horming": _hormingLayer,
		"enemy": _enemyLayer,
		"bullet": _bulletLayer,
		"ui": _uiLayer
	})

	# マップにエサを配置.
	_map.put_food()

	# カメラ追従.
	_camera.position = _player.position

func _process(delta: float) -> void:
	 # スローの更新処理.
	Common.update_slow_motion(delta)

	# カメラ追従.
	_camera.position = _player.position

	# UIの更新処理.
	_update_ui(delta)

# UIの更新処理.
func _update_ui(_delta: float) -> void:
	var player = Common.get_player()
	var power = player.get_power()
	_powerLabel.text = "POWER: " + str(power)

	_debugLavel.text = "Bullet: " + str(_bulletLayer.get_child_count()) + "\n" + \
		"Enemy: " + str(_enemyLayer.get_child_count()) + "\n" + \
		"Food: " + str(_foodLayer.get_child_count()) + "\n" + \
		"Horming: " + str(_hormingLayer.get_child_count())
