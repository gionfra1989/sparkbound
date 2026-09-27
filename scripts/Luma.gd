extends Node2D
var t:=0.0
func _process(delta:float)->void:
    t+=delta
    var p=get_tree().get_first_node_in_group("player")
    if is_instance_valid(p):global_position=global_position.lerp(p.global_position+Vector2(48,-60),1.0-exp(-delta*4.0))
    queue_redraw()
func _draw()->void:
    var b:=sin(t*3)*4
    draw_circle(Vector2(0,b),18,Color(1,.84,.25,.15));draw_circle(Vector2(0,b),8,Color("#ffd95a"));draw_arc(Vector2(0,b),13,t,t+PI*1.45,18,Color("#fff2ad"),2)