extends Node
class_name TDPowerUpBase2D

var atkRange=256
var atkSpeed=0.125
var atkDuration=1
var atkPower=50
var curTime=0.
var knockbackForce=256.
var p=null
func _ready():
	randomize()
	p=get_parent()

func _physics_process(delta):curTime+=delta
