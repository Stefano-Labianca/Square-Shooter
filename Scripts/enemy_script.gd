extends KinematicBody2D

signal player_killed

const WEIGHT: float = 0.55
const EXPLOSION_VOLUME: float = -6.5
const HIT_VOLUME: float = -4.50

var enemy_speed: int
var enemy_lives: int
var enemy_knockback_value: float
var enemy_sprite: Texture
var enemy_type: int
var enemy_score: int

var is_stun: bool = false
var enemy_velocity: Vector2 = Vector2()

var can_damage: bool = false


func _ready() -> void:
	$Sprite.texture = enemy_sprite


func _physics_process(delta: float) -> void:
	_follow_player(delta)


# Permette ai nemici di seguire il giocatore.
func _follow_player(delta: float) -> void:
	if Global.player != null and not is_stun:
		enemy_velocity = self.global_position.direction_to(Global.player.global_position)

	elif is_stun:
		enemy_velocity = lerp(enemy_velocity, Vector2.ZERO, WEIGHT)

	self.global_position += enemy_velocity * enemy_speed * delta


func _on_Hitbox_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		if enemy_type == 3: # Verifico se il tipo di nemico è il 'bomber'
			_show_explosion("bomber_explosion")
			_play_explosion_sound("bomber_explosion")

		Global.play_dead_sound(body.position)

		self.queue_free()
		body.queue_free() # Uccidi il player
		Global.player = null

		_connect_player_killed_signal()
		emit_signal("player_killed")


	if body.is_in_group("bullet") and not is_stun and can_damage:
		if enemy_lives != 0:
			is_stun = true

			enemy_velocity = -enemy_velocity * enemy_knockback_value
			enemy_lives -= 1

			if enemy_lives == 0:
				if enemy_type == 3: # Check if the enemy is the 'bomber'
					_show_explosion("bomber_explosion")
					_play_explosion_sound("bomber_explosion")

				if enemy_type == 4:  # Check if the enemy is the 'armored'
					_show_explosion("armored_explosion")
					_play_explosion_sound("armored_explosion")

				Global.score_node.callv("update_score", [enemy_score])
				_show_score_feed()
				self.queue_free()

			_play_hit_sound()
			$StunTimer.start()
			$Sprite.texture = Global.stun_texture


# Show the explosion for the enemy type 'bomber' and 'armored'
func _show_explosion(explosion_type: String) -> void:
	var ExplosionParticles = Global.explosion_type[explosion_type].particles
	var explosion_particles_instance = ExplosionParticles.instance()

	explosion_particles_instance.position = self.position
	get_tree().get_root().call_deferred("add_child", explosion_particles_instance, true)
	explosion_particles_instance.emitting = true



func _play_explosion_sound(explosion_type: String) -> void:
	var explosion_audio = AudioStreamPlayer2D.new()

	explosion_audio.stream = Global.explosion_type[explosion_type].sound
	explosion_audio.position = self.position
	explosion_audio.volume_db = EXPLOSION_VOLUME

	get_tree().get_root().call_deferred("add_child", explosion_audio, true)
	explosion_audio.play(0)


func _play_hit_sound() -> void:
	var hit_sound = AudioStreamPlayer2D.new()

	hit_sound.stream = load("res://assets/audio/sounds/hit.wav")
	hit_sound.position = self.position
	hit_sound.volume_db = HIT_VOLUME

	get_tree().get_root().call_deferred("add_child", hit_sound, true)
	hit_sound.play(0)


func _show_score_feed() -> void:
	var score_feed: Label = Global.score_feed.instance()
	score_feed.text = "+" + str(enemy_score)
	score_feed.rect_position = self.position

	get_tree().get_root().call_deferred("add_child", score_feed, true)


# Called when the enemy is no more stunned.
func _on_StunTimer_timeout() -> void:
	is_stun = false
	$Sprite.texture = enemy_sprite


func _connect_player_killed_signal() -> void:
	var _err = self.connect("player_killed", Global.world_node, "_on_player_killed")


func _on_VisibilityNotifier2D_viewport_entered(_viewport: Viewport) -> void:
	can_damage = not can_damage
