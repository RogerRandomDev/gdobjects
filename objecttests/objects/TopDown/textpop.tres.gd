extends Control

#the damage text
var curText=[]
const tfont=preload("res://font.tres")


func _draw():
	var delta = get_process_delta_time()
	var c_pos=TDglobal.camera.global_position-Vector2(512,300)
	for t in curText:
		t[0]-=delta
		if t[0]<=0:curText.erase(t)
		else:draw_string(tfont,t[1]-c_pos,t[2],HORIZONTAL_ALIGNMENT_CENTER)
	
func _process(delta):
	update()
