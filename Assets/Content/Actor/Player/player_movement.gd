extends CharacterBody2D
class_name PlayerMovement


var _owner:CharacterBody2D = get_parent();
const SPEED = 300.0
const ACCEL = 15;
signal OnMovement(bool);

func _physics_process(delta: float) -> void:

	var direction := Input.get_vector("ui_left", "ui_right","ui_up","ui_down").normalized();
	if direction:
		velocity.x = lerp(velocity.x,direction.x * SPEED,ACCEL*delta);
		velocity.y = lerp(velocity.y,direction.y * SPEED,ACCEL*delta);
		OnMovement.emit(true);
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED*4*delta)
		velocity.y = move_toward(velocity.y, 0, SPEED*4*delta)
		OnMovement.emit(false);

	move_and_slide()
