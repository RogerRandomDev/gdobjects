extends ObjectBase2D
class_name LivingObject2D
signal killed
@export var maxHealth:int=10
var Health=10

func _ready():Health=maxHealth


func hit(damage):
	Health=max(Health-damage,0)
	if Health<=0:
		emit_signal("killed")
		queue_free()
