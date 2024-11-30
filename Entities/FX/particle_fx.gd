extends GPUParticles2D

@export var _particleToFinished:GPUParticles2D;

func _ready() -> void:
	emitting = true;
	_particleToFinished.finished.connect(_finished);

func _finished():
	queue_free();
