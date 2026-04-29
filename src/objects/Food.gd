extends Area2D
# ==============================================
# エサ.
# ==============================================
class_name Food

@onready var _shape := $Hit.shape as CircleShape2D # 当たり判定用の円形コリジョンシェイプ.
@onready var _mat := material.duplicate() as CanvasItemMaterial # マテリアルは複製する.

var _attr := Attribute.eAttr.NONE # 属性.
var _radius: float = 10.0 # エサの半径.

func set_attribute(a: Attribute.eAttr) -> void:
	# 属性を設定する関数.
	_attr = a

func _ready() -> void:
	# コリジョンシェイプの半径を取得して保存する.
	_radius = _shape.radius

func _process(_delta: float) -> void:
	# 描画リクエスト.
	queue_redraw()

func _draw() -> void:
	if _attr == Attribute.eAttr.WHITE:
		_mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD # 加算合成にする.
		set_material(_mat) # マテリアルを設定.
	else:
		pass

	# アウトラインの描画.
	var outline_size_add = randf_range(1, 4) # アウトラインのサイズをランダムに変化させる.
	var alpha = 0.8 # 透明度.
	draw_circle(Vector2.ZERO, _radius + outline_size_add, Attribute.get_outline_color(_attr, alpha))
	draw_circle(Vector2.ZERO, _radius, Attribute.get_color(_attr, 0.5))
