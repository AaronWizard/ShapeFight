extends ActorAction

class_name AttackAction

signal _all_tweens_completed

const STRIKE_TIME := 0.08
const STRIKE_TRANS_TYPE := Tween.TRANS_BACK
const STRIKE_EASE_TYPE := Tween.EASE_IN
const STRIKE_OFFSET := 0.75

const STRIKE_RECOIL_TIME := 0.06
const STRIKE_RECOIL_TRANS_TYPE := Tween.TRANS_BACK
const STRIKE_RECOIL_EASE_TYPE := Tween.EASE_OUT

const BUMP_TIME := 0.06
const BUMP_TRANS_TYPE := Tween.TRANS_BACK
const BUMP_EASE_TYPE := Tween.EASE_OUT
const BUMP_OFFSET := 0.25

const BUMP_BACK_TIME := 0.08
const BUMP_BACK_TRANS_TYPE := Tween.TRANS_ELASTIC
const BUMP_BACK_EASE_TYPE := Tween.EASE_OUT

onready var tween := $Tween as Tween

var target: Actor

var _running_tween_count: int

func run() -> void:
	assert(target.is_adjacent(actor))

	var dir := target.cell_position
	# Centre of actor
	dir += Vector2(1, 1) * ((target.cell_diameter / 2.0) - 0.5)
	dir -= actor.cell_position

	var strike_offset := dir * STRIKE_OFFSET
	var bump_offset = dir.normalized() * BUMP_OFFSET

	#warning-ignore:return_value_discarded
	tween.interpolate_property( \
			actor, 'cell_offset', Vector2(), strike_offset, \
			STRIKE_TIME, STRIKE_TRANS_TYPE, STRIKE_EASE_TYPE)
	#warning-ignore:return_value_discarded
	tween.start()
	yield(tween, 'tween_completed')

	actor.stats.do_attack(target.stats)

	# Queuing multiple tweens
	_running_tween_count = 0

	#warning-ignore:return_value_discarded
	tween.interpolate_property( \
			actor, 'cell_offset', strike_offset, Vector2(), \
			STRIKE_RECOIL_TIME, STRIKE_RECOIL_TRANS_TYPE, \
			STRIKE_RECOIL_EASE_TYPE)
	_running_tween_count += 1

	#warning-ignore:return_value_discarded
	tween.interpolate_property( \
			target, 'cell_offset', Vector2(), bump_offset, \
			BUMP_TIME, BUMP_TRANS_TYPE, BUMP_EASE_TYPE)
	_running_tween_count += 1

	if target.stats.is_alive:
		#warning-ignore:return_value_discarded
		tween.interpolate_property( \
				target, 'cell_offset', bump_offset, Vector2(), \
				BUMP_BACK_TIME, BUMP_BACK_TRANS_TYPE, BUMP_BACK_EASE_TYPE, \
				BUMP_TIME)
		_running_tween_count += 1

	#warning-ignore:return_value_discarded
	tween.start()
	yield(self, '_all_tweens_completed')

	actor.cell_offset = Vector2()

	if target.stats.is_alive:
		target.cell_offset = Vector2()
	else:
		target.die()

	emit_signal('finished')

#warning-ignore:unused_argument
#warning-ignore:unused_argument
func _on_tween_completed(object: Object, key: NodePath) -> void:
	_running_tween_count -= 1
	if _running_tween_count == 0:
		emit_signal('_all_tweens_completed')