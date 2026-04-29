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

	$Horming.start(100, 0, Vector2.ZERO, Vector2(400, 300)) # ホーミング弾のテスト発射.

func _process(delta: float) -> void:

	var mouse_position = get_viewport().get_mouse_position()
	if(is_instance_valid($Horming)):
		$Horming.set_aim(mouse_position) # ホーミング弾のテストでマウスの位置を狙う.	

	# UIの更新処理.
	_update_ui(delta)

func _update_ui(_delta: float) -> void:
	# UIの更新処理.
	var player = Common.get_player()
	var power = player.get_power()
	_powerLabel.text = "POWER: " + str(power)
