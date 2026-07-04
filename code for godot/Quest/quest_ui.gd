extends CanvasLayer
signal quest_accepted(quest: Quest)
signal quest_declined()

@onready var panel = $QuestPanel
@onready var title_label = $QuestPanel/VBoxContainer/HBoxContainer/Title
@onready var close_btn = $QuestPanel/VBoxContainer/HBoxContainer/CloseBtn
@onready var category_label = $QuestPanel/VBoxContainer/CategoryLabel
@onready var quest_name_label = $QuestPanel/VBoxContainer/HBoxContainer2/QuestName
@onready var quest_day_label = $QuestPanel/VBoxContainer/HBoxContainer2/QuestDay
@onready var alt_label = $QuestPanel/VBoxContainer/AltLabel
@onready var accept_btn = $QuestPanel/VBoxContainer/HBoxContainer3/AcceptBtn
@onready var esc_btn = $QuestPanel/VBoxContainer/HBoxContainer3/EscBtn
var current_quest: Quest = null

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	panel.hide()
	title_label.text = "Quest"
	category_label.text = "Major"
	alt_label.text = "Alternative"
	accept_btn.text = "รับ Quest"
	esc_btn.text = "esc"
	_setup_style()

func _setup_style():
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.custom_minimum_size = Vector2(500, 350)
	var style = StyleBoxFlat.new()
	style.bg_color = Color.WHITE
	style.border_color = Color(0.4, 0.8, 0.2)
	style.set_border_width_all(6)
	style.border_width_top = 50
	style.border_width_bottom = 50
	style.set_corner_radius_all(12)
	panel.add_theme_stylebox_override("panel", style)
	title_label.add_theme_color_override("font_color", Color.WHITE)
	title_label.add_theme_font_size_override("font_size", 26)
	title_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	close_btn.add_theme_color_override("font_color", Color.WHITE)
	close_btn.flat = true
	category_label.add_theme_color_override("font_color", Color.BLACK)
	category_label.add_theme_font_size_override("font_size", 14)
	quest_name_label.add_theme_color_override("font_color", Color(0.8, 0.1, 0.1))
	quest_day_label.add_theme_color_override("font_color", Color(0.8, 0.1, 0.1))
	quest_day_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	alt_label.add_theme_color_override("font_color", Color.BLACK)
	alt_label.add_theme_font_size_override("font_size", 14)
	accept_btn.add_theme_color_override("font_color", Color.WHITE)
	var accept_style = StyleBoxFlat.new()
	accept_style.bg_color = Color(0.2, 0.6, 0.1)
	accept_style.set_corner_radius_all(8)
	accept_btn.add_theme_stylebox_override("normal", accept_style)
	accept_btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	esc_btn.add_theme_color_override("font_color", Color.WHITE)
	esc_btn.flat = true

func show_quest(quest: Quest) -> void:
	current_quest = quest
	quest_name_label.text = quest.name
	quest_day_label.text = quest.brief_description
	panel.show()
	get_tree().paused = true

func hide_quest() -> void:
	panel.hide()
	current_quest = null
	get_tree().paused = false

func _input(event):
	if not panel.visible:
		return
	if event.is_action_pressed("ui_accept"):
		get_viewport().set_input_as_handled()
		_on_accept_btn_pressed()
	if event.is_action_pressed("ui_cancel"):
		get_viewport().set_input_as_handled()
		_on_esc_btn_pressed()

func _on_accept_btn_pressed() -> void:
	if current_quest:
		print("รับ quest: ", current_quest.name)
		var quest = current_quest
		hide_quest()
		quest_accepted.emit(quest)
	else:
		hide_quest()

func _on_esc_btn_pressed() -> void:
	hide_quest()
	quest_declined.emit()

func _on_close_btn_pressed() -> void:
	_on_esc_btn_pressed()
