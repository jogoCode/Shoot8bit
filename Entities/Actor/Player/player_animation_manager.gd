extends Node
class_name PlayerAnimation

@onready var _character:CharacterPlayer2D = get_parent();
var _playerMovement:PlayerMovement;
@export var _animatedSprite:AnimatedSprite2D;
@export var _dustOrigin:Node2D;

signal OnFlipH(bool);

func _ready() -> void:
	_playerMovement = _character._playerMovement;
	_connect_signals();
	
	change_animation("Idle");
	

func _connect_signals():
	_playerMovement.OnMovement.connect(move_animation);
	_character.OnSlide.connect(slide_animation);
	OnFlipH.connect(flip_h);
	_animatedSprite.frame_changed.connect(_on_walk);
	_animatedSprite.animation_finished.connect(_on_animation_finished);

func _process(delta: float) -> void:
	pass

#region ANIMATIONS LOGIC
func move_animation(isMoving:bool):
	if isMoving and int(_character._impulseVelocity.length()) == 0:
		change_animation("Run");
	elif int(_character._impulseVelocity.length()) == 0:
		change_animation("Idle");

func slide_animation():
	change_animation("Slide");

#endregion


func get_animation() -> String: 
	return _animatedSprite.animation;

func change_animation(newAnim:String):
	_animatedSprite.play(newAnim);

func flip_h(active:bool):
	_animatedSprite.flip_h = active;

#region SIGNALS 
func _on_walk():
	if(_animatedSprite.frame == 0 and _animatedSprite.animation == "Run"):
		var dustFxInst = load("res://Entities/FX/dust_fx.tscn").instantiate();
		dustFxInst.global_position = _dustOrigin.global_position;
		get_tree().get_current_scene().add_child(dustFxInst);
		SoundFxManager.play("footstep_carpet");

func _on_animation_finished():
	if(get_animation() == "Slide"):
		change_animation("Idle");
#endregion
