extends "res://Scripts/Base/EntityBase.gd"

@export
var SPEED : float

@export
var ACCELERATION : float

@export
var CONTACT_DAMAGE : float

@export
var CONTACT_PENETRATION : float

@export
var CONTACT_KNOCKBACK : float

@export
var tier1drops : Array[String]

@export
var tier2drops : Array[String]

@export
var tier1chance : float = 1

@export
var tier2chance : float

var dontDrop : bool = false

var dead : bool = false


func _parent_ready():
	var h = PlayerStats.get_heat_scale()
	SPEED = floor(SPEED * min(h, 1.5))
	ACCELERATION = floor(ACCELERATION * h)
	CONTACT_PENETRATION = floor(CONTACT_PENETRATION * h)
	CONTACT_DAMAGE = floor(CONTACT_DAMAGE * h)
	maxHP = floor(maxHP * h)
	$"Sprite2D/Healthbar".maxHP = maxHP
	hp = maxHP
	

func set_hp(value):
	if hp == null:
		hp = value
	elif typeof(value) != TYPE_NIL:
		hp = min(value, maxHP)
		$"Sprite2D/Healthbar".updateHP(hp)
	
	if hp <= 0:
		die()

func hurt(attack : Attack):
	if dead: return
	hp -= attack.damage
	velocity = (global_position - attack.pos).normalized() * attack.knockback
	GlobalAssets.SpawnDamageNumber(attack.damage, global_position)
	if attack.isCrit:
		$CritSound.pitch_scale = randf_range(0.7, 1.3)
		$CritSound.play()
	else:
		$HitSound.pitch_scale = randf_range(0.7, 1.3)
		$HitSound.play()
	

func contact_damage(body : Node, knockback_pos : Vector2):
	var attack = Attack.new()
	attack.damage = CONTACT_DAMAGE
	attack.penetration = CONTACT_PENETRATION
	attack.knockback = CONTACT_KNOCKBACK
	attack.pos = knockback_pos
	body.hurt(attack)


func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		contact_damage(body, sprite.global_position)

func die():
	dead = true
	disable_collision()
	$Sprite2D.hide()
	$DeathAnimation.show()
	$DeathAnimation.play()
	await $DeathAnimation.animation_finished
	drop()
	emit_signal("died", self)
	queue_free()

func drop():
	if dontDrop:
		return
	var weights : Array[float] = []
	var nodes : Array[Node] = []
	var node : Node
	var ind : int
	if randf() < tier1chance:
		for i in tier1drops:
			node = load(AugmentData.dropsPacked[i]).instantiate()
			weights.append(node.weight)
			nodes.append(node)
		ind = RandPlus.SampleWeighted(weights)
		var tier1drop : Node = nodes[ind]
		nodes.remove_at(ind)
		
		for i in nodes:
			i.queue_free()
		
		tier1drop.global_position = global_position

		get_tree().get_root().get_node("main/Disposables").call_deferred("add_child", tier1drop)
	
	if randf() < tier2chance:
		nodes.clear()
		weights = []
		for i in tier2drops:
			node = load(AugmentData.dropsPacked[i]).instantiate()
			weights.append(node.weight)
			nodes.append(node)
		ind = RandPlus.SampleWeighted(weights)
		var tier2drop : Node = nodes[ind]
		nodes.remove_at(ind)
		
		for i in nodes:
			i.queue_free()
		
		tier2drop.global_position = global_position + Vector2(16, 0)
		
		get_tree().get_root().get_node("main/Disposables").call_deferred("add_child", tier2drop)
