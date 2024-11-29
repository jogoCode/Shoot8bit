@tool
extends Camera2D
class_name Camera

@export var _target:Node2D;
@export var _speed:float;
@export var _offset:Vector2;
var _targetPos:Vector2;
var _originOffset:Vector2;
var _originTarget:Node2D;



func _ready() -> void:
	if(!_target):
		printerr("no target !!");
	_originOffset =_offset;
	_originTarget = _target;

func _physics_process(delta: float) -> void:
	if !_target:
		return;
	_targetPos = _target.global_position;
	position = lerp(position,_offset+_targetPos,delta*_speed);


func camera_shake(force):
	for node in get_children():
		if node is Oscillator:
			node.add_velocity.emit(force);

func reset_camera_offset()->void:
	_offset = _originOffset;
	_target = _originTarget;
