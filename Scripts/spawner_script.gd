extends Node

enum ENEMY_TYPE { MINION = 1, GUNMAN = 2, BOMBER = 3, ARMORED = 4 }
enum AREA_TYPE { AREA_ONE = 1, AREA_TWO = 2, AREA_THREE = 3, AREA_FOUR = 4 }

const SPAWN_OFFSET: int = 200
const NON_ZERO_SPAWN: int = 64

var random: RandomNumberGenerator = RandomNumberGenerator.new()
var Enemy = preload("res://Scenes/Enemy.tscn")

func _ready() -> void:
	random.randomize()


func _on_SpawnTimer_timeout() -> void:
	if Global.player != null:
		var enemy_number: int = _generate_enemy_type()
		_create_enemies(enemy_number)



# Create an enemy specified from the parameter [type].
# - [type: int] - Rappresent the enemy type.
func _create_enemies(type: int) -> void:
	var created_enemy: KinematicBody2D
	var enemy_spawn_point: Vector2

	match type:
		ENEMY_TYPE.MINION:
			enemy_spawn_point = _generate_spawn_point()
			created_enemy = _get_enemy(Global.enemy_dict["minion"], enemy_spawn_point)

		ENEMY_TYPE.GUNMAN:
			enemy_spawn_point = _generate_spawn_point()
			created_enemy = _get_enemy(Global.enemy_dict["gunman"], enemy_spawn_point)

		ENEMY_TYPE.BOMBER:
			enemy_spawn_point = _generate_spawn_point()
			created_enemy = _get_enemy(Global.enemy_dict["bomber"], enemy_spawn_point)

		ENEMY_TYPE.ARMORED:
			enemy_spawn_point = _generate_spawn_point()
			created_enemy = _get_enemy(Global.enemy_dict["armored"], enemy_spawn_point)

	self.add_child(created_enemy)


# Return the generated enemy.
# - [enemy_prop: Dictionary] - Contains all the enemies informations.
# - [enemy_position: Vector2] - Enemy's position.
func _get_enemy(enemy_prop: Dictionary, enemy_position: Vector2) -> KinematicBody2D:
	var enemy_instance: KinematicBody2D = Enemy.instance()

	enemy_instance.enemy_sprite = enemy_prop["sprite"]
	enemy_instance.enemy_knockback_value = enemy_prop["knockback_value"]
	enemy_instance.enemy_lives = enemy_prop["lives"]
	enemy_instance.enemy_speed = enemy_prop["speed"]
	enemy_instance.enemy_type = enemy_prop["type"]
	enemy_instance.enemy_score = enemy_prop["score"]
	enemy_instance.position = enemy_position

	return enemy_instance


# Return the enemy position.
func _generate_spawn_point() -> Vector2:
	var e_position: Vector2 = Vector2.ZERO

	var area: int = random.randi_range(AREA_TYPE.AREA_ONE, AREA_TYPE.AREA_FOUR)

	match area:
		AREA_TYPE.AREA_ONE:
			e_position = _spawn_area_one()
		AREA_TYPE.AREA_TWO:
			e_position = _spawn_area_two()
		AREA_TYPE.AREA_THREE:
			e_position = _spawn_area_three()
		AREA_TYPE.AREA_FOUR:
			e_position = _spawn_area_four()

	return e_position


# Left corner of the screen
func _spawn_area_one():
	var e_position: Vector2 = Vector2.ZERO

	e_position.x = random.randi_range(-SPAWN_OFFSET - NON_ZERO_SPAWN, -NON_ZERO_SPAWN) # [-264, -64]
	e_position.y = random.randi_range(-NON_ZERO_SPAWN, Global.screen_dimension.y + NON_ZERO_SPAWN) # [-64, 784]

	return e_position


# Top corner of the screen.
func _spawn_area_two():
	var e_position: Vector2 = Vector2.ZERO

	e_position.x = random.randi_range(-NON_ZERO_SPAWN, Global.screen_dimension.x + NON_ZERO_SPAWN) # [-64, 1344]
	e_position.y = random.randi_range(-SPAWN_OFFSET - NON_ZERO_SPAWN, -SPAWN_OFFSET - NON_ZERO_SPAWN) # [-264, -264]

	return e_position


# Right corner of the screen.
func _spawn_area_three():
	var e_position: Vector2 = Vector2.ZERO

	e_position.x = random.randi_range(Global.screen_dimension.x + SPAWN_OFFSET + NON_ZERO_SPAWN, Global.screen_dimension.x + SPAWN_OFFSET + NON_ZERO_SPAWN) # [1544, 1544]
	e_position.y = random.randi_range(-NON_ZERO_SPAWN, Global.screen_dimension.y + NON_ZERO_SPAWN) # [-64, 784]

	return e_position


# Button corner of the screen
func _spawn_area_four():
	var e_position: Vector2 = Vector2.ZERO

	e_position.x = random.randi_range(-NON_ZERO_SPAWN, Global.screen_dimension.x + NON_ZERO_SPAWN) # [-64, 1344]
	e_position.y = random.randi_range(Global.screen_dimension.y + NON_ZERO_SPAWN + SPAWN_OFFSET, Global.screen_dimension.y + NON_ZERO_SPAWN + SPAWN_OFFSET) # [984, 984]

	return e_position


# Generate and return a random non-negative integer number, that rappresent the enemy type.
func _generate_enemy_type() -> int:
	var enemy_type: int = 0

	enemy_type = random.randi_range(1, 6)

	if enemy_type > 1 and enemy_type <= 3:
		enemy_type -= 1

	elif enemy_type > 3 and enemy_type <= 6:
		enemy_type -= 2

	return enemy_type
