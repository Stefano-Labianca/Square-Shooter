extends RigidBody2D

export var bullet_speed: int = 1000

func _ready() -> void:
	$Sprite.texture = Global.bullet_texture


# Called when the bullet exit from the scene
func _on_VisibilityNotifier2D_viewport_exited(_viewport: Viewport) -> void:
	self.queue_free()


func _on_Hitbox_body_entered(body: Node) -> void:
	if body.is_in_group("enemy"):
		self.queue_free()

