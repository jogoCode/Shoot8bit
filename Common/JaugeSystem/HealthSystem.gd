extends JaugeSystem
class_name HealthSystem


var _healthState = HealthStates.ALIVE;
var _killer:String;

signal OnDeath();

enum HealthStates{
	ALIVE,
	DEAD
}

signal take_damage(damage,damager);

func _ready() -> void:
	take_damage.connect(_take_damage);
	actualValueChanged.connect(_death);
	OnDeath.connect(_owner._on_death);
	await get_tree().create_timer(0.5);

func revive():
	pass

@rpc("call_local")
func _take_damage(damage,damager):
	_set_actual_value(-damage,true);
	var oscillator:Oscillator = get_parent().get_node("OscillatorScale");
	if oscillator:
		oscillator._add_velocity(damage*2);
	if damager:
		_killer = damager._pseudo;
		
@rpc("call_local")
func _death():
	if _actualValue > 0:
		return;
	if _owner is Character2D:
		_owner.set_status(Character2D.CharacterStatus.NOT_ACTIVE);
#region for Online
	print(_owner._pseudo," was killed by",_killer);
	
#endregion
	#_owner.hide();
	if(_healthState != HealthStates.DEAD):
		OnDeath.emit();
	_healthState = HealthStates.DEAD;
