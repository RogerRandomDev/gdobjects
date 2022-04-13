extends Control

#the damage text
var curText={}
const tfont=preload("res://font.tres")


func _draw():
	var delta = get_process_delta_time()
	var c_pos=TDglobal.camera.global_position-Vector2(512,300)
	for t in curText.keys():
		var te=curText[t]
		te[0]-=delta
		if te[0]<=0:curText.erase(t)
		else:draw_string(tfont,curText[t][1]-c_pos,t)
	
func _process(delta):
	update()
