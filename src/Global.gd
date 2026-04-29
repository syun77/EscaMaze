extends Node
# ==============================================
# グローバルノード.
# ==============================================
class_name Global

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
