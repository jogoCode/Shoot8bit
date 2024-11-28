extends Node
class_name JaugeSystem

@onready var _owner = get_parent();
@export var _actualValue:float = 100;
@export  var _baseValue:float = 100;
@export  var _maxValue:float = 100;

signal actualValueChanged;

func _ready() -> void:
	pass

func _set_actual_value(newValue:float,increment:bool=false):
	if increment:
		_actualValue += newValue;
		_actualValue = clamp(_actualValue,0,100);
		actualValueChanged.emit();
		return;
	_actualValue = newValue;
	_actualValue = clamp(_actualValue,0,100);
	actualValueChanged.emit();

func _set_base_value(newValue):
	_baseValue = newValue;

func _set_max_value(newValue):
	_maxValue = newValue
