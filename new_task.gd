extends Control


var app: Control
@onready var title := $Margin/Pane/Body/Title
@onready var description := $Margin/Pane/Body/Description


func setup(new_app: Control):
	app = new_app
	title.grab_focus()


func _on_AddTaskBtn_pressed() -> void:
	if title.text == "":
		var new_style := StyleBoxFlat.new()
		new_style.bg_color = Color("#802000", 0.25)
		title.add_theme_stylebox_override("focus", new_style)
		title.placeholder_text = "Task must have a title..."
		title.grab_focus()
		return
		
	if description.text == "":
		description.text = "No description."
	
	var task := {
		"title": title.text,
		"description": description.text,
	}
	
	app.new_task(task)
	queue_free()


func _on_cancel_btn_pressed() -> void:
	queue_free()


func _on_title_text_submitted(new_text: String) -> void:
	description.grab_focus()
#	DisplayServer.virtual_keyboard_show("")


