class_name SketchCompanion
extends CharacterBody2D
var owner_node:Node2D
var data:Dictionary={}
var t:=0.0
var sniff_target:=Vector2.ZERO
var finding:=false
func setup(owner:Node2D,d:Dictionary)->void:owner_node=owner;data=d.duplicate(true);queue_redraw()
func _ready()->void:collision_layer=0;collision_mask=1;add_to_group("companion");queue_redraw()
func _physics_process(delta:float)->void:
    t+=delta
    if not is_instance_valid(owner_node):return
    var desired:=sniff_target if finding else owner_node.global_position+Vector2(-58,42)
    var d:=desired-global_position
    if d.length()>17:velocity=velocity.move_toward(d.normalized()*190,650*delta)
    else:velocity=velocity.move_toward(Vector2.ZERO,700*delta)
    move_and_slide();queue_redraw()
func sniff(p:Vector2)->void:sniff_target=p;finding=true
func stop_sniff()->void:finding=false
func _draw()->void:
    _ellipse(Vector2(0,14),Vector2(17,5),Color(0.1,0.12,0.16,.11))
    _draw_creation(data,Vector2(0,sin(t*3)-8),Vector2(68,54));draw_circle(Vector2(0,8),4.5,Color("#ffd95a"))
func _draw_creation(d:Dictionary,center:Vector2,sz:Vector2)->void:
    for st in d.get("strokes",[]):
        var pts:Array=st.get("points",[]);var pk:=PackedVector2Array()
        if pts.size()<2:continue
        for p:Vector2 in pts:pk.append(center+Vector2((p.x-.5)*sz.x,(p.y-.5)*sz.y))
        draw_polyline(pk,Color.from_string(str(st.get("color","#333333")),Color("#333333")),clamp(float(st.get("width",8))*.26,2.0,7.0),true)
func _ellipse(c:Vector2,r:Vector2,col:Color)->void:
    var pts:=PackedVector2Array()
    for i in range(20):
        var a:=TAU*i/20.0
        pts.append(c+Vector2(cos(a)*r.x,sin(a)*r.y))
    draw_colored_polygon(pts,col)