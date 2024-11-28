extends Character2D;

@export var _weaponSystem:WeaponSystem;
@export var _playerMovement:PlayerMovement;



func shoot():
	_weaponSystem.shoot(get_local_mouse_position().normalized()*3);
	
func reload():
	_weaponSystem.reload();
