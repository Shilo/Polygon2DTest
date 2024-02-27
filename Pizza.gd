@tool
class_name Pizza extends Node2D

@export var slice_colors: PackedColorArray = [
	Color.RED,
	Color.GREEN,
	Color.BLUE,
	Color.YELLOW,
	Color.MAGENTA,
	Color.CYAN,
	Color.DARK_GRAY,
	Color.WHITE,
	Color.DARK_RED,
	Color.DARK_GREEN,
	Color.DARK_BLUE,
	Color.DARK_CYAN,
	Color.DARK_VIOLET
]

@export_range(2, 16) var slices = 4:
	set(value):
		slices = value
		update()
	get:
		return slices

var SLICE = load("res://Slice.tscn")

func _ready():
	update()

func update():
	for child in get_children():
		remove_child(child)
		child.queue_free()
	
	for i in range(slices):
		var slice = SLICE.instantiate()
		var index = str(i)
		slice.name = "Slice" + str(i)
		slice.get_node("Title").text = index
		slice.modulate = slice_colors[i % slice_colors.size()]
		
		update_slice(slice, i)
		
		add_child(slice)
		slice.owner = self
	
func update_slice(slice: Polygon2D, index: int):
	var radius = get_slice_radius(slice)
	var angle = TAU / slices
	var angle_offset = (TAU / 4 - angle) / 2
	
	slice.rotation = angle * index
	
	slice.polygon[0].x = 0
	slice.polygon[0].y = 0
	
	slice.polygon[1].x = radius * cos(angle_offset)
	slice.polygon[1].y = radius * sin(angle_offset)
	
	slice.polygon[2].x = radius
	slice.polygon[2].y = radius
	
	slice.polygon[3].x = radius * cos(angle + angle_offset)
	slice.polygon[3].y = radius * sin(angle + angle_offset)

func get_slice_radius(slice: Polygon2D):
	var size = slice.texture.get_size()
	return max(size.x, size.y)
