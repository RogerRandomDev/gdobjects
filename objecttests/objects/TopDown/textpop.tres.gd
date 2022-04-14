extends Control

#the damage text
var curText=[]
const tfont=preload("res://font.tres")


func _draw():
	var delta = get_process_delta_time()
	var c_pos=TDglobal.camera.global_position-Vector2(512,300)
	var keys=curText.size()
	var l=0
	for t in keys:
		var te=curText[t-1-l]
		te[0]-=delta
		draw_string(tfont,te[1]-c_pos,te[2])
		if te[0]<=0:
			curText.remove_at(t-l);l+=1
		
	
func _process(_delta):
	update()
