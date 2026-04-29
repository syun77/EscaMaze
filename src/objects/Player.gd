extends CharacterBody2D
# ==============================================
# プレイヤーオブジェクト.
# ==============================================
class_name Player

# 定数.
const BASE_SPEED := 100.0 # 移動速度.
const MAX_POWER := 10 # 最大パワー.

const HORMING_OBJ = preload("res://src/objects/Horming.tscn") # ホーミング弾のシーン.

@onready var _area2d:Area2D = $OverlapArea # 当たり判定用のエリア2D.

# メンバ変数.
var _anim_timer := 6.0 # アニメーションタイマー. 口の開き具合を変化させるために使用.
var _rotate:float = 0.0 # 回転角度.
var _power:int = 100 # エサを食べると増える.
var _speed := BASE_SPEED # 現在の移動速度.

func add_power(amount: int) -> void:
	# パワーを増やす関数.
	_power = min(_power + amount, MAX_POWER)
	print("Power: " + str(_power))
func get_power() -> int:
	# パワーを取得する関数.
	return _power

func get_forward(distance:float) -> Vector2:
	# プレイヤーの向いている方向のベクトルを取得する関数.
	var rad = _rotate
	return position + Vector2(cos(rad), -sin(rad)) * distance

# 更新.
func _process(delta: float) -> void:
	# ショットの発射.
	if Input.is_action_just_pressed("ui_accept"):
		_shoot()

	# 移動処理.
	_move(delta)

# ショットの発射.
func _shoot() -> void:
	if _power <= 0:
		# パワーが足りない.
		return
	
	# パワーを消費してショットを発射する.
	_power -= 1
	var h = HORMING_OBJ.instantiate()
	var forward = get_forward(1280) # プレイヤーの向いている方向のベクトルを取得.
	var rot = rad_to_deg(_rotate) + 180 + randf_range(-30, 30) # プレイヤーの向きの反対方向にランダムな角度を加える.
	rot = wrapf(rot, -180, 180) # 角度を-180〜180の範囲に収める.
	print("forward:" + str(forward) + " rot:" + str(rot))
	Common.get_layer("horming").add_child(h) # ホーミング弾をホーミングレイヤーに追加.
	h.start(1000, rot, position, forward) # ホーミング弾のテスト発射.

# 移動.
func _move(delta: float) -> void:
	# 移動処理.
	var dir = Vector2.ZERO
	if Input.is_action_pressed("ui_left"):
		dir.x = -1
	elif Input.is_action_pressed("ui_right"):
		dir.x = 1
	if Input.is_action_pressed("ui_up"):
		dir.y = -1
	elif Input.is_action_pressed("ui_down"):
		dir.y = 1

	if dir == Vector2.ZERO:
		# 移動しない.
		return
	
	dir = dir.normalized()
	_rotate = DirUtil.approach_rad(_rotate, DirUtil.to_dir(dir), delta * 10)
	# 移動していればアニメーションタイマーを更新.
	_anim_timer += delta

	velocity = dir * _speed * Common.get_speed_rate() # ゲーム全体の速度倍率を掛ける.
	move_and_slide()

	# 描画リクエスト.
	queue_redraw()

# 描画.
func _draw() -> void:
	var radius := 16.0
	# アニメーションで口の開き具合を変化させる.
	var mouth_angle := PI * 0.01 + (PI * 0.5) * absf(sin(_anim_timer*8))
	var face_angle := _rotate # 開始オフセット.
	var start_angle := face_angle + mouth_angle / 2.0 # 開始.
	var end_angle := face_angle + TAU - (mouth_angle / 2.0) # 終端.
	var segments := 32 # 分割数.

	# 円弧を描画.
	var points := PackedVector2Array()
	points.append(Vector2.ZERO) # 中心点.
	for i in range(segments + 1):
		var t := float(i) / float(segments)
		var a := lerpf(start_angle, end_angle, t)
		points.append(Vector2(cos(a), -sin(a)) * radius)

	draw_colored_polygon(points, Color(1, 1, 0))

# 衝突判定.
func _on_overlap_area_shape_entered(_area_rid: RID, area: Area2D, _area_shape_index: int, local_shape_index: int) -> void:
	# エリアに入ったときの処理.
	var local_owner_id := _area2d.shape_find_owner(local_shape_index)
	var local_shape_node := _area2d.shape_owner_get_owner(local_owner_id)
	var shape_name: String = local_shape_node.name
	print("Hit: " + shape_name)
	if area is Food:
		if shape_name == "HitItem":
			# エサに当たったときの処理.
			add_power(1) # パワーを増やす.
			area.queue_free() # エサを消す.
			
			Common.start_slow_motion() # スローを開始する.
