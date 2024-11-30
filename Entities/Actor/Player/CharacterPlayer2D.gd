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
	_camera.get_node("AudioListener2D").current = true;
	
	

func shoot():
	_weaponSystem.shoot(get_local_mouse_position().normalized()*3);
	
func slide():
	if(int(_impulseVelocity.length()) == 0):
		OnSlide.emit();
		Sound2dManager.play("Slide",global_position);
		applyImpulse(_lastVel*400,5);	

func reload():
	_weaponSystem.reload();

func _on_death():
	$Hurtbox/CollisionShape2D.disabled = true;
	_playerAnimation.change_animation("Die");
	get_node("HandOrigin").hide();
	var hurtbox:Area2D = get_node("Hurtbox")
	hurtbox.monitoring = false;
	hurtbox.monitoring = true;
	var pickup:Pickup = load("res://Entities/Pickups/pickup.tscn").instantiate();
	pickup._weaponData = _weaponSystem._weaponData;
	pickup.global_position = global_position + Vector2.UP*4;
	await  get_tree().create_timer(0.1).timeout;
	get_tree().current_scene.add_child(pickup);
	pickup.show();
