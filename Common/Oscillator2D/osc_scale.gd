extends Oscillator
class_name  OscillatorScale


func ScaleMode():
	if(_target.scale >Vector2(0.25,0.25)):
		if _displacement !=0:
			_target.scale =  _baseScale+ Vector2(_displacement,-_displacement)*_scaleFactor;
			_target.scale = clamp(_target.scale, Vector2.ZERO,Vector2(100,100));

func _process(delta: float) -> void:
	super._process(delta);
	ScaleMode();
