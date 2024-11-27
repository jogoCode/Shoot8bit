extends CharacterBody2D


const SPEED = 300.0


func _physics_process(delta: float) -> void:

	var direction := Input.get_vector("ui_left", "ui_right","ui_up","ui_down").normalized();
	if direction:
		velocity.x = direction.x * SPEED;
		velocity.y = direction.y * SPEED;
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	move_and_slide()
