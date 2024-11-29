extends Character2D;
class_name CharacterPlayer2D

@export var _weaponSystem:WeaponSystem;
@export var _playerMovement:PlayerMovement;
var _pseudo:String;
var _camera:Camera;

signal OnSlide();

func _enter_tree():
	set_multiplayer_authority(str(name).to_int());
	
func _ready() -> void:
	if not is_multiplayer_authority(): return;
	var camInst = preload("res://Common/Camera/camera_2d.tscn").instantiate();
	_camera = camInst;
	_camera._target = get_node("HandOrigin/BulletOrigin");
	get_tree().current_scene.add_child(camInst);
	_camera.make_current();
	

func shoot():
	_weaponSystem.shoot(get_local_mouse_position().normalized()*3);
	
func slide():
	if(int(_impulseVelocity.length()) == 0):
		OnSlide.emit();
		SoundFxManager.play("Slide");
		applyImpulse(_lastVel*400,5);	

func reload():
	_weaponSystem.reload();
