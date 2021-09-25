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


# MOve the player
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
	var bullet_instance: RigidBody2D = Bullet.instance()

	# Creazione proiettile
	bullet_instance.position = $Muzzle.get_global_position()
	bullet_instance.rotation_degrees = self.rotation_degrees
	bullet_instance.apply_impulse(Vector2(), Vector2(bullet_instance.bullet_speed, 0).rotated(self.rotation))

	var spark: Particles2D = _create_spark()
	var audio: AudioStreamPlayer2D = _create_shoot_audio()

	# Inserisco il proiettile nella scena
	get_tree().get_root().call_deferred("add_child", bullet_instance, true)

	# Inserisco le particelle nella scena
	get_tree().get_root().call_deferred("add_child", spark, true)
	spark.emitting = true

	# Inserisco l'audio della particella dello sparo nella scena
	get_tree().get_root().call_deferred("add_child", audio, true)
	audio.play(0)


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

	return shoot_audio


# Reloadin timeout
func _on_Reload_timeout() -> void:
	can_shoot = true
