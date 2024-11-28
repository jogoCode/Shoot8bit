extends Oscillator
class_name  OscillatorScale


func ScaleMode():
	if(_target.scale >Vector3(0.25,0.25,0.25)):
		if _displacement !=0:
			_target.scale =  _baseScale+ Vector3(_displacement,-_displacement,-_displacement)*_scaleFactor;
			_target.scale = clamp(_target.scale, Vector3.ZERO,Vector3(100,100,100));

func _process(delta: float) -> void:
	super._process(delta);
	ScaleMode();
