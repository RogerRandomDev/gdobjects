extends Node


#the text popper
var textPop=null
#this is for the stats and whatnot you store.
#1 is equal to 100% of the default value
var luck=1.
var strength=1.
var defence=1.
var speed=1.
var atkdelay=1.
var atkduration=1.


#object collision array
var objects:Array=[]
#object pickup array
var pickups:Array=[]
#the player object for things to move to
var player=null
#the camera
var camera=null



#add and remove objects from collision
func add_object(obj):objects.append(obj)
func remove_object(obj):objects.erase(obj)
#add and remove pickup from pickups
func add_pickup(obj):pickups.append(obj)
func remove_pickup(obj):pickups.erase(obj)
#sets player
func setPlayer(obj):player=obj

func collide_objects(obj,isplayer=false):
	var global_position =obj.global_position
	for object in objects:
		if object==obj:continue
		var dist=(object.global_position-global_position).length_squared()
		if(dist<=16384&&object.has_method("pickup")&&isplayer):object.pickup(obj);continue
		if dist<=9216:
			if(object.has_method("attack")):object.attack(obj)


func get_overlapping_objects_box(obj,areaEnd,areaStart=Vector2.ZERO):
	var areaPoint=obj.global_position+areaStart
	#the returned objects
	var returned=[]
	#makes sure area end is the larger number
	if areaEnd.x<0:
		areaEnd.x=abs(areaEnd.x)
		areaPoint.x-=areaEnd.x
	if areaEnd.y<0:
		areaEnd.y=abs(areaEnd.y)
		areaPoint.y-=areaEnd.y
	#moves areaEnd to the area point
	areaEnd+=areaPoint
	for object in objects:
		if !object.is_inside_tree():continue
		var objpos=object.global_position-object.size/2
		#checks if it is inside the box area and not a pickup
		if (objpos.x+object.size.x<areaPoint.x||objpos.x>areaEnd.x||objpos.y+object.size.y<areaPoint.y||objpos.y>areaEnd.y)||obj==object:continue
		returned.append(object)
	return returned
func get_overlapping_objects_round(obj,area):
	var returned=[]
	var pos=obj.global_position
	area*=area
	for object in objects:
		if !object.is_inside_tree():continue
		if (object.global_position-pos).length_squared()<area:returned.append(object)
	return returned



func pickup_overlapping_items(obj,area):
	var pos=obj.global_position
	area*=area
	for object in pickups:
		if !object.is_inside_tree():continue
		if((object.global_position-pos).length_squared()<area):object.pickup(obj)


func popDamage(input,global_position):
	textPop.curText.append([1.5,global_position,input])



var semaphore=Semaphore.new()
var thread=Thread.new()
var time=0

#builds thread
func _ready():
	thread.start(loop_threaded)
var root=null
func loop_threaded():
	while true:
		semaphore.wait()
		for obj in objects:obj.physics_process(time)
		for obj in pickups:obj.physics_process(time)
		root.physics_process(time)

func _physics_process(delta):
	time=delta
	semaphore.post()
	
