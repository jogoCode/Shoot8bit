extends Node
class_name PlayerMovement


@onready var _owner:Character2D = get_parent();
var _velocity:Vector2;
var _direction:Vector2;
@export var SPEED = 300.0
@export var ACCEL = 15;

signal OnMovement(bool);

func _ready() -> void:
	var inputManager:InputManager = get_parent().get_node("InputManager");
	inputManager.OnDirectionInput.connect(_on_direction_input);

func _physics_process(delta: float) -> void:
	if not _owner.is_multiplayer_authority(): return;
	if(_owner._status != Character2D.CharacterStatus.ACTIVE): return;
	if _direction:
		_owner._lastVel = _direction;
		_velocity.x = lerp(_velocity.x,_direction.x * SPEED,ACCEL*delta);
		_velocity.y = lerp(_velocity.y,_direction.y * SPEED,ACCEL*delta);
		OnMovement.emit(true);		
	else:
		_velocity.x = move_toward(_velocity.x, 0, SPEED*4*delta)
		_velocity.y = move_toward(_velocity.y, 0, SPEED*4*delta)
		OnMovement.emit(false);
	_owner.velocity = _velocity;


func _on_direction_input(direction:Vector2):
	_direction = direction;

func slide():
	_owner
