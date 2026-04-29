extends Area2D
# ==============================================
# 敵.
# ==============================================
class_name Enemy

const BULLET_OBJ = preload("res://src/objects/Bullet.tscn") # 敵弾のシーン.

# --------------------------------------------
# メンバ変数.
# --------------------------------------------
var _attr := Attribute.eAttr.WHITE # 属性.
var _timer: float = 0.0 # 弾を撃つタイマー.
var _shoot_interval: float = 3.0 # 弾を撃つ間隔

# 遅延発射砲台.
class DelayedBatteryInfo:
    """ 遅延発射弾の情報 """
    var deg:float = 0 # 角度.
    var speed:float = 0 # 速さ.
    var delay:float = 0 # 遅延時間(秒).
    var ax:float = 0 # 加速度(X)
    var ay:float = 0 # 加速度(Y)
    func _init(_deg:float, _speed:float, _delay:float, _ax:float=0.0, _ay:float=0.0) -> void:
        """ コンストラクタ """
        deg = _deg
        speed = _speed
        delay = _delay
        ax = _ax
        ay = _ay
    func elapse(delta:float) -> bool:
        """ 時間経過 trueで発射可能. """
        delay -= delta
        if delay <= 0:
            return true # 発射できる.
        return false

# 弾のディレイ発射用配列.
var _batteries: Array[DelayedBatteryInfo] = []

## 弾を撃つ.
## @param deg 角度
## @param speed 速さ
## @param delay 発射遅延 (秒)
## @param ax 加速度(X)
## @param ay 加速度(Y)
func _bullet(deg:float, speed:float, delay:float=0, ax:float=0, ay:float=0):
    if delay > 0.0:
        # 遅延発射なのでリストに追加するだけ.
        _add_battery(deg, speed, delay, ax, ay)
        return null
    
    # 発射する.
    var b = BULLET_OBJ.instantiate()
    b.set_attribute(_attr) # 弾の属性は敵と同じにする.
    b.position = position
    b.set_velocity(deg, speed)
    b.set_accel(ax, ay)
    var bullets = Common.get_layer("bullet")
    bullets.add_child(b)
    return b

## 遅延発射リストに追加する.
func _add_battery(deg:float, speed:float, delay:float, ax:float, ay:float) -> void:
    var b = DelayedBatteryInfo.new(deg, speed, delay, ax, ay)
    _batteries.append(b)

## 更新時間を固定化するため "_physics_process" で更新
func _physics_process(delta: float) -> void:
    _timer += delta
    # 遅延発射更新.
    _update_batteies(delta)

## 遅延発射リストを更新する.
func _update_batteies(delta:float) -> void:
    var tmp:Array[DelayedBatteryInfo] = []
    for battery in _batteries:
        var b:DelayedBatteryInfo = battery
        if b.elapse(delta):
            # 発射する.
            _bullet(b.deg, b.speed, 0, b.ax, b.ay)
            continue
        
        # 発射できないのでリストに追加.
        tmp.append(b)
    
    # 発射できない弾は次回に持ち越し.
    _batteries = tmp

# 更新関数.
func _process(delta):
    _timer += delta
    if _timer >= _shoot_interval:
        _timer = 0.0
        _bullet(270, 100) # 270度(下方向)に速さ100で弾を撃つ.
        _attr = Attribute.invert(_attr) # 属性を反転させる.
    
    _update_batteies(delta) # 遅延発射の更新.
