extends Node
class_name PlayerAnimation

@export var _animatedSprite:AnimatedSprite2D;

signal OnFlipH(bool);

func _ready() -> void:
	change_animation("Idle");
	OnFlipH.connect(flip_h);



func _process(delta: float) -> void:
	pass


func change_animation(newAnim:String):
	_animatedSprite.play(newAnim);

func flip_h(active:bool):
	_animatedSprite.flip_h = active;
