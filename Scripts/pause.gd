extends CanvasLayer


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"): # Vera se premuto il tasto ESC
		if is_instance_valid(Global.dead_node) and is_instance_valid(Global.world_node):
			if not Global.dead_node.visible and Global.world_node.visible:
				_set_visible(not get_tree().paused) # Imposto la visibilità della schermata di pausa a true
				get_tree().paused = not get_tree().paused


# Funzione usata per modificare la visibilità di tutti i nodi della scena 'Pause'.
# Se al paramentro 'is_visible' viene assegnato il valore false, tutti i nodi saranno
# invisibili, altrimenti se li viene assegnato true i nodi saranno visibili.
#
# @params is_visible: bool --> Modifica la visibilità dei nodi.
func _set_visible(is_visible: bool) -> void:
	for node in get_children():
		if not node.is_in_group("env"):
			node.visible = is_visible


func _on_Resum_pressed() -> void:
	_resum_game()


func _on_Quit_pressed() -> void:
	get_tree().change_scene("res://Scenes/GUI/MainGUI.tscn")
	_resum_game()


func _resum_game() -> void:
	_set_visible(false)
	get_tree().paused = false
	Global.create_click_sound($Resum.rect_position)


func _are_not_deleted() -> bool:
	var dn = weakref(Global.dead_node)
	var wn = weakref(Global.world_node)

	if not dn.get_ref() and not wn.get_ref():
		return false
	return true
