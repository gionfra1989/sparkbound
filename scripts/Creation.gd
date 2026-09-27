class_name Creation
extends Node2D

var creation_kind := "object"
var data:Dictionary = {}
var draw_size := Vector2(150,120)
var pulse := 0.0

func setup(p_kind:String,p_data:Dictionary,p_size:Vector2=Vector2(150,120))->void:
    creation_kind=p_kind
    data=p_data.duplicate(true)
    draw_size=p_size
    queue_redraw()

func _process(delta:float)->void:
    pulse+=delta
    queue_redraw()

func _draw()->void:
    if data.is_empty():return
    if creation_kind in ["tree","dog"]:
        draw_ellipse(Vector2(0,draw_size.y*.36),Vector2(draw_size.x*.28,draw_size.y*.08),Color(0.08,0.1,0.12,.10))
    for st in data.get("strokes",[]):
        var pts:Array=st.get("points",[])
        if pts.size()<2:continue
        var pk:=PackedVector2Array()
        for p:Vector2 in pts:
            pk.append(Vector2((p.x-.5)*draw_size.x,(p.y-.5)*draw_size.y))
        var c:=Color.from_string(str(st.get("color","#30303a")),Color("#30303a"))
        var width:=clamp(float(st.get("width",8))*max(.32,draw_size.x/420.0),2.0,12.0)
        draw_polyline(pk,c,width,true)
    if creation_kind=="tree":
        draw_circle(Vector2(draw_size.x*.32,-draw_size.y*.28),4+sin(pulse*2)*.7,Color("#ffd95a"))

func draw_ellipse(center:Vector2,radii:Vector2,color:Color)->void:
    var pts:=PackedVector2Array()
    for i in range(28):
        var a:=TAU*i/28.0
        pts.append(center+Vector2(cos(a)*radii.x,sin(a)*radii.y))
    draw_colored_polygon(pts,color)