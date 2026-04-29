extends Node2D
# ==============================================
# マップ.
# ==============================================
class_name Map

# 定数.
const AREA_WIDTH := 200 # 1つのエリアの幅. セル数で指定.
const AREA_HEIGHT := 150 # 1つのエリアの高さ. セル数で指定.
const CELL_SIZE := 32.0 # 1つのセルのサイズ.
const CELL_VECTOR := Vector2(CELL_SIZE, CELL_SIZE) # 1つのセルのサイズベクトル.

# static関数.
static func cell_to_pos(cell: Vector2i, center:bool=true) -> Vector2:
    if center:
        # セルの中心位置を返す.
        return cell * CELL_SIZE + (CELL_VECTOR * 0.5)
    else:
        # セルの左上位置を返す.
        return cell * CELL_SIZE

