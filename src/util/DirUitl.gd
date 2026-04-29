extends Node

class_name DirUtil

# 方向.
enum eDir {
    NONE, # 無効な方向.

	LEFT,  # 左
	RIGHT, # 右
	UP,    # 上
	DOWN,  # 下
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
        _:
            return Vector2.ZERO

# ベクトルを方向に変換する.
static func to_dir(vec: Vector2) -> eDir:
    if vec.x < 0:
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
        _:
            return eDir.NONE


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
        _:
            return "NONE"

