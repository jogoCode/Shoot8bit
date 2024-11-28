extends Node
class_name WeaponSystem;

#@onready var _owner:Character = get_parent();
@export var _weaponData:RWeapon;
@export var _bullet:PackedScene;
@export var _weaponVisual:Node3D;
@export var _spawnOrigin:Node3D;
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



func _ready() -> void:
	#to initialized hud
	ammo_changed.emit();
	if !_weaponVisual:
		printerr("no weapon visual");
	if !_spawnOrigin:
		printerr("no spawn origin");
	if !_bullet:
		printerr("no bullet packed scene");
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
	_weaponVisual.add_child(_weaponData._model.instantiate());


func _process(delta: float) -> void:
	var reloadBar:ProgressBar  = _reloadBar.get_node("SubViewport/ProgressBar");
	reloadBar.value = _reloadTimer.time_left;
	reloadBar.max_value = _reloadTimer.wait_time;
	if _owner._status == Character.CharacterStatus.NOT_ACTIVE:
		_ammo = 0;
		_canShoot = false;


func shoot(bulletDir:Vector3):
	if _ammo <=0 and _reloadTimer.time_left == 0:
		reload_start_timer();
		print("RELOAD");
	if !_canShoot or _ammo <=0:
		return;
	var bulletInst = _bullet.instantiate();
	var cadence = _bulletCadence + Time.get_ticks_msec();
	if bulletInst:
		bulletInst.global_position = _spawnOrigin.global_position;
		if bulletInst is ProjectileArea:
			_ammo -=1;
			ammo_changed.emit();
			bulletInst._dir = bulletDir;
			bulletInst._owner = _owner;
			_shootTimer.start();
			_canShoot = false;
			_owner.owner.add_child(bulletInst);
			if _owner._target:
				if _owner._target._status == Character.CharacterStatus.ACTIVE:
					bulletInst._target = _owner._target;
			if _shakeWhenShoot:
				FeedBackSystem.camera_shake(_weaponData._camShakeAmount);

func reload_start_timer():
	_reloadTimer.start();
	_reloadBar.show();

func reload():
	_ammo = _maxAmmo;
	ammo_changed.emit();
	_reloadBar.hide();
	_reloadTimer.stop();

func _shootTimer_timeout():
	_canShoot = true;
