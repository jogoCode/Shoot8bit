extends Area2D
class_name Hitbox

var _owner;
@export var damage;

func _ready() -> void:
	area_entered.connect(_area_entered);
	


func _area_entered(area):
	if area.owner is Character2D:
		if area.name != "Hurtbox":
			return;
		print("TESDT",area.owner.name);
		for node in area.owner.get_children():
			if node.has_signal("take_damage"):
				node.take_damage.emit(5,_owner);
