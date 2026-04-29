extends Area2D
# ==============================================
# ホーミング弾.
# ==============================================
class_name Horming

# -------------------------------
# 当たり判定の半径
const HIT_RADIUS = 16.0

# 速度制限
const SPEED_LIMIT_RATIO = 0.1

# 接触してから消えるまでの時間
const DESTROY_WAIT_TIME = 1.0

const GRADIENT_BLACK = preload("res://assets/gradient/black_gradient.tres")
const GRADIENT_WHITE = preload("res://assets/gradient/white_gradient.tres")
# -------------------------------
@onready var line = $Line2D
@onready var hit = $Hit # Line2Dを直接動かすので当たり判定も一緒に動かします.

# -------------------------------
# 移動速度
var _speed:float = 500
# 現在の進行方向
var _angle:float = 0
# 旋回速度
var _rot_speed = 0.1
# 破棄フラグ.
var _destroy_requested = false
# 属性.
var _attr := Attribute.eAttr.WHITE

# ターゲット座標
# ・ターゲットが移動する場合はこの座標を更新する
# ・Objectを渡す場合は is_instance_valid() で存在チェックして
# 　座標を取得することになるはず……
var _aim_position := Vector2()

var _time_wait = DESTROY_WAIT_TIME # 接触して1秒で消える
# -------------------------------
# 属性を設定.
func set_attribute(attr: Attribute.eAttr) -> void:
	_attr = attr
	if attr == Attribute.eAttr.BLACK:
		line.set_gradient(GRADIENT_BLACK) # 黒は専用のグラデーションを使用する.
	else:
		line.set_gradient(GRADIENT_WHITE) # 白はデフォルトのグラデーションを使用する.

# ターゲット座標を更新.
func set_aim(pos:Vector2) -> void:
	_aim_position = pos

# 破棄リクエスト.
func request_destroy() -> void:
	_destroy_requested = true

func _ready() -> void:
	pass

# 移動開始処理
# @param speed 移動速度
# @param start_angle 開始角度(-180〜180)
# @param pos 開始座標
# @param end 終端座標
func start(speed:float, start_angle:float, pos:Vector2, end:Vector2) -> void:
	position = Vector2.ZERO # Line の先頭を原点にするため、オブジェクト全体の位置は(0,0)にします.
	for i in range(line.points.size()):
		line.points[i] = pos
	
	_aim_position = end
	_angle = start_angle
	_speed = speed
	
func _process(delta: float) -> void: 
	# ターゲット座標の取得.
	var aim = _get_aim_instance()
	if is_instance_valid(aim) and _destroy_requested == false:
		_aim_position = aim.position
	
	if _destroy_requested:
		# 破棄リクエストがある場合はアルファ値を下げていきます.
		line.modulate.a = _time_wait # アルファ値を徐々に下げる.
	
	var p:Vector2 = line.points[0]
	hit.position = p # Line2Dを直接動かすので当たり判定も一緒に動かします.

	# 回転方向を求める
	var dir = (_aim_position - p)
	var length = dir.length()
	if length < HIT_RADIUS or _destroy_requested:
		# 一定距離に近づいたら直接近づける
		# 0.1の重みで線形補間します
		line.points[0] = p.lerp(_aim_position, 0.1)
		_update_line2d()
		_time_wait -= delta
		
		if _time_wait < 0:
			# 一定時間で消します
			queue_free()
		return
	
	var rad = atan2(-dir.y, dir.x)
	var deg = rad_to_deg(rad)
	var d = _diff_angle(_angle, deg)
	
	# 旋回実行
	_angle += d * _rot_speed
	# 旋回速度を上げる
	_rot_speed = lerp(_rot_speed, 1.0, Common.get_speed_rate() * delta * 0.1)
	
	# Line2Dの先頭を移動する
	var next = p
	var spd = _speed * delta * Common.get_speed_rate()
	if spd > length * SPEED_LIMIT_RATIO:
		# 速度制限
		spd = length * SPEED_LIMIT_RATIO
	next.x += spd * cos(deg_to_rad(_angle))
	next.y += spd * -sin(deg_to_rad(_angle))
	line.points[0] = next
	
	# line2dを動かす
	_update_line2d()

# Line2Dの座標を更新する
func _update_line2d() -> void:
	for i in range(line.points.size()-1):
		var a = line.points[i]
		var b = line.points[i+1]
		# 0.5の重みで線形補間します
		line.points[i+1] = b.lerp(a, 0.5)

# 角度差を求める
func _diff_angle(now:float, next:float) -> float:
	# 差を求める
	var d = next - now
	# 0〜360に丸める
	d -= floor(d / 360.0) * 360.0
	# -180〜180にする.
	if d > 180:
		d -= 360
	return d

# ターゲットのインスタンスを取得する.
func _get_aim_instance() -> Enemy:
	return Common.get_nearest_enemy(self) # 一番近くにいる敵を取得する.
