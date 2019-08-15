extends ColorRect

signal animation_finished

func play() -> void:
	$AnimationPlayer.play("animate")

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	assert(anim_name == 'animate')
	emit_signal("animation_finished")