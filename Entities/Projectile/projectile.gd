extends Hitbox
class_name ProjectileArea

var _dir:Vector2 =Vector2.RIGHT;
@export var _lifeTime:float = 2;
@export var _speed:float = 5;
var _target:Node3D;
 
func _ready() -> void:
	super._ready();
	
	#global_transform.basis.z = -_dir.normalized();
	await get_tree().create_timer(_lifeTime).timeout;
	queue_free();


func _process(delta: float) -> void:
	look_at(position+_dir.normalized());
	position += Vector2(_dir.x,_dir.y)*_speed*delta;


func _area_entered(area):
	super._area_entered(area);
	if !(area is ProjectileArea ):
		hide();
		await get_tree().create_timer(0.5).timeout;
		queue_free();
