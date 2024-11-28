extends Node2D

@export var _playerAnimation:PlayerAnimation;
@export var _weaponSprite:Sprite2D;
@export var _bulletOrigin:Node2D;


func _process(delta: float) -> void:
	look_at(get_global_mouse_position());
	if(get_global_mouse_position().x < global_position.x):
		_playerAnimation.OnFlipH.emit(true);
		_weaponSprite.flip_v = true;
		_weaponSprite.offset.y = 3;
		_bulletOrigin.position.y = 3;
	if(get_global_mouse_position().x > global_position.x):
		_playerAnimation.OnFlipH.emit(false);
		_weaponSprite.flip_v = false;
		_weaponSprite.offset.y = 0;
		_bulletOrigin.position.y = 0;
