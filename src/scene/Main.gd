# ==============================================
# メインシーンのルートノード.
# ==============================================
extends Node2D

@onready var _foodLayer: CanvasLayer = $FoodLayer # エサのレイヤー.
@onready var _bulletLayer: CanvasLayer = $BulletLayer # 弾のレイヤー.
@onready var _uiLayer: CanvasLayer = $UILayer # UIのレイヤー.

@onready var _powerLabel: Label = $UILayer/Label # パワー表示用のラベル.

func _ready():
	# プレイヤーを登録.
	Common.register_player($Player)
	# 共通ノードにレイヤーを登録.
	Common.register_layers({
		"food": _foodLayer,
		"bullet": _bulletLayer,
		"ui": _uiLayer
	})
	# デバッグ用にランダムでエサを配置する.
	Map.debug_spawn_foods(_foodLayer)

func _process(delta: float) -> void:
	_update_ui(delta)

func _update_ui(delta: float) -> void:
	# UIの更新処理.
	var player = Common.get_player()
	var power = player.get_power()
	_powerLabel.text = "POWER: " + str(power)