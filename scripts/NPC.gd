class_name SparkNPC
extends CharacterBody2D
signal interacted(npc)

var npc_name := "Miro"
var role := "maker"
var accent := Color("#e7a34f")
var t := 0.0
var target_pos := Vector2.ZERO
var home := Vector2.ZERO
var speed := 54.0
var can_wander := true
var facing := Vector2.RIGHT
var react_timer := 0.0

func setup(n:String, r:String, c:Color) -> void:
    npc_name=n;role=r;accent=c;queue_redraw()

func _ready() -> void:
    collision_layer=1;collision_mask=1
    var cs:=CollisionShape2D.new();var sh:=CircleShape2D.new();sh.radius=18;cs.shape=sh;add_child(cs)
    home=position;target_pos=position;add_to_group("npcs");queue_redraw()

func _physics_process(delta:float) -> void:
    t+=delta;react_timer=max(0.0,react_timer-delta)
    if can_wander:
        if global_position.distance_to(target_pos)<10:
            var angle:=randf()*TAU;target_pos=home+Vector2(cos(angle),sin(angle))*randf_range(10,56)
        var desired:=target_pos-global_position
        if desired.length()>1:
            facing=desired.normalized()
            velocity=velocity.move_toward(facing*speed,240*delta)
        else:velocity=velocity.move_toward(Vector2.ZERO,220*delta)
        move_and_slide()
    queue_redraw()

func walk_to(p:Vector2) -> void:
    target_pos=p;can_wander=true;react_timer=1.2
func stay() -> void:
    can_wander=false;velocity=Vector2.ZERO
func interact() -> void:
    react_timer=.8;interacted.emit(self)
func react() -> void:
    react_timer=1.0;queue_redraw()

func _draw() -> void:
    var bounce:=sin(t*3.2)*1.5
    if react_timer>0:bounce-=sin(react_timer*13.0)*2.8
    var root:=Vector2(0,bounce)
    _ellipse(Vector2(0,20),Vector2(19,6),Color(.08,.10,.15,.10))
    var step:=sin(t*8.0)*2.5 if velocity.length()>10 else 0.0
    draw_line(root+Vector2(-7,14),root+Vector2(-9+step,32),Color("#34374c"),7,true)
    draw_line(root+Vector2(7,14),root+Vector2(9-step,32),Color("#34374c"),7,true)
    draw_colored_polygon(PackedVector2Array([root+Vector2(-16,-7),root+Vector2(16,-7),root+Vector2(19,20),root+Vector2(-19,20)]),accent)
    draw_line(root+Vector2(-13,3),root+Vector2(-25,11),accent.darkened(.2),6,true)
    draw_line(root+Vector2(13,3),root+Vector2(25,11),accent.darkened(.2),6,true)
    draw_circle(root+Vector2(0,-20),15,Color("#f0c8a3"))
    draw_circle(root+Vector2(-5,-20),2.4,Color("#27283a"));draw_circle(root+Vector2(5,-20),2.4,Color("#27283a"))
    if react_timer>0:draw_arc(root+Vector2(0,-14),6,0.15,PI-.15,10,Color("#6b4653"),2)
    if role=="maker":
        draw_arc(root+Vector2(0,-31),18,PI,TAU,18,accent.darkened(.28),7)
        draw_line(root+Vector2(-17,-31),root+Vector2(18,-31),accent.darkened(.28),5,true)
        draw_circle(root+Vector2(18,-1),7,Color("#f2d05e"),false,3)
    elif role=="child":
        draw_colored_polygon(PackedVector2Array([root+Vector2(-14,-27),root+Vector2(0,-44),root+Vector2(14,-27)]),accent.darkened(.18))
        draw_line(root+Vector2(0,-5),root+Vector2(-22,-2),Color("#f0d45b"),5,true)

func _ellipse(center:Vector2,radii:Vector2,color:Color)->void:
    var pts:=PackedVector2Array()
    for i in range(20):
        var a:=TAU*i/20.0;pts.append(center+Vector2(cos(a)*radii.x,sin(a)*radii.y))
    draw_colored_polygon(pts,color)