class_name Blankling
extends CharacterBody2D
signal defeated(enemy)
var hp:=2
var speed:=70.0
var target:Node2D
var knock:=Vector2.ZERO
var stagger:=0.0
var age:=8
var t:=0.0
func setup(p_target:Node2D,p_age:int)->void:
    target=p_target;age=p_age
    if age<=5:hp=1;speed=38
    elif age<=8:hp=2;speed=58
    elif age<=10:hp=3;speed=72
    else:hp=3;speed=88
func _ready()->void:
    add_to_group("enemies");collision_layer=1;collision_mask=1
    var cs:=CollisionShape2D.new();var sh:=CircleShape2D.new();sh.radius=22;cs.shape=sh;add_child(cs);queue_redraw()
func _physics_process(delta:float)->void:
    t+=delta;stagger=max(0.0,stagger-delta)
    if not is_instance_valid(target):return
    var d:=target.global_position-global_position
    if stagger<=0 and d.length()<350:velocity=velocity.move_toward(d.normalized()*speed,380*delta)
    else:velocity=velocity.move_toward(Vector2.ZERO,520*delta)
    if knock.length()>2:velocity+=knock;knock=knock.move_toward(Vector2.ZERO,850*delta)
    move_and_slide()
    if d.length()<42 and target.has_method("take_damage"):target.take_damage(1,-d.normalized()*150)
    queue_redraw()
func take_hit(amount:int,k:Vector2)->void:
    hp-=amount;stagger=.35;knock=k
    if hp<=0:defeated.emit(self);queue_free()
    else:queue_redraw()
func _draw()->void:
    var root:=Vector2(0,sin(t*5)*2)
    var c:=Color("#55515f") if stagger<=0 else Color("#b8a6da")
    var body:=PackedVector2Array([root+Vector2(-24,15),root+Vector2(-28,-8),root+Vector2(-14,-29),root+Vector2(0,-21),root+Vector2(13,-31),root+Vector2(29,-9),root+Vector2(22,19),root+Vector2(4,29),root+Vector2(-13,24)])
    draw_colored_polygon(body,c);var out:=PackedVector2Array(body);out.append(body[0]);draw_polyline(out,Color("#302d38"),3,true)
    draw_colored_polygon(PackedVector2Array([root+Vector2(-15,-25),root+Vector2(-29,-39),root+Vector2(-7,-30)]),Color("#36323e"))
    draw_colored_polygon(PackedVector2Array([root+Vector2(13,-28),root+Vector2(31,-40),root+Vector2(20,-20)]),Color("#36323e"))
    draw_circle(root+Vector2(-8,-8),4,Color("#fff0a8"));draw_circle(root+Vector2(9,-7),4,Color("#fff0a8"))
    draw_line(root+Vector2(-20,16),root+Vector2(-34,28),Color("#36323e"),6,true);draw_line(root+Vector2(20,16),root+Vector2(34,28),Color("#36323e"),6,true)