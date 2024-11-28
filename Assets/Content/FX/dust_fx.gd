extends AnimatedSprite2D

func _ready() -> void:
	animation_finished.connect(finished);


func finished()->void:
	queue_free();
