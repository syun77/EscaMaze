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
    var segments := 16
    var points := PackedVector2Array()
    for i in range(segments):
        var t := float(i) / float(segments)
        var a := t * TAU
        points.append(Vector2(cos(a), sin(a)) * radius)
    draw_colored_polygon(points, Color(1, 0, 0))
