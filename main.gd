extends Node2D

@onready var pizza: Pizza = $Pizza
@onready var button = %Button
@onready var win = %Win
@onready var auto = %Auto
@onready var picker: ColorRect = %Picker
@onready var slices = %Slices

@export var rotations_per_sec: float = 0.5
@export var win_duration: float = 0.5
@export var picker_offset_degrees: float = -90
@export var slice_offset_degrees: float = -45
@export var reverse_slice_indexing: bool = true

func _on_button_pressed():
	win.text = ""
	button.disabled = true
	
	pizza.rotation = fmod(pizza.rotation, TAU)
	var tween: Tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SPRING)
	
	var min_distance = TAU
	var distance_range = TAU * 2
	var distance = distance_range * randf() + min_distance
	var duration = distance / TAU * rotations_per_sec
	tween.tween_property(pizza, "rotation", pizza.rotation + distance, duration)
	
	await tween.finished

	var win_slice: int = get_slice_index(pizza.rotation, pizza.slices)
	printt("win:", win_slice, "degrees:", rad_to_deg(fmod(pizza.rotation, TAU)))
	win.text = str(win_slice)
	
	await animate_slice(win_slice)
	
	button.disabled = false
	
func get_slice_index(angle: float, slices: int) -> int:
	angle = fmod(angle, TAU)
	if reverse_slice_indexing:
		angle = TAU - angle
	
	var slice_angle: float = TAU / slices
	var angle_offset: float = slice_angle/2 + deg_to_rad(slice_offset_degrees) + deg_to_rad(picker_offset_degrees)

	var index: int = floori((angle + angle_offset) / slice_angle)
	if index < 0: index += slices
	elif index >= slices: index -= slices
	
	return index

func animate_slice(index: int):
	var slice := pizza.get_child(index)

	var loops: int = 2
	var component_duration: float = win_duration / loops / loops
	
	var color = slice.modulate
	var to_color = Color.WHITE if color != Color.WHITE else Color.BLACK
	
	var tween: Tween = create_tween()
	tween.set_loops(loops)
	tween.tween_property(slice, "modulate", to_color, component_duration)
	tween.tween_property(slice, "modulate", color, component_duration)
	
	return tween.finished

func _on_auto_pressed():
	set_process(auto.button_pressed)

func _ready():
	set_process(false)
	
	pizza.slices = slices.value
	setup_picker(pizza.slices)

func setup_picker(slices: int):
	picker.pivot_offset = picker.size/2
	picker.global_position = pizza.global_position - picker.pivot_offset
	
	var target_angle = deg_to_rad(picker_offset_degrees)
	picker.rotation = target_angle + deg_to_rad(90)
	
	var slice_radius = pizza.get_slice_radius(pizza.get_child(0))
	var picker_position = Vector2(slice_radius * cos(target_angle), slice_radius * sin(target_angle))
	picker.global_position = pizza.global_position - picker.pivot_offset + picker_position
	
func _process(delta):
	if button.disabled: return
	
	button.emit_signal("pressed")


func _on_slices_value_changed(value):
	pizza.slices = value
