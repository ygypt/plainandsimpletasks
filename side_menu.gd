extends Control


const TWEEN_SPEED: float = 0.1


@onready var pane: PanelContainer = $Pane


func _get_offscreen_position():
	return Vector2(-pane.size.x, 0)


func _slide_in() -> void:
	# move the pane off screen and animated it in from the left
	pane.position = _get_offscreen_position()
	var tween = create_tween()
	tween.tween_property(
			pane,
			"position",
			Vector2.ZERO,
			TWEEN_SPEED)


func _slide_out() -> void:
	# animate the pane off screen to the left
	var tween = create_tween()
	tween.tween_property(
			pane,
			"position",
			_get_offscreen_position(),
			TWEEN_SPEED)
	tween.tween_callback(_slide_out_callback)


func _slide_out_callback() -> void:
	queue_free()


func _ready():
	_slide_in()


func _on_background_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MASK_LEFT:
			_slide_out()
