extends Control

@onready var event_bar: TextureRect = $EventBar
@onready var label: Label = $Label

@export var quest: Quest = null

func _ready() -> void:
	label.text = "Start"
	event_bar.session_finished.connect(_on_session_finished)
	event_bar.start_session()

func _on_session_finished(results: Dictionary) -> void:
	var bonus = results.get("bonus", 0)
	var success = results.get("success", 0)
	var normal = results.get("normal", 0)
	var fail = results.get("fail", 0)

	label.text = "Bonus: %d | Success: %d | Normal: %d | Fail: %d" % [bonus, success, normal, fail]
	print("Session results: ", results)

	_give_reward(bonus, success, normal, fail)

func _give_reward(bonus: int, success: int, normal: int, fail: int):
	if quest == null:
		print("ERROR: ยังไม่ได้ลาก Quest ใส่ Inspector")
		return

	# คำนวณ gold และ exp จากแต่ละผลลัพธ์
	var base_gold = quest.reward_gold
	var base_exp = quest.reward_exp

	var total_gold = 0
	var total_exp = 0

	total_gold += bonus  * int(base_gold * 2.0)  # bonus → x2
	total_gold += success * int(base_gold * 1.5)  # success → x1.5
	total_gold += normal  * int(base_gold * 1.0)  # normal → x1
	total_gold += fail    * int(base_gold * 0.0)  # fail → x0

	total_exp += bonus  * int(base_exp * 2.0)
	total_exp += success * int(base_exp * 1.5)
	total_exp += normal  * int(base_exp * 1.0)
	total_exp += fail    * int(base_exp * 0.0)

	print("Total Gold: +%d  Total EXP: +%d" % [total_gold, total_exp])
	label.text += "\nGold: +%d  EXP: +%d" % [total_gold, total_exp]

	GameManager.add_gold(total_gold)
	GameManager.add_exp(total_exp)
	quest.complete()
