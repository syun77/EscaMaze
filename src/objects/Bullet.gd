extends Area2D
# ==============================================
# 敵弾.
# ==============================================
class_name Bullet

@onready var shape := $Hit.shape as CircleShape2D # 当たり判定用の円形コリジョンシェイプ.
@onready var mat := material.duplicate() as CanvasItemMaterial # マテリアルは複製する.

var attr := Attribute.eAttr.NONE # 弾の属性.
var velocity: Vector2 = Vector2.ZERO # 弾の速度.
var acceleration: Vector2 = Vector2.ZERO # 弾の加速度.
var radius: float = 8.0 # 弾の半径.
var angle: float = 0.0 # 弾の角度(描画用).

func set_attribute(a: Attribute.eAttr) -> void:
	# 弾の属性を設定する関数.
	attr = a

func set_velocity(deg: float, speed: float) -> void:
	# 角度と速さから速度ベクトルを計算して設定する関数.
	var rad = deg_to_rad(deg) # 角度をラジアンに変換.
	# スクリーン座標系はY軸が下向きなので、sinの符号を反転させる.
	velocity = Vector2(cos(rad), -sin(rad)) * speed

func set_accel(ax: float, ay: float) -> void:
	# 加速度を設定する関数.
	acceleration = Vector2(ax, ay)

func _ready():
	radius = shape.radius

func _process(delta):
	# 加速度を適用する (velocityでdeltaを掛けるので直接加算する).
	velocity += acceleration
	# 弾を移動させる.
	position += velocity * delta * Common.get_speed_rate() # ゲーム全体の速度倍率を掛ける.
	# 画面外に出たら削除する.
	if position.x < -100 or position.x > 1000 or position.y < -100 or position.y > 800:
		queue_free()
	
	angle = velocity.angle() # 速度の角度を取得して描画用に保存.
	queue_redraw()

func _draw():
	# 弾を描画する.
	match attr:
		Attribute.eAttr.WHITE:
			mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD # 加算合成にする.
			set_material(mat) # マテリアルを設定.
		_:
			pass
	var outline_size_add = randf_range(4, 8) # アウトラインのサイズをランダムに変化させる.
	
	# 向きに対する長方形で弾を表現する.
	var points := PackedVector2Array()
	# 前方斜め45度の点.
	var dir = Vector2(cos(angle), sin(angle))
	var perp = Vector2(-dir.y, dir.x) # 速度ベクトルに垂直なベクトル.
	var front = dir * radius * 0.5 # 前方の点は半径の0.5倍の位置にする.
	var back = -dir * radius * 1.5 # 後方の点は半径の1.5倍の位置にする.
	var left = perp * radius * 0.5 # 左右の点は半径の0.5倍の位置にする.
	var right = -perp * radius * 0.5
	points.append(front + left) # 前左
	points.append(front + right) # 前右
	points.append(back + right) # 後右
	points.append(back + left) # 後左
	# それぞれの座標を outline_size_add だけ外側に拡大してアウトラインを描画する.
	var outline_points := PackedVector2Array()
	for p in points:
		var direction = (p - Vector2.ZERO).normalized() # 中心からの方向を計算.
		outline_points.append(p + direction * outline_size_add) # 拡大した点をアウトライン用の配列に追加.
	
	var alpha = 0.8 # 透明度.
	draw_colored_polygon(outline_points, Attribute.get_outline_color(attr, alpha))
	draw_colored_polygon(points, Attribute.get_color(attr, alpha))
	


	#draw_circle(Vector2.ZERO, radius + outline_size_add, Attribute.get_outline_color(attr))
	#draw_circle(Vector2.ZERO, radius, Attribute.get_color(attr))
