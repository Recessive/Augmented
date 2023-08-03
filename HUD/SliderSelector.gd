extends Label

@export var prefix : String
@export var values : Array[String]
@export var value : int = 0
var slider : HSlider

signal value_updated(stringValue : String)

func _ready():
	# first child must be a slider
	slider = get_children()[0]
	slider.value = value
	on_slider_change(value)
	slider.connect("value_changed", on_slider_change)

func on_slider_change(value):
	value = slider.value
	text = prefix + values[value].to_upper()
	print('value: ',value,'   text: ',text)
	value_updated.emit(values[value])
