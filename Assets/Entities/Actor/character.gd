extends CharacterBody2D
class_name Character2D

#@export var _speed:float = 5.0;
#@export var _sprintSpeed:float = 5.0;
#@export var _jumpVel:float= 4.5;

@onready var _healthSystem:HealthSystem = get_node("HealthSystem");
@export var _target:Character2D;

var _impulseVelocity:Vector2;
var _impulseFriction:float;
var _lastVel:Vector2;
var _direction:Vector2:
	get: return _direction;
var _vel:Vector2:
	get: return _vel;

var _status:CharacterStatus = CharacterStatus.ACTIVE:
	get: return _status;
	
enum CharacterStatus{
	ACTIVE,
	NOT_ACTIVE
}

func set_status(newStatus:CharacterStatus):
	_status = newStatus;


func impulse(delta):
	if _impulseVelocity.length() > 0:
		_impulseVelocity = _impulseVelocity.lerp(Vector2.ZERO, _impulseFriction*delta);
		if(_impulseVelocity.length() <= 0.1+_impulseFriction/2):
			_impulseVelocity = Vector2.ZERO;
			#velocity = _lastVel;
			return;
		velocity.x = _vel.x+_impulseVelocity.x;
		velocity.y = _vel.y+_impulseVelocity.y;

func _physics_process(delta: float) -> void:
	if _healthSystem._healthState == HealthSystem.HealthStates.DEAD:
		velocity = Vector2.ZERO;
		return;
	impulse(delta);
	
	move_and_slide();

func applyImpulse(force: Vector2,impulseFriction):
	_impulseVelocity= Vector2.ZERO;
	_impulseFriction = impulseFriction;
	if(_impulseVelocity.length()==0):
		_impulseVelocity += force;

func dash(direction):
	_lastVel = velocity;
	applyImpulse(direction*20,15);
