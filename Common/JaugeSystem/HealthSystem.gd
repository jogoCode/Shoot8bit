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
	var oscillator:Oscillator = get_parent().get_node("OscillatorScale");
	if oscillator:
		oscillator._add_velocity(damage*2);
	if damager:
		_killer = damager._pseudo;



func _death():
	if _actualValue > 0:
		return;
	if _owner is Character2D:
		_owner.set_status(Character2D.CharacterStatus.NOT_ACTIVE);
#region for Online
	print(_owner._pseudo," was killed by",_killer);
#endregion
	_owner.hide();
	_healthState = HealthStates.DEAD;
