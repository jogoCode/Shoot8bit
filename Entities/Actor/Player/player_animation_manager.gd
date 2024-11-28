extends Node
class_name PlayerAnimation

@onready var _character:Character2D = get_parent();
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
	OnFlipH.connect(flip_h);
	_animatedSprite.frame_changed.connect(_on_walk);

func _process(delta: float) -> void:
	pass


func move_animation(isMoving:bool):
	if isMoving:
		change_animation("Run");
	else:
		change_animation("Idle");

func get_animation() -> String: 
	return _animatedSprite.animation;

func change_animation(newAnim:String):
	_animatedSprite.play(newAnim);

func flip_h(active:bool):
	_animatedSprite.flip_h = active;

func _on_walk():
	if(_animatedSprite.frame == 0 and _animatedSprite.animation == "Run"):
		var dustFxInst = load("res://Entities/FX/dust_fx.tscn").instantiate();
		dustFxInst.global_position = _dustOrigin.global_position;
		get_tree().get_current_scene().add_child(dustFxInst);
		SoundFxManager.play("footstep_carpet");
