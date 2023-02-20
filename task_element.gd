extends PanelContainer

@onready var button: Button = $Body/Button

@onready var title: Label = $HBox/Text/Title
@onready var description: RichTextLabel = $HBox/Text/Description

var app: App
var task: Dictionary

func setup(app_ref: App, new_task: Dictionary) -> void:
	app = app_ref
	task = new_task
	title.text = task["title"]
	description.text = task["description"]

func _on_button_pressed() -> void:
	app.complete_task(self)
	pass
