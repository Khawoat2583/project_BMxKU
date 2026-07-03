extends Resource
class_name Quest

@export_category("Description")
@export var name: String
@export_multiline var description: String
@export var brief_description: String

@export_category("Status")
@export var is_completed: bool = false
@export var is_active: bool = false

@export_category("Reward")
@export var reward_gold: int = 0
@export var reward_exp: int = 0

func complete() -> void:
	is_completed = true
	is_active = false

func start() -> void:
	is_active = true

func reset() -> void:
	is_completed = false
	is_active = false
