extends Node
class_name WeaponSystem;

@onready var _owner:Character2D = get_parent();
@export var _weaponData:RWeapon;
@export var _bullet:PackedScene;
@export var _weaponVisual:Node2D;
@export var _spawnOrigin:Node2D;
@export var _shakeWhenShoot:bool = false;

var _ammo:int;
var _maxAmmo:int;
var _bulletCadence:float;
var _shootTimer:Timer;
var _reloadTimer:Timer;
var _reloadTime:float;
var _canShoot = true;

#var _reloadBarScene = preload("res://Assets/Content/hud/ReloadBar_3d.tscn");
var _reloadBar;

signal ammo_changed();
signal OnShooted();



func _ready() -> void:
	#to initialized hud
	ammo_changed.emit();
	if( !_weaponData):
		printerr("No weapon data !")
	if !_weaponVisual:
		printerr("No weapon visual !");
	if !_spawnOrigin:
		printerr("No spawn origin !");
	if !_bullet:
		printerr("No bullet packed scene !");
	initialize();
	

func initialize():
	# for shoot cadence
	_shootTimer = Timer.new();
	_shootTimer.wait_time = _bulletCadence;
	_shootTimer.one_shot = true;
	add_child(_shootTimer);
	_shootTimer.timeout.connect(_shootTimer_timeout);
	
	# for reload timer
	_reloadTimer = Timer.new();
	_reloadTimer.wait_time = _reloadTime;
	add_child(_reloadTimer);
	_reloadTimer.timeout.connect(reload);
	#_reloadBar = _reloadBarScene.instantiate();
	#_owner.get_node("Visual").add_child(_reloadBar);
	if(_reloadBar != null):
		_reloadBar.hide();
	if _weaponData:
		set_weapon_stats();
	

func set_weapon_stats():
	_maxAmmo = _weaponData._maxAmmo;
	_ammo = _maxAmmo;
	_bulletCadence = _weaponData._cadence;
	_reloadTime = _weaponData._reloadTime;
	_shootTimer.wait_time = _bulletCadence;
	_reloadTimer.wait_time = _reloadTime;
	_bullet = _weaponData._projectile;
	if !_weaponVisual:
			return
	for node in _weaponVisual.get_children():
		if node == null:
			return
		node.queue_free();
	_weaponVisual.texture = _weaponData._sprite;
	_spawnOrigin.position = _weaponData._muzzleOffset;


func _process(delta: float) -> void:
	if _owner._status == Character2D.CharacterStatus.NOT_ACTIVE:
		_ammo = 0;
		_canShoot = false;

#@rpc("call_local")
func shoot(bulletDir:Vector2):
	if _ammo <=0 and _reloadTimer.time_left == 0:
		reload_start_timer();
		print("RELOAD");
	if !_canShoot or _ammo <=0 or !_reloadTimer.is_stopped():
		return;
	
	instantiate_shoot.rpc(bulletDir);
	
@rpc("call_local")
func instantiate_shoot(bulletDir:Vector2):
	var bulletInst = _bullet.instantiate();
	var cadence = _bulletCadence + Time.get_ticks_msec();
	OnShooted.emit();
	if bulletInst is ProjectileArea:
		bulletInst.global_position = _spawnOrigin.global_position;
		if bulletInst :
			_ammo -=1;
			ammo_changed.emit();
			bulletInst._dir = bulletDir;
			bulletInst._owner = _owner;
			_shootTimer.start();
			_canShoot = false;
			get_tree().current_scene.add_child(bulletInst);
			if _owner._target:
				if _owner._target._status == Character2D.CharacterStatus.ACTIVE:
					bulletInst._target = _owner._target;
	

func reload_start_timer():
	if(_ammo != _maxAmmo and _reloadTimer.is_stopped()):
		Sound2dManager.play(_weaponData._reloadSound,_owner.global_position);
		_reloadTimer.start();
	#_reloadBar.show();

func reload():
	_ammo = _maxAmmo;
	ammo_changed.emit();
	#_reloadBar.hide();
	_reloadTimer.stop();

func _shootTimer_timeout():
	_canShoot = true;
