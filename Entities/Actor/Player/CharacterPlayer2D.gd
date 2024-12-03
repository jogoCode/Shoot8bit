extends Character2D;
class_name CharacterPlayer2D

@export var _weaponSystem:WeaponSystem;
@export var _playerMovement:PlayerMovement;
var _pseudo:String;
var _camera:Camera;

var _canSlide:bool = true;
var _isInteract:bool = false;

signal OnSlide();

func _enter_tree():
	set_multiplayer_authority(str(name).to_int());

func set_pseudo(pseudo:String):
	_pseudo = pseudo;

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
	if(int(_impulseVelocity.length()) == 0) and _canSlide:
		_canSlide = false;
		OnSlide.emit();
		Sound2dManager.play("Slide",global_position);
		applyImpulse(_lastVel*400,5);
		await get_tree().create_timer(1).timeout;
		_canSlide = true;

func reload():
	_weaponSystem.reload();


func _respawn():
	global_position = Vector2.ZERO;
	_weaponSystem.set_weapon_stats();
	$Hurtbox/CollisionShape2D.disabled = false;
	set_status(Character2D.CharacterStatus.ACTIVE);
	_healthSystem.revive();
	_playerAnimation.change_animation("Die");
	get_node("HandOrigin").show();

@rpc("call_local")
func set_is_interact(value:bool):
	_isInteract = value;

@rpc("call_local")
func rpc_death():
	$Hurtbox/CollisionShape2D.disabled = true;
	_playerAnimation.change_animation("Die");
	get_node("HandOrigin").hide();
	var pickup:Pickup = load("res://Entities/Pickups/pickup.tscn").instantiate();
	pickup._weaponData = _weaponSystem._weaponData;
	pickup.global_position = global_position + Vector2.UP*4;
	await  get_tree().create_timer(0.1).timeout;
	if(!_weaponSystem._weaponData._name.contains("gun")):
		get_tree().current_scene.add_child(pickup);
	_weaponSystem._weaponData = load("res://Ressources/Weapons/w_gun.tres");
	await  get_tree().create_timer(2).timeout;
	_respawn()


func _on_death():
	rpc_death.rpc();
