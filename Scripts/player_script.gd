extends KinematicBody2D

export var player_speed: int = 650

const GUN_VOLUME: float = -8.5

var Bullet = preload("res://Scenes/Bullet.tscn")
var SparkParticles = preload("res://particles/Spark.tscn")
var can_shoot: bool = true
var screen_size

func _ready() -> void:
	Global.player = self
	self.get_node("Sprite").texture = Global.player_texture
	screen_size = get_viewport_rect().size


func _physics_process(_delta: float) -> void:
	_player_movement()


# Move the player
func _player_movement() -> void:
	var motion: Vector2 = Vector2()

	if Input.is_action_pressed("up"):
		motion.y -= 1

	if Input.is_action_pressed("down"):
		motion.y += 1

	if Input.is_action_pressed("right"):
		motion.x += 1

	if Input.is_action_pressed("left"):
		motion.x -= 1

	motion = motion.normalized()
	motion = move_and_slide(motion * player_speed)

	self.position.x = clamp(self.position.x, 0, screen_size.x)
	self.position.y = clamp(self.position.y, 0, screen_size.y)

	look_at(get_global_mouse_position()) # Il giocatore punta verso il mouse

	if Input.is_action_pressed("fire") and can_shoot:
		_fire()
		$Reload.start()
		can_shoot = false


# Give the possibility to shoot a bullet
func _fire() -> void:
	var bullet: RigidBody2D = _create_bullet()
	var spark: Particles2D = _create_spark()
	var audio: AudioStreamPlayer2D = _create_shoot_audio()
	var life_timer: Timer = _create_spark_life_timer(audio, spark)

	get_tree().get_root().call_deferred("add_child", bullet, true)
	get_tree().get_root().call_deferred("add_child", spark, true)
	spark.emitting = true

	get_tree().get_root().call_deferred("add_child", audio, true)
	audio.play(0)
	audio.add_child(life_timer, true)


# Return an instance of the player's bullet.
func _create_bullet() -> RigidBody2D:
	var bullet_instance: RigidBody2D = Bullet.instance()

	bullet_instance.position = $Muzzle.get_global_position()
	bullet_instance.rotation_degrees = self.rotation_degrees
	bullet_instance.apply_impulse(Vector2(), Vector2(bullet_instance.bullet_speed, 0).rotated(self.rotation))

	return bullet_instance


func _create_spark() -> Particles2D:
	var spark_particles_instance: Particles2D = SparkParticles.instance()

	# Creazione delle particelle
	spark_particles_instance.position = $Muzzle.get_global_position()
	spark_particles_instance.rotation_degrees = self.rotation_degrees

	return spark_particles_instance


func _create_shoot_audio():
	var shoot_audio: AudioStreamPlayer2D = AudioStreamPlayer2D.new()

	shoot_audio.stream = load("res://assets/audio/sounds/player_shoot.wav")
	shoot_audio.volume_db = GUN_VOLUME
	shoot_audio.position = $Muzzle.get_global_position()
	shoot_audio.name = "ShootAudio"

	return shoot_audio


# Reloading timeout
func _on_Reload_timeout() -> void:
	can_shoot = true


# Return a life timer, of 3 seconds, for the [spark] and for the [audio] of the gun.
# - [audio: AudioStreamPlayer2D] - The shoot audio.
# - [spark: Particles2D] - The visual effect of the shoot.
func _create_spark_life_timer(audio: AudioStreamPlayer2D, spark: Particles2D) -> Timer:
	var life_timer: Timer = Timer.new()

	life_timer.wait_time = 3
	life_timer.autostart = true
	life_timer.connect("timeout", Global, "_clean_particles_and_sounds_on_timeout", [audio, spark])

	return life_timer
