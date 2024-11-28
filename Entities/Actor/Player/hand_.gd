extends Node2D

@onready var _playerAnimation:PlayerAnimation = get_parent().get_node("PlayerAnimation");
@onready var _weaponSystem:WeaponSystem = get_parent().get_node("WeaponSystem");
@onready var _weaponSprite:Sprite2D  = get_parent().get_node("HandOrigin/WeaponSprite");
@export var _bulletOrigin:Node2D;
@export var _oscillator:Oscillator;

var _bulletOriginStartPos:Vector2;

func _ready() -> void:
	_bulletOriginStartPos = _weaponSystem._weaponData._muzzleOffset;
	if(!_playerAnimation):
		printerr("Player animation value is null !");
	if(!_weaponSystem):
		printerr("Weapon system value is null !");
	if(!_bulletOrigin):
		printerr("Bullet origin value is null !");
	if(!_oscillator):
		printerr("oscillator value is null !");
		
	
		
	_weaponSystem.OnShooted.connect(_on_shoot);

func _process(delta: float) -> void:
	progressive_rotate(delta);
	#look_at(get_global_mouse_position());
	if(get_global_mouse_position().x < global_position.x):
		_playerAnimation.OnFlipH.emit(true);
		_weaponSprite.flip_v = true;
		_weaponSprite.offset.y = 3;
		_bulletOrigin.position.y = -_bulletOriginStartPos.y;
	if(get_global_mouse_position().x > global_position.x):
		_playerAnimation.OnFlipH.emit(false);
		_weaponSprite.flip_v = false;
		_weaponSprite.offset.y = 0;
		_bulletOrigin.position.y = _bulletOriginStartPos.y;

func progressive_rotate(delta:float):
	var vect = get_global_mouse_position();
	var direction = (vect - global_position).normalized();
	var angle = direction.angle();
	rotation = lerp_angle(rotation,angle,15*delta);


func _on_shoot():
	_oscillator._add_velocity(20);
	
