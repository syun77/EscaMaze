extends Node2D

class_name Player

const SPEED := 100.0

var _dir: DirUtil.eDir = DirUtil.eDir.NONE
var _anim_timer := 0.0

func _process(delta: float) -> void:

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
    _dir = DirUtil.to_dir(dir)
    # アニメーションタイマーを更新.
    _anim_timer += delta

    position += dir * SPEED * delta

    queue_redraw()


func _draw() -> void:
    var radius := 20.0
    # アニメーションで口の開き具合を変化させる.
    var mouth_angle := PI * 0.01 + (PI * 0.5) * absf(sin(_anim_timer*8))
    var face_angle := DirUtil.to_rad(_dir)
    var start_angle := face_angle + mouth_angle / 2.0	
    var end_angle := face_angle + TAU - (mouth_angle / 2.0)
    var segments := 32

    var points := PackedVector2Array()
    points.append(position)
    for i in range(segments + 1):
        var t := float(i) / float(segments)
        var a := lerpf(start_angle, end_angle, t)
        points.append(position + Vector2(cos(a), sin(a)) * radius)

    draw_colored_polygon(points, Color(1, 1, 0))

