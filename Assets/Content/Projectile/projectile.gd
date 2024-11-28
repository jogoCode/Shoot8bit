extends Node2D

@export var _area2D:Area2D;
@export var _destroyAtCollision = true;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_area2D.area_entered.connect(destroy_at_collision);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func destroy_at_collision(area:Area2D)->void:
	if _destroyAtCollision:
		queue_free();
