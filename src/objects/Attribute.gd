extends Node
# ==============================================
# 属性.
# ==============================================
class_name Attribute

enum eAttr {
	NONE,
	BLACK,
	WHITE,
}

# 属性に対応する色を返す.
static func get_color(attr: eAttr, alpha: float) -> Color:
	match attr:
		eAttr.BLACK:
			return Color(0, 0, 0, alpha)
		eAttr.WHITE:
			return Color(1, 1, 1, alpha)
		_:
			return Color(0.5, 0.5, 0.5, alpha) # NONEの場合はグレーを返す.

# 属性に対応するアウトラインの色を返す.
static func get_outline_color(attr: eAttr, alpha: float) -> Color:
	match attr:
		eAttr.BLACK:
			return Color(1, 0, 0, alpha) # 黒のアウトラインは赤.
		eAttr.WHITE:
			return Color(0, 1, 1, alpha) # 白のアウトラインは青.
		_:
			return Color(0.5, 0.5, 0.5, alpha) # NONEの場合はグレーを返す.

# 属性の反転.
static func invert(attr: eAttr) -> eAttr:
	match attr:
		eAttr.BLACK:
			return eAttr.WHITE
		eAttr.WHITE:
			return eAttr.BLACK
		_:
			return eAttr.NONE # NONEは反転してもNONEのまま.

# ランダムな属性を返す.
static func get_random() -> eAttr:
	if randi() % 2 == 0:
		return eAttr.BLACK
	else:
		return eAttr.WHITE
