extends Node

class_name Stats

export var stamina := 1
export var attack := 1

var is_alive: bool setget , get_is_alive

func get_is_alive() -> bool:
	return stamina > 0

static func do_attack(attacker: Stats, target: Stats) -> void:
	target.stamina -= attacker.attack