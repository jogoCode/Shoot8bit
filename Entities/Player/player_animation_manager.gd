extends Node
class_name PlayerAnimation

@export var _playerMovement:PlayerMovement;
@export var _animatedSprite:AnimatedSprite2D;

signal OnFlipH(bool);

func _ready() -> void:
	_playerMovement = get_parent();
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

func change_animation(newAnim:String):
	_animatedSprite.play(newAnim);

func flip_h(active:bool):
	_animatedSprite.flip_h = active;
