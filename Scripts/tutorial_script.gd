extends Control


func _on_Back_pressed() -> void:
	Global.create_click_sound($Back.rect_position)
	get_tree().change_scene("res://Scenes/GUI/MainGUI.tscn")
