extends Node

var gold: int = 0
var exp: int = 0

signal gold_changed(new_amount: int)
signal exp_changed(new_amount: int)

func add_gold(amount: int) -> void:
	gold += amount
	emit_signal("gold_changed", gold)
	print("Gold: ", gold)

func add_exp(amount: int) -> void:
	exp += amount
	emit_signal("exp_changed", exp)
	print("EXP: ", exp)

func give_quest_reward(quest: Quest, multiplier: float = 1.0) -> void:
	var gold_reward = int(quest.reward_gold * multiplier)
	var exp_reward = int(quest.reward_exp * multiplier)
	add_gold(gold_reward)
	add_exp(exp_reward)
	print("Quest reward: Gold +%d, EXP +%d (x%.1f)" % [gold_reward, exp_reward, multiplier])
