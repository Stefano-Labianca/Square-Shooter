extends Particles2D

signal player_killed

func _ready() -> void:
	$Sprite/AnimationPlayer.play("armored_blast")


func _on_BotBlast_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		Global.play_dead_sound(body.position)
		Global.player = null
		body.queue_free()
		_send_signal()

	if body.is_in_group("enemy"):
		body.queue_free()


func _send_signal() -> void:
	if not self.is_connected("player_killed", Global.world_node, "_on_player_killed"):
		var _err = self.connect("player_killed", Global.world_node, "_on_player_killed")
		emit_signal("player_killed")


func _on_AnimationPlayer_animation_finished(_anim_name: String) -> void:
	self.queue_free()
