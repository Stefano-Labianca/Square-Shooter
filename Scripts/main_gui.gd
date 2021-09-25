extends Control


func _on_Play_pressed() -> void:
	Global.create_click_sound($Play.rect_position)
	get_tree().change_scene("res://Scenes/GUI/Skin.tscn")


func _on_Tutorial_pressed() -> void:
	Global.create_click_sound($Tutorial.rect_position)
	get_tree().change_scene("res://Scenes/GUI/Tutorial.tscn")


func _on_Quit_pressed() -> void:
	Global.create_click_sound($Quit.rect_position)
	get_tree().quit()
