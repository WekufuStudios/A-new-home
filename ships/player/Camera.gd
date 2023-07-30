extends Camera2D

var zoom_tween: Tween = null

var zoom_out_requests: int = 0


func zoom_in() -> void:
	zoom_out_requests -= 1
	if zoom_out_requests == 0:
		zoom_tween = create_tween()
		zoom_tween.tween_property(self, "zoom", Vector2(1, 1), 0.8).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)


func zoom_out() -> void:
	if zoom_out_requests == 0:
		zoom_tween = create_tween()
		zoom_tween.tween_property(self, "zoom", Vector2(0.35, 0.35), 0.8).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	zoom_out_requests += 1

