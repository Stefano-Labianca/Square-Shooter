extends Particles2D

signal player_killed
var dumb

func _ready() -> void:
	$shock_wave/AnimationPlayer.play("expand")


func _on_Blast_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		Global.play_dead_sound(body.position)
		body.queue_free()
		Global.player = null
		_send_signal()


	if body.is_in_group("enemy"):
		body.queue_free()


func _send_signal() -> void:
	if not self.is_connected("player_killed", Global.world_node, "_on_player_killed"):
		dumb = self.connect("player_killed", Global.world_node, "_on_player_killed")
		emit_signal("player_killed")


func _on_AnimationPlayer_animation_finished(_anim_name: String) -> void:
	self.queue_free()
