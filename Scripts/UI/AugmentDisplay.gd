extends Node2D

signal augment_selected
signal augment_cancelled

var selectable : bool = false


@export
var tweenTime : float
@export
var scaleUp : float

@onready
var baseScale : Vector2 = scale
@onready
var basePosition : Vector2 = global_position

@onready
var list : ItemList = $"Augment List/ItemList"

var partAugments : Array[Node]

var selectedPart : String
var selectedAugment : Node

var selected : Node

func _ready():
	for child in get_children():
		if child is Area2D:
			child.clicked.connect(part_clicked)

func expand():
	var tween = create_tween().set_parallel().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "scale", baseScale * scaleUp, tweenTime)
	tween.tween_property(self, "global_position", Vector2(0, -25), tweenTime)
	tween.tween_property($ColorRect, "color", Color(0, 0, 0, 172/255.0), tweenTime)
	tween.tween_property($Back, "modulate", Color(1, 1, 1, 1), tweenTime)
	await tween.finished
	selectable = true

func part_clicked(part : Node):
	selectable = false
	selectedPart = part.partName
	populate_list(selectedPart)
	var tween = create_tween().set_parallel().set_trans(Tween.TRANS_CUBIC)
	selected = part
	if part.pair:
		tween.tween_property(part.pair, "global_position", $"Selected Pos".global_position + part.pair.offset, tweenTime)
		tween.tween_property(part.pair, "scale", $"Selected Pos".scale, tweenTime)
	tween.tween_property(part, "global_position", $"Selected Pos".global_position + part.offset, tweenTime)
	tween.tween_property(part, "scale", $"Selected Pos".scale, tweenTime)
	
	for child in get_children():
		if child is Area2D and child != selected and child != selected.pair:
			tween.tween_property(child.get_child(1), "modulate", Color(1, 1, 1, 0), tweenTime)
	$Text/Label.text = "%s Augments" % selectedPart
	tween.tween_property($Text, "modulate", Color(1, 1, 1, 1), tweenTime)
	tween.tween_property($"Augment List", "modulate", Color(1, 1, 1, 1), tweenTime)
	tween.tween_property($DescriptionRect, "modulate", Color(1, 1, 1, 1), tweenTime)

func reset_ui(tween : Tween):
	if selected.pair:
		tween.tween_property(selected.pair, "position", selected.pair.startingPos, tweenTime)
		tween.tween_property(selected.pair, "scale", selected.pair.startingScale, tweenTime)
	tween.tween_property(selected, "position", selected.startingPos, tweenTime)
	tween.tween_property(selected, "scale", selected.startingScale, tweenTime)
	for child in get_children():
		if child is Area2D and child != selected and child != selected.pair:
			tween.tween_property(child.get_child(1), "modulate", Color(1, 1, 1, 1), tweenTime)
	tween.tween_property($Text, "modulate", Color(1, 1, 1, 0), tweenTime)
	tween.tween_property($"Augment List", "modulate", Color(1, 1, 1, 0), tweenTime)
	tween.tween_property($DescriptionRect, "modulate", Color(1, 1, 1, 0), tweenTime)
	$DescriptionRect/Title/Label.text = ""
	$DescriptionRect/Description/Label.text = ""
	$Accept.visible = false

func minimize(tween : Tween):
	tween.tween_property(self, "scale", baseScale, tweenTime)
	tween.tween_property(self, "position", basePosition, tweenTime)
	tween.tween_property($ColorRect, "color", Color(0, 0, 0, 0), tweenTime)
	tween.tween_property($Back, "modulate", Color(1, 1, 1, 0), tweenTime)

func _on_back_button_button_down():
	var tween = create_tween().set_parallel().set_trans(Tween.TRANS_CUBIC)
	if selected:
		reset_ui(tween)
		await tween.finished
		selected = null
		selectable = true
		list.clear()
	else:
		minimize(tween)
		selectable = false
		emit_signal("augment_cancelled")


func populate_list(partName : String):
	if partName == "Head":
		partAugments = AugmentData.headAugments
	if partName == "Body":
		partAugments = AugmentData.bodyAugments
	if partName == "Arms":
		partAugments = AugmentData.armAugments
	if partName == "Legs":
		partAugments = AugmentData.legAugments
	for aug in partAugments:
		list.add_item(aug.augmentName)


func _on_item_list_item_selected(index):
	$Accept.visible = true
	selectedAugment = partAugments[index]
	$DescriptionRect/Title/Label.text = selectedAugment.augmentName
	$DescriptionRect/Description/Label.text = selectedAugment.augmentDesc



func _on_accept_button_button_down():
	if $Accept.visible:
		emit_signal("augment_selected")
		PlayerStats.add_augment(selectedAugment, selectedPart)
		var tween = create_tween().set_parallel().set_trans(Tween.TRANS_CUBIC)
		$Accept.visible = false
		reset_ui(tween)
		minimize(tween)
		await tween.finished
		selectable = false
		
