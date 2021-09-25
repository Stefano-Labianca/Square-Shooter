extends Node2D

var Player = preload("res://Scenes/Player.tscn")
var score_label_node: Label
var enemies: Array


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_pressed() and event.is_action_pressed("restart") and Global.dead_node.visible:
			_restart_game()


func _restart_game() -> void:
	var player_node = Player.instance()

	score_label_node = self.get_node("ScoreSystem/ScoreLabel")
	player_node.position = Global.PLAYER_POSITION
	score_label_node.text = "SCORE: 0"

	Global.dead_node.visible = false
	_clean_scene_from_enemy()

	self.add_child(player_node, true)


func _on_player_killed() -> void:
	$EnemySpawner/SpawnTimer.stop()
	Global.dead_node.visible = true


func _clean_scene_from_enemy() -> void:
	enemies = get_tree().get_nodes_in_group("enemy")

	for enemy in enemies:
		enemy.queue_free()

