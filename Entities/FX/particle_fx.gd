extends GPUParticles2D

func _ready() -> void:
	emitting = true;
	finished.connect(_finished);

func _finished():
	queue_free();
