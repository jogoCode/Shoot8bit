extends Node

@onready var _weaponSystem:WeaponSystem = get_parent();
var _muzzleFx = load("res://Assets/Entities/FX/muzzle_fx.tscn");

func _ready() -> void:
	_connect_signals();
	
func _connect_signals():
	_weaponSystem.OnShooted.connect(_on_shoot);


func _on_shoot():
	var muzzleFx = _muzzleFx.instantiate();
	muzzleFx
	_weaponSystem._spawnOrigin.add_child(muzzleFx);
