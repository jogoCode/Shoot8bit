extends Node
class_name InputManager;

@onready var _character:Character2D = get_parent();

signal OnDirectionInput(Vector2);

func _physics_process(delta: float) -> void:
	character_actions(delta);

func character_actions(delta):
	if not _character.is_multiplayer_authority(): return;
	if _character.get("_status") == Character2D.CharacterStatus.NOT_ACTIVE:
		return;
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := Vector2(input_dir.x,input_dir.y).normalized();
	OnDirectionInput.emit(direction);
	
	# Handle Dash
	if Input.is_action_just_pressed("ui_accept"):
		_character.dash(Vector3(input_dir.x,0,input_dir.y));
	
	# Shoot
	if Input.is_action_pressed("shoot"):
		_character.shoot();
	
	# Reload
	if Input.is_action_just_pressed("reload"):
		_character._weaponSystem.reload_start_timer();
	if Input.is_action_just_pressed("slide"):
		_character.slide();
	_character._isInteract = Input.is_action_just_pressed("interact");

	#_character.boost(Input.is_action_pressed("boost"));
	
	#_character.movement(direction,delta);


func get_sticks_vectors()->Array[Vector2]:
	var array:Array[Vector2];
	var lStick = Vector2(Input.get_joy_axis(0,JOY_AXIS_LEFT_X),Input.get_joy_axis(0,JOY_AXIS_LEFT_Y)).normalized();
	var rStick = Vector2(Input.get_joy_axis(0,JOY_AXIS_RIGHT_X),Input.get_joy_axis(0,JOY_AXIS_RIGHT_Y)).normalized();
	array = [lStick,rStick];
	return array;
