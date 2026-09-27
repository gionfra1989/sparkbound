class_name TouchUI
extends Control

signal attack_pressed
signal jump_pressed
signal interact_pressed
signal back_pressed

var move_vector:=Vector2.ZERO
var guided_mode:=false
var show_attack:=false
var interact_label:="TALK"
var enabled_controls:=true
var joy_finger:=-1
var joy_center:=Vector2.ZERO
var joy_knob:=Vector2.ZERO
var joy_radius:=72.0
var button_rects:Dictionary={}

func _ready()->void:
    set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    mouse_filter=Control.MOUSE_FILTER_PASS
    get_viewport().size_changed.connect(_layout)
    _layout();queue_redraw()

func configure(age:int)->void:
    guided_mode=age<=5
    queue_redraw()

func _layout()->void:
    var s:=get_viewport_rect().size
    position=Vector2.ZERO
    size=s
    joy_radius=clamp(min(s.x,s.y)*.095,58.0,78.0)
    joy_center=Vector2(joy_radius+34,s.y-joy_radius-34)
    if joy_knob==Vector2.ZERO:joy_knob=joy_center
    button_rects={
        "jump":Rect2(Vector2(s.x-150,s.y-175),Vector2(98,98)),
        "attack":Rect2(Vector2(s.x-265,s.y-112),Vector2(92,92)),
        "interact":Rect2(Vector2(s.x-160,s.y-295),Vector2(108,70)),
        "back":Rect2(Vector2(22,22),Vector2(58,48))
    }
    queue_redraw()

func _gui_input(event:InputEvent)->void:
    if not enabled_controls:return
    if event is InputEventScreenTouch:
        if event.pressed:_down(event.index,event.position)
        else:_up(event.index)
        accept_event()
    elif event is InputEventScreenDrag:
        if event.index==joy_finger:_joy(event.position);accept_event()
    elif event is InputEventMouseButton and event.button_index==MOUSE_BUTTON_LEFT:
        if event.pressed:_down(-99,event.position)
        else:_up(-99)
    elif event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and joy_finger==-99:
        _joy(event.position)

func _down(id:int,p:Vector2)->void:
    if p.distance_to(joy_center)<joy_radius*1.55 and joy_finger==-1:
        joy_finger=id;_joy(p);return
    for k in button_rects:
        if button_rects[k].has_point(p):
            match k:
                "jump":jump_pressed.emit()
                "attack":
                    if show_attack:attack_pressed.emit()
                "interact":interact_pressed.emit()
                "back":back_pressed.emit()
            return

func _up(id:int)->void:
    if id==joy_finger:joy_finger=-1;move_vector=Vector2.ZERO;joy_knob=joy_center;queue_redraw()
func _joy(p:Vector2)->void:
    var d:=p-joy_center
    if d.length()>joy_radius:d=d.normalized()*joy_radius
    joy_knob=joy_center+d;move_vector=d/joy_radius;queue_redraw()

func _draw()->void:
    if not enabled_controls:return
    draw_circle(joy_center,joy_radius,Color(.15,.16,.22,.12));draw_circle(joy_center,joy_radius,Color(.18,.2,.28,.26),false,3)
    draw_circle(joy_knob,joy_radius*.44,Color(1,1,1,.78));draw_circle(joy_knob,joy_radius*.44,Color("#3f4764"),false,3)
    if guided_mode:
        if show_attack:_button("attack","HIT",Color("#ef7968"))
        else:_wide("interact",interact_label,Color("#f2c85c"))
        _wide("back","‹",Color("#d9d5ca"))
    else:
        _button("jump","JUMP",Color("#66bdd7"))
        if show_attack:_button("attack","HIT",Color("#ef7968"))
        _wide("interact",interact_label,Color("#f2c85c"))
        _wide("back","‹",Color("#d9d5ca"))

func _button(key:String,label:String,color:Color)->void:
    var r:Rect2=button_rects[key];var c:=r.get_center();var rad:=min(r.size.x,r.size.y)*.46
    draw_circle(c,rad,Color(color.r,color.g,color.b,.86));draw_circle(c,rad,Color("#3d4055"),false,3)
    draw_string(ThemeDB.fallback_font,c+Vector2(-rad*.8,6),label,HORIZONTAL_ALIGNMENT_CENTER,rad*1.6,17,Color("#25273a"))
func _wide(key:String,label:String,color:Color)->void:
    var r:Rect2=button_rects[key];var sb:=StyleBoxFlat.new();sb.bg_color=Color(color.r,color.g,color.b,.84);sb.corner_radius_top_left=18;sb.corner_radius_top_right=18;sb.corner_radius_bottom_left=18;sb.corner_radius_bottom_right=18;sb.border_width_left=2;sb.border_width_right=2;sb.border_width_top=2;sb.border_width_bottom=2;sb.border_color=Color("#44475d")
    draw_style_box(sb,r);draw_string(ThemeDB.fallback_font,r.position+Vector2(0,r.size.y*.62),label,HORIZONTAL_ALIGNMENT_CENTER,r.size.x,16,Color("#26283b"))