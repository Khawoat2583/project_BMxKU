extends TextureRect

signal session_finished(results: Dictionary)
signal result_registered(result: String)  # ← เพิ่ม

@export var duration: float = 1.0
@export var session_duration: float = 10.0
@onready var indicator: TextureRect = $Indicator

var xEndPosition: float
var bonusRangeX = Vector2(25, 41)
var fastRangeX = Vector2(93, 124)
var time_left: float = 0.0
var session_active: bool = false
var results := {"bonus": 0, "success": 0, "normal": 0, "fail": 0}

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	xEndPosition = global_position.x - indicator.size.x / 2

func start_session() -> void:
	time_left = session_duration
	session_active = true
	results = {"bonus": 0, "success": 0, "normal": 0, "fail": 0}
	_reset_indicator()

func _reset_indicator() -> void:
	var endCenterOffSet = Vector2(size.x, size.y / 2)
	var indicatorCenterOffset = indicator.size / 2
	indicator.global_position = global_position + endCenterOffSet - indicatorCenterOffset

func _process(delta: float) -> void:
	if not session_active:
		return

	time_left -= delta
	if time_left <= 0.0:
		_end_session()
		return

	indicator.global_position.x -= size.x / duration * delta
	if indicator.global_position.x < xEndPosition:
		_register_result("normal")
		_reset_indicator()

func _input(_event: InputEvent) -> void:
	if not session_active:
		return
	if Input.is_action_just_pressed("quicktime"):
		var inBonusRange = _in_range(bonusRangeX)
		var inFastRange = _in_range(fastRangeX)
		if inBonusRange:
			_register_result("bonus")
		elif inFastRange:
			_register_result("success")
		else:
			_register_result("fail")
		_reset_indicator()

func _register_result(result: String) -> void:
	results[result] += 1
	result_registered.emit(result)  # ← เพิ่ม

func _end_session() -> void:
	session_active = false
	session_finished.emit(results)

func _in_range(eventRange: Vector2):
	var indicatorPosition = indicator.global_position.x + indicator.size.x / 2 - global_position.x
	return indicatorPosition >= eventRange.x and indicatorPosition <= eventRange.y
