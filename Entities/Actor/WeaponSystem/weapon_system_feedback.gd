extends Node

@onready var _weaponSystem:WeaponSystem = get_parent();
var _muzzleFx = load("res://Entities/FX/muzzle_fx.tscn");

func _ready() -> void:
	_connect_signals();
	
func _connect_signals():
	_weaponSystem.OnShooted.connect(_on_shoot);

func _on_shoot():
	_on_shoot_rpc.rpc();

@rpc("call_local")
func _on_shoot_rpc():
	var muzzleFx = _muzzleFx.instantiate();
	Sound2dManager.play(_weaponSystem._weaponData._shootSound,owner.global_position);
	_weaponSystem._spawnOrigin.add_child(muzzleFx);
