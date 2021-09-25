extends Control

var animation: Animation


func _ready() -> void:
	animation = $MarginContainer/LoadingLabel/AnimationPlayer.get_animation("Loading")
	animation.set_loop(true)

	$MarginContainer/LoadingLabel/AnimationPlayer.play("Loading")


func stop_anim() -> void:
	animation.set_loop(false)
	$MarginContainer/LoadingLabel/AnimationPlayer.stop(false)
