extends Node

const PLAYER_POSITION: Vector2 = Vector2(671, 356)
const GAME_SCENE_PATH: String = "res://World.tscn"
const LOGIN_SCENE_PATH: String = "res://World.tscn"
const DIRECTORY_SAVE_FILE: String = "user://save/"
const SAVE_FILE_PATH: String = DIRECTORY_SAVE_FILE + "save_game.dat"
const DEAD_VOLUME: float = -5.5
const CLICK_VOLUME: float = -4.0

var score_label: Label = null
var score_node = null
var player = null

var player_texture
var bullet_texture

var world_node = load("res://World.tscn").instance()
var dead_node: Control = null

var stun_texture = preload("res://sprites/stun_sprite.png")
var score_feed = preload("res://Scenes/GUI/ScoreFeed.tscn")
var screen_dimension: Vector2 = OS.window_size

var enemy_dict: Dictionary = {
	"minion": {
		"sprite": load("res://enemies/minion.png"),
		"knockback_value": 7.5,
		"lives": 2,
		"speed": 300,
		"score": 10,
		"type": 1
	},
	"gunman": {
		"sprite": load("res://enemies/gunman.png"),
		"knockback_value": 6.0,
		"lives": 3,
		"speed": 400,
		"score": 30,
		"type": 2
	},
	"bomber": {
		"sprite": load("res://enemies/bomber.png"),
		"knockback_value": 10.5,
		"lives": 1,
		"speed": 725,
		"score": 50,
		"type": 3
	},
	"armored": {
		"sprite": load("res://enemies/armored.png"),
		"knockback_value": 4.5,
		"lives": 5,
		"speed": 175,
		"score": 70,
		"type": 4
	}
}

var explosion_type: Dictionary = {
	"bomber_explosion": {
		"particles": preload("res://particles/Explosion.tscn"),
		"sound": load("res://assets/audio/sounds/bomb.wav")
	},

	"armored_explosion": {
		"particles": preload("res://particles/ExplosionBot.tscn"),
		"sound": load("res://assets/audio/sounds/bomb_bot.wav")
	}
}


func play_dead_sound(last_player_position: Vector2) -> void:
	var dead: AudioStreamPlayer2D = AudioStreamPlayer2D.new()

	dead.stream = load("res://assets/audio/sounds/dead_sound.wav")
	dead.volume_db = DEAD_VOLUME
	dead.position = last_player_position

	self.add_child(dead)
	dead.play(0)


func create_click_sound(button_position: Vector2) -> void:
	var click: AudioStreamPlayer2D = AudioStreamPlayer2D.new()

	click.stream = load("res://assets/audio/sounds/click.wav")
	click.position = button_position
	click.volume_db = CLICK_VOLUME

	self.add_child(click)
	click.play(0)


func _on_player_killed():
	print("Morto")
