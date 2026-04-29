# ==============================================
# メインシーンのルートノード.
# ==============================================
extends Node2D

@onready var _foodLayer: CanvasLayer = $FoodLayer # エサのレイヤー.
@onready var _bulletLayer: CanvasLayer = $BulletLayer # 弾のレイヤー.

func _ready():
	# プレイヤーを登録.
	Common.register_player($Player)
	# 共通ノードにレイヤーを登録.
	Common.register_layers({
        "food": _foodLayer,
        "bullet": _bulletLayer,
    })
	# デバッグ用にランダムでエサを配置する.
	Map.debug_spawn_foods(_foodLayer)
