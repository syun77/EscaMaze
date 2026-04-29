extends Area2D
# ==============================================
# エサ.
# ==============================================
class_name Food

func _process(_delta: float) -> void:
    # 描画リクエスト.
    queue_redraw()

func _draw() -> void:
    var radius := 10.0
    draw_circle(Vector2.ZERO, radius, Color(1.0, 0.5, 0.0))
