extends Label

func _ready() -> void:
	$FadeFeed.start(0)


func _on_FadeFeed_timeout() -> void:
	self.queue_free()
