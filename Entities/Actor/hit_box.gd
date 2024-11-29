extends Area2D
class_name Hitbox

var _owner;
@export var _damage:int;

func _ready() -> void:
	area_entered.connect(_area_entered);
	


func _area_entered(area):
	if area.owner is Character2D:
		if area.name != "Hurtbox":
			return;
		print("HIT",area.owner._pseudo);
		var bloodInst = preload("res://Assets/Sprites/FX/blood_particle.tscn").instantiate();
		bloodInst.global_position = area.get_parent().global_position;
		get_tree().current_scene.add_child(bloodInst)
		for node in area.owner.get_children():
			if node.has_signal("take_damage"):
				node.take_damage.emit(_damage,_owner);
