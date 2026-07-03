extends Control

@export_file("*.json") var d_file
signal dialogue_finished

var dialogue = []
var current_dialogue_id = 0
var d_active = false

func _ready():
	$NinePatchRect.visible = false
	# ให้ input ทะลุผ่านตอนซ่อนอยู่
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _start():
	print("Dialogue _start() called, d_active=", d_active)
	if d_active:
		return
	d_active = true
	$NinePatchRect.visible = true
	# รับ input ตอนแสดง
	mouse_filter = Control.MOUSE_FILTER_STOP
	dialogue = load_dialogue()
	print("dialogue loaded: ", dialogue)
	current_dialogue_id = -1
	next_script()

func load_dialogue():
	var file = FileAccess.open("res://dialogue/woker_dialogue1.json", FileAccess.READ)
	var content = JSON.parse_string(file.get_as_text())
	return content

func _input(event):
	# รับ input เฉพาะตอน dialogue เปิดอยู่เท่านั้น
	if !d_active:
		return
	if event.is_action_pressed("ui_accept"):
		get_viewport().set_input_as_handled()  # กัน input ไม่ให้ส่งต่อไป player
		next_script()

func next_script():
	current_dialogue_id += 1
	if current_dialogue_id >= len(dialogue):
		d_active = false
		$NinePatchRect.visible = false
		# คืน input ให้ player
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		emit_signal("dialogue_finished")
		return

	$NinePatchRect/Name.text = dialogue[current_dialogue_id]['name']
	$NinePatchRect/Text.text = dialogue[current_dialogue_id]['text']
