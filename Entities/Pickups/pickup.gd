extends Node2D
class_name Pickup

@export var _weaponData:RWeapon;
@onready var _sprite:Sprite2D = $Sprite2D;
@onready var _area2d:Area2D = $Area2D;

func _ready() -> void:
	_area2d.area_entered.connect(_area_entered);
	get_node("OscillatorScale")._add_velocity(40);
	set_visual_weapon();
	await get_tree().create_timer(0.7).timeout;
	_area2d.monitoring = true;
	_area2d.monitorable = true;


func set_visual_weapon():
	_sprite.texture = _weaponData._sprite;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(_area2d.get_overlapping_areas().is_empty()): 
		for area in _area2d.get_overlapping_areas():
			rpc_area_entered.rpc(area);

@rpc("call_local")
func rpc_area_entered(area:Area2D):
	var other = area.get_parent();
	if(other is CharacterPlayer2D and other.visible == true):
		if !other._isInteract : return;
		if other._status == Character2D.CharacterStatus.NOT_ACTIVE: return;
		var weaponSys:WeaponSystem = other.get_node("WeaponSystem");
		var pickup:Pickup = load("res://Entities/Pickups/pickup.tscn").instantiate();
		pickup._weaponData = other._weaponSystem._weaponData;
		pickup.global_position = global_position;
		if(!other._weaponSystem._weaponData._name.contains("gun")):
			get_tree().current_scene.add_child(pickup);
		await get_tree().create_timer(0.1).timeout;
		weaponSys.change_weapon(_weaponData);
		queue_free();
	

func _area_entered(area:Area2D):
	rpc_area_entered.rpc(area);
