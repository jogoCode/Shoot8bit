extends Node2D

@export var _playerAnimation:PlayerAnimation;


func _process(delta: float) -> void:
	look_at(get_global_mouse_position());
	if(get_global_mouse_position().x < global_position.x):
		_playerAnimation.OnFlipH.emit(true);
	if(get_global_mouse_position().x > global_position.x):
		_playerAnimation.OnFlipH.emit(false);
