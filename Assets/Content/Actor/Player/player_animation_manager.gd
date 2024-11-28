extends Node
class_name PlayerAnimation

@onready var _character:Character2D = get_parent();
var _playerMovement:PlayerMovement;
@export var _animatedSprite:AnimatedSprite2D;
@export var _dustOrigin:Node2D;

signal OnFlipH(bool);

func _ready() -> void:
	_playerMovement = _character._playerMovement;
	_playerMovement.OnMovement.connect(move_animation);
	change_animation("Idle");
	OnFlipH.connect(flip_h);



func _process(delta: float) -> void:
	pass


func move_animation(isMoving:bool):
	if isMoving:
		change_animation("Run");
	else:
		change_animation("Idle");

func get_animation() -> String: 
	return _animatedSprite.animation;

func change_animation(newAnim:String):
	_animatedSprite.play(newAnim);

func flip_h(active:bool):
	_animatedSprite.flip_h = active;
