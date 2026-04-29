extends Node

class_name DirUtil

# 方向.
enum eDir {
	NONE, # 無効な方向.
	
	# 4方向.
	LEFT,  # 左
	RIGHT, # 右
	UP,    # 上
	DOWN,  # 下

	# 8方向.
	LEFT_UP,    # 左上
	RIGHT_UP,   # 右上
	LEFT_DOWN,  # 左下
	RIGHT_DOWN, # 右下

}

# 方向をベクトルに変換する.
static func to_vec(dir: eDir) -> Vector2:
	match dir:
		eDir.LEFT:
			return Vector2(-1, 0)
		eDir.RIGHT:
			return Vector2(1, 0)
		eDir.UP:
			return Vector2(0, -1)
		eDir.DOWN:
			return Vector2(0, 1)
		eDir.LEFT_UP:
			return Vector2(-1, -1).normalized()
		eDir.RIGHT_UP:
			return Vector2(1, -1).normalized()
		eDir.LEFT_DOWN:
			return Vector2(-1, 1).normalized()
		eDir.RIGHT_DOWN:
			return Vector2(1, 1).normalized()
		_:
			return Vector2.ZERO

# ベクトルを方向に変換する.
static func to_dir(vec: Vector2) -> eDir:
	if vec.x < 0 and vec.y < 0:
		return eDir.LEFT_UP
	elif vec.x > 0 and vec.y < 0:
		return eDir.RIGHT_UP
	elif vec.x < 0 and vec.y > 0:
		return eDir.LEFT_DOWN
	elif vec.x > 0 and vec.y > 0:
		return eDir.RIGHT_DOWN
	elif vec.x < 0:
		return eDir.LEFT
	elif vec.x > 0:
		return eDir.RIGHT
	elif vec.y < 0:
		return eDir.UP
	elif vec.y > 0:
		return eDir.DOWN
	else:
		return eDir.NONE

# 方向を反転する.
static func reverse(dir: eDir) -> eDir:
	match dir:
		eDir.LEFT:
			return eDir.RIGHT
		eDir.RIGHT:
			return eDir.LEFT
		eDir.UP:
			return eDir.DOWN
		eDir.DOWN:
			return eDir.UP
		eDir.LEFT_UP:
			return eDir.RIGHT_DOWN
		eDir.RIGHT_UP:
			return eDir.LEFT_DOWN
		eDir.LEFT_DOWN:
			return eDir.RIGHT_UP
		eDir.RIGHT_DOWN:
			return eDir.LEFT_UP
		_:
			return eDir.NONE

# 指定の方向にラジアンを近づける.
static func approach_rad(current: float, target_dir: eDir, step: float) -> float:
	var target_rad := to_rad(target_dir)
	var delta := wrapf(target_rad - current, -PI, PI)
	if absf(delta) <= step:
		return target_rad
	else:
		return current + step * sign(delta)


# 方向を回転する.
static func rotate(dir: eDir, clockwise: bool = true) -> eDir:
	match dir:
		eDir.LEFT:
			return eDir.UP if clockwise else eDir.DOWN
		eDir.RIGHT:
			return eDir.DOWN if clockwise else eDir.UP
		eDir.UP:
			return eDir.RIGHT if clockwise else eDir.LEFT
		eDir.DOWN:
			return eDir.LEFT if clockwise else eDir.RIGHT
		eDir.LEFT_UP:
			return eDir.RIGHT_UP if clockwise else eDir.LEFT_DOWN
		eDir.RIGHT_UP:
			return eDir.RIGHT_DOWN if clockwise else eDir.LEFT_UP
		eDir.LEFT_DOWN:
			return eDir.LEFT_UP if clockwise else eDir.RIGHT_DOWN
		eDir.RIGHT_DOWN:
			return eDir.LEFT_DOWN if clockwise else eDir.RIGHT_UP
		_:
			return eDir.NONE

# 方向をラジアンに変換する
static func to_rad(dir: eDir) -> float:
	match dir:
		eDir.LEFT:
			return PI
		eDir.RIGHT:
			return 0
		eDir.UP:
			return -PI / 2
		eDir.DOWN:
			return PI / 2
		eDir.LEFT_UP:
			return -PI * 3 / 4
		eDir.RIGHT_UP:
			return -PI / 4
		eDir.LEFT_DOWN:
			return PI * 3 / 4
		eDir.RIGHT_DOWN:
			return PI / 4
		_:
			return 0.0

# 方向を角度に変換する.
static func to_deg(dir: eDir) -> float:
	match dir:
		eDir.LEFT:
			return 180
		eDir.RIGHT:
			return 0
		eDir.UP:
			return -90
		eDir.DOWN:
			return 90
		eDir.LEFT_UP:
			return -135
		eDir.RIGHT_UP:
			return -45
		eDir.LEFT_DOWN:
			return 135
		eDir.RIGHT_DOWN:
			return 45
		_:
			return 0.0

# 方向を文字列に変換する.
static func dir_to_string(dir: eDir) -> String:
	match dir:
		eDir.LEFT:
			return "LEFT"
		eDir.RIGHT:
			return "RIGHT"
		eDir.UP:
			return "UP"
		eDir.DOWN:
			return "DOWN"
		eDir.LEFT_UP:
			return "LEFT_UP"
		eDir.RIGHT_UP:
			return "RIGHT_UP"
		eDir.LEFT_DOWN:
			return "LEFT_DOWN"
		eDir.RIGHT_DOWN:
			return "RIGHT_DOWN"
		_:
			return "NONE"

