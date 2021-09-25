extends KinematicBody2D

signal player_killed

const WEIGHT: float = 0.55
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
		if enemy_type == 3: # Check if the enemy is the 'bomber'
			_instantiate_enemy_dead("bomber_explosion")

		Global.play_dead_sound(body.position)

		self.queue_free() # Enemy disappears
		body.queue_free() # Kill the player
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
					_instantiate_enemy_dead("bomber_explosion")

				if enemy_type == 4:  # Check if the enemy is the 'armored'
					_instantiate_enemy_dead("armored_explosion")

				Global.score_node.callv("update_score", [enemy_score])
				_show_score_feed()
				self.queue_free()

			_play_hit_sound()
			$StunTimer.start()
			$Sprite.texture = Global.stun_texture


# Show the explosion for the enemy type 'bomber' or 'armored'
func _get_explosion(explosion_type: String) -> Particles2D:
	var ExplosionParticles = Global.explosion_type[explosion_type].particles
	var explosion_particles_instance = ExplosionParticles.instance()
	explosion_particles_instance.position = self.position


	return explosion_particles_instance


func _get_explosion_sound(explosion_type: String) -> AudioStreamPlayer2D:
	var explosion_audio = AudioStreamPlayer2D.new()

	explosion_audio.stream = Global.explosion_type[explosion_type].sound
	explosion_audio.position = self.position
	explosion_audio.volume_db = Global.explosion_type[explosion_type].volume

	return explosion_audio


func _play_hit_sound() -> void:
	var hit_sound = AudioStreamPlayer2D.new()

	hit_sound.stream = load("res://assets/audio/sounds/hit.wav")
	hit_sound.position = self.position
	hit_sound.volume_db = HIT_VOLUME

	var timer: Timer = _create_hit_life_timer(hit_sound)
	hit_sound.add_child(timer, true)

	get_tree().get_root().call_deferred("add_child", hit_sound, true)
	hit_sound.play(0)


# Return a life timer, of 3 seconds, for the [audio] of the enemy's hit.
# - [audio: AudioStreamPlayer2D] - The hit audio.
func _create_hit_life_timer(audio: AudioStreamPlayer2D) -> Timer:
	var life_timer: Timer = Timer.new()

	life_timer.wait_time = 3
	life_timer.autostart = true
	life_timer.connect("timeout", Global, "_clean_sounds_on_timeout", [audio])

	return life_timer


func _show_score_feed() -> void:
	var score_feed: Label = Global.score_feed.instance()
	score_feed.text = "+" + str(enemy_score)
	score_feed.rect_position = self.position

	get_tree().get_root().call_deferred("add_child", score_feed, true)


# Called when the enemy is no more stunned.
func _on_StunTimer_timeout() -> void:
	is_stun = false
	$Sprite.texture = enemy_sprite


# Return a life timer, of 3 seconds, for the [audio] of the explosion.
# - [audio: AudioStreamPlayer2D] - The explosion audio.
# - [particle: Particles2D] - The visual effect of the explosion.
func _create_explosion_life_timer(audio: AudioStreamPlayer2D) -> Timer:
	var life_timer: Timer = Timer.new()

	life_timer.wait_time = 3
	life_timer.autostart = true
	life_timer.connect("timeout", Global, "_clean_sounds_on_timeout", [audio])

	return life_timer

# Insert the explosion particle and the explosion sound of the enemy.
# - [explosion_type: String] - The tyoe of the explosion to show in the scene.
func _instantiate_enemy_dead(explosion_type: String) -> void:
	var explosion_particle: Particles2D = _get_explosion(explosion_type)
	var explosion_sound: AudioStreamPlayer2D = _get_explosion_sound(explosion_type)
	var timer: Timer = _create_explosion_life_timer(explosion_sound)

	get_tree().get_root().call_deferred("add_child", explosion_particle, true)
	explosion_particle.emitting = true

	get_tree().get_root().call_deferred("add_child", explosion_sound, true)
	explosion_sound.play(0)

	explosion_sound.add_child(timer, true)


func _connect_player_killed_signal() -> void:
	var _err = self.connect("player_killed", Global.world_node, "_on_player_killed")


func _on_VisibilityNotifier2D_viewport_entered(_viewport: Viewport) -> void:
	can_damage = not can_damage
