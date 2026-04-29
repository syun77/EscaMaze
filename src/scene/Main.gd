# ==============================================
# メインシーンのルートノード.
# ==============================================
extends Node2D

@onready var _foodLayer: CanvasLayer = $FoodLayer # エサのレイヤー.

func _ready():
	# プレイヤーを登録.
	Global.register_player($Player)
	# グローバルノードにレイヤーを登録.
	Global.register_layers(
		{"food": _foodLayer}
	)
	# デバッグ用にランダムでエサを配置する.
	Map.debug_spawn_foods(_foodLayer)
