extends Hitbox
class_name ProjectileArea

var _dir:Vector2 =Vector2.RIGHT;
@export var _lifeTime:float = 2;
@export var _speed:float = 5;
var _target:Node3D;
 
func _ready() -> void:
	super._ready();
	body_entered.connect(_body_entered);
	#global_transform.basis.z = -_dir.normalized();
	await get_tree().create_timer(_lifeTime).timeout;
	queue_free();


func _physics_process(delta: float) -> void:
	look_at(position+_dir.normalized());
	position += Vector2(_dir.x,_dir.y)*_speed*delta;


func _body_entered(body):
	Sound2dManager.play("bullet_ricochet",global_position);
	impact_fx();
	_speed = 0;
	queue_free();

func _area_entered(area):
	super._area_entered(area);
	if(area.get_parent() is Pickup): return;
	if !(area is ProjectileArea):
		impact_fx()
		_speed = 0;
		hide();
		await get_tree().create_timer(0.01).timeout;
		queue_free();

func impact_fx():
	var muzzleFx:Node2D = load("res://Entities/FX/muzzle_fx.tscn").instantiate();
	if(!muzzleFx): return;
	muzzleFx.global_position = global_position;
	muzzleFx.look_at(global_position-_dir);
	get_tree().current_scene.add_child(muzzleFx);
