extends JaugeSystem
class_name HealthSystem


var _healthState = HealthStates.ALIVE;
var _killer:String;


enum HealthStates{
	ALIVE,
	DEAD
}

signal take_damage(damage,damager);

func _ready() -> void:
	take_damage.connect(_take_damage);
	actualValueChanged.connect(_death);
	await get_tree().create_timer(0.5);

func _process(delta: float) -> void:
	pass

func _take_damage(damage,damager):
	_set_actual_value(-damage,true);
	if damager:
		_killer = damager.name;
	feed_back(damage);

func feed_back(damage):
	FeedBackSystem.create_fx(FeedBackSystem._hitFx,Vector3(_owner.global_position.x,_owner.global_position.y+1,_owner.global_position.z),_owner.global_position);
	if _owner is CharacterPlayer:
		FeedBackSystem.camera_shake(0.1*damage);
	for node in _owner.get_children():
		if node.has_signal("add_velocity"):
			node.add_velocity.emit(2*damage);

func _death():
	if _actualValue > 0:
		return;
	if _owner is Character:
		_owner.set_status(Character.CharacterStatus.NOT_ACTIVE);
	print(_owner.name," was killed by",_killer);
	_owner.hide();
	_healthState = HealthStates.DEAD;
	if _owner is EnemyCharacter:
		_owner.hide();
		await  get_tree().create_timer(5).timeout;
		_owner.queue_free();
