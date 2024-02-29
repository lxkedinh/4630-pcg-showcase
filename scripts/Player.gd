extends CharacterBody2D


@export var speed: int = 10
enum DIRECTION {LEFT, RIGHT, UP, DOWN}
var last_direction: DIRECTION

func _ready():
	$AnimatedSprite2D.play()

func _physics_process(delta):
	play_idle_animation()
	move_from_input()
	choose_move_animation()

func play_idle_animation():
	if velocity.length() == 0:
		$AnimatedSprite2D.animation = "idle"

func move_from_input():
	var input_direction = Input.get_vector("walk_left", "walk_right", "walk_up", "walk_down")
	velocity = input_direction * speed
	move_and_slide()

func choose_move_animation():
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk_horizontal"
		$AnimatedSprite2D.flip_h = velocity.x > 0
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "walk_down" if velocity.y > 0 else "walk_up"
