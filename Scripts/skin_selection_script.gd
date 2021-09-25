extends Control

const HOVER_VOLUME: float = -3.5

var anim: AnimationPlayer
var can_hover: bool = false
var bullet_texture_path: String


func _ready() -> void:
	can_hover = true


func _on_Player1_mouse_entered() -> void:
	if can_hover:
		anim = self.get_node("MarginContainer4/Player1/AnimationPlayer")
		anim.play("HoverP1")
		_generate_hover_sound(self.get_node("MarginContainer4/Player1").position)


func _on_Player1_mouse_exited() -> void:
	if can_hover:
		anim.play_backwards("HoverP1")


func _on_Player1_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	bullet_texture_path = _get_bullet_texture_path(self.get_node("MarginContainer4/Player1").name)
	_update_player(event, self.get_node("MarginContainer4/Player1/Sprite").texture, bullet_texture_path)


func _on_Player2_mouse_entered() -> void:
	if can_hover:
		anim = self.get_node("MarginContainer4/Player2/AnimationPlayer2")
		_generate_hover_sound(self.get_node("MarginContainer4/Player2").position)
		anim.play("HoverP2")


func _on_Player2_mouse_exited() -> void:
	if can_hover:
		anim.play_backwards("HoverP2")


func _on_Player2_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	bullet_texture_path = _get_bullet_texture_path(self.get_node("MarginContainer4/Player2").name)
	_update_player(event, self.get_node("MarginContainer4/Player2/Sprite").texture, bullet_texture_path)


func _on_Player3_mouse_entered() -> void:
	if can_hover:
		anim = self.get_node("MarginContainer4/Player3/AnimationPlayer3")
		_generate_hover_sound(self.get_node("MarginContainer4/Player3").position)
		anim.play("HoverP3")


func _on_Player3_mouse_exited() -> void:
	if can_hover:
		anim.play_backwards("HoverP3")


func _on_Player3_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	bullet_texture_path = _get_bullet_texture_path(self.get_node("MarginContainer4/Player3").name)
	_update_player(event, self.get_node("MarginContainer4/Player3/Sprite").texture, bullet_texture_path)


func _on_Player4_mouse_entered() -> void:
	if can_hover:
		anim = self.get_node("MarginContainer4/Player4/AnimationPlayer4")
		_generate_hover_sound(self.get_node("MarginContainer4/Player4").position)
		anim.play("HoverP4")


func _on_Player4_mouse_exited() -> void:
	if can_hover:
		anim.play_backwards("HoverP4")


func _on_Player4_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	bullet_texture_path = _get_bullet_texture_path(self.get_node("MarginContainer4/Player4").name)
	_update_player(event, self.get_node("MarginContainer4/Player4/Sprite").texture, bullet_texture_path)


func _on_Player5_mouse_entered() -> void:
	if can_hover:
		anim = self.get_node("MarginContainer4/Player5/AnimationPlayer5")
		_generate_hover_sound(self.get_node("MarginContainer4/Player5").position)
		anim.play("HoverP5")


func _on_Player5_mouse_exited() -> void:
	if can_hover:
		anim.play_backwards("HoverP5")


func _on_Player5_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	bullet_texture_path = _get_bullet_texture_path(self.get_node("MarginContainer4/Player5").name)
	_update_player(event, self.get_node("MarginContainer4/Player5/Sprite").texture, bullet_texture_path)


func _on_Player6_mouse_entered() -> void:
	if can_hover:
		anim = self.get_node("MarginContainer4/Player6/AnimationPlayer6")
		_generate_hover_sound(self.get_node("MarginContainer4/Player6").position)
		anim.play("HoverP6")


func _on_Player6_mouse_exited() -> void:
	if can_hover:
		anim.play_backwards("HoverP6")


func _on_Player6_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	bullet_texture_path = _get_bullet_texture_path(self.get_node("MarginContainer4/Player6").name)
	_update_player(event, self.get_node("MarginContainer4/Player6/Sprite").texture, bullet_texture_path)


func _update_player(event: InputEvent, player_texture: Texture, bullet_texture_p: String) -> void:
	if can_hover:
		if event is InputEventMouseButton:
			if event.pressed and event.button_index == BUTTON_LEFT:
				Global.player_texture = player_texture
				Global.bullet_texture = load(bullet_texture_p)
				get_tree().change_scene("res://World.tscn")


func _get_bullet_texture_path(area_name: String) -> String:
	return "res://sprites/bullets/player_bullet/" + area_name.to_lower() + "_bullet.png"


func _generate_hover_sound(texture_position: Vector2) -> void:
	var hover_soud: AudioStreamPlayer2D = AudioStreamPlayer2D.new()

	hover_soud.stream = load("res://assets/audio/sounds/hover_sound.wav")
	hover_soud.position = texture_position
	hover_soud.volume_db = HOVER_VOLUME

	hover_soud.add_to_group("hover_sound")
	self.add_child(hover_soud)
	hover_soud.play(0)


func _on_Back_pressed() -> void:
	Global.create_click_sound($Back.rect_position)
	get_tree().change_scene("res://Scenes/GUI/MainGUI.tscn")
