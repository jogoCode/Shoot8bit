extends Node2D

@onready var _area:Area2D = get_node("Area2D");
var _canSpawn:bool = true;


func _process(delta: float) -> void:
	if(_area.get_overlapping_areas().is_empty()): return;
	for area in _area.get_overlapping_areas():
		_area_entered(area);

func _area_entered(area:Area2D):
	var other:CharacterPlayer2D = area.get_parent();	
	if(other._isInteract and _canSpawn):
		var pickup:Pickup = load("res://Entities/Pickups/pickup.tscn").instantiate();
		pickup._weaponData = load("res://Ressources/Weapons/w_ak.tres");
		pickup.global_position = $spawnPoint.global_position;
		get_tree().current_scene.add_child(pickup);
		_canSpawn = false;
