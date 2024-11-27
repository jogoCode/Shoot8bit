extends CharacterBody2D
class_name PlayerMovement


const SPEED = 300.0
signal OnMovement(bool);

func _physics_process(delta: float) -> void:

	var direction := Input.get_vector("ui_left", "ui_right","ui_up","ui_down").normalized();
	if direction:
		velocity.x = direction.x * SPEED;
		velocity.y = direction.y * SPEED;
		OnMovement.emit(true);
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		OnMovement.emit(false);
	move_and_slide()
