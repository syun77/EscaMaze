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
static func get_color(attr: int) -> Color:
    match attr:
        eAttr.BLACK:
            return Color.BLACK
        eAttr.WHITE:
            return Color.WHITE
        _:
            return Color.GRAY # NONEの場合はグレーを返す.

# 属性に対応するアウトラインの色を返す.
static func get_outline_color(attr: int) -> Color:
    match attr:
        eAttr.BLACK:
            return Color.RED # 黒のアウトラインは赤.
        eAttr.WHITE:
            return Color.AQUAMARINE # 白のアウトラインは青.
        _:
            return Color.GRAY # NONEの場合はグレーを返す.
