extends Node

class_name Stats

signal took_damage(damage)

export var stamina := 1
export var attack := 1

#warning-ignore:unused_class_variable
var is_alive: bool setget , get_is_alive

func get_is_alive() -> bool:
	return stamina > 0

func do_attack(target: Stats) -> void:
	target.take_damage(attack)

func take_damage(damge: int) -> void:
	stamina -= damge
	emit_signal('took_damage', damge)