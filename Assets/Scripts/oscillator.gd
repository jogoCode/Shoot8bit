# THIS SCRIPT MANAGE THE JUICY EFFECT
# USE THE SIGNAL "add_velocity" TO APPLY JUICY EFFECT ON THE SCALE OF THE TARGET


extends Node
class_name Oscillator;

signal add_velocity(amplitude);

@export var _mode:Modes = Modes.SCALE;

enum Modes{
	SCALE,
	POSITION,
	ROTATION
}

# This is the target where the effect will be applied
@export var _target:Node;


# the amplitude of the juicy effect use signal "add_velocity" to change it
var _velocity:float; 

@export_range(0,900) var _spring:float = 900.5;
var _displacement:float;
@export_range(0,900) var _damp:float = 10.3;


@export var _scaleFactor = 0.5;
@onready var _baseScale;


func _ready():
	if _target.scale == null:
		printerr("Your target dont have scale !!!");
		return;
	_baseScale = _target.scale;
	add_velocity.connect(_add_velocity);

func _process(delta):
	Oscillator(delta);
	#match _mode:
		#Modes.SCALE:
			#ScaleMode();
		#Modes.POSITION:
			#PosMode();
		#Modes.ROTATION:
			#RotMode();
	#if Engine.get_frames_per_second() < 10:
		#_target.scale =  _baseScale;	
		#_displacement = 0;

func Oscillator(delta):
	var force = -_spring * _displacement - _damp * _velocity;
	_velocity += force * delta;
	_displacement += _velocity * delta;
	return _displacement;

func SetValues(velocity,spring,displacement,damp):
	_velocity = velocity;
	_spring = spring;
	_displacement = displacement;
	_damp = damp;

func ScaleMode():
	if(_target.scale >Vector3(0.25,0.25,0.25)):
		if _displacement !=0:
			_target.scale =  _baseScale+ Vector3(_displacement,-_displacement,-_displacement)*_scaleFactor;
			_target.scale = clamp(_target.scale, Vector3.ZERO,Vector3(100,100,100));

func PosMode():
	_target.position.x = _displacement *25;
	_target.position.y = _displacement *25;

func RotMode():
	_target.rotation.z = _displacement;

func _add_velocity(amplitude:float):
	_velocity = amplitude;
	await get_tree().create_timer(2).timeout;
	_target.scale = _baseScale;
