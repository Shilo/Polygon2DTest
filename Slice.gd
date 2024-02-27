@tool
extends Polygon2D

@export var radius = 150
@export_range(4, 16) var slices = 4:
	set(value):
		slices = value
		update_slice()
	get:
		return slices

func update_slice():
	var angle = deg_to_rad(360/slices)

	var x = radius * cos(angle)
	var y = radius * sin(angle)
	
	polygon[0].x = 0
	polygon[0].y = 0
	
	polygon[1].x = radius
	polygon[1].y = 0
	
	polygon[2].x = radius
	polygon[2].y = radius
	
	polygon[3].x = x
	polygon[3].y = y

	rotation = angle
