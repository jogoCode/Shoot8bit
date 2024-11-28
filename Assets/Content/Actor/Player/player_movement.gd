extends Node
class_name PlayerMovement


@onready var _owner:CharacterBody2D = get_parent();
var _velocity:Vector2;
var _direction:Vector2;
const SPEED = 300.0
const ACCEL = 15;
signal OnMovement(bool);

func _ready() -> void:
	var inputManager:InputManager = get_parent().get_node("InputManager");
	inputManager.OnDirectionInput.connect(_on_moved);

func _physics_process(delta: float) -> void:
	if _direction:
		_velocity.x = lerp(_velocity.x,_direction.x * SPEED,ACCEL*delta);
		_velocity.y = lerp(_velocity.y,_direction.y * SPEED,ACCEL*delta);
		OnMovement.emit(true);		
	else:
		_velocity.x = move_toward(_velocity.x, 0, SPEED*4*delta)
		_velocity.y = move_toward(_velocity.y, 0, SPEED*4*delta)
		OnMovement.emit(false);
	_owner.velocity = _velocity;


func _on_moved(direction:Vector2):
	_direction = direction;
	
