extends Control
class_name App

const SAVE_FILE_PATH := "user://save_file.json"

const SIDE_MENU_PATH := "res://side_menu.tscn"
const NEW_TASK_PATH := "res://new_task.tscn"
const TASK_ELEMENT_PATH := "res://task_element.tscn"

@onready var todo_list := $Body/Scroll/TaskList/TodoList
@onready var done_list := $Body/Scroll/TaskList/DoneList

var save_data: Dictionary = {
	"file": SAVE_FILE_PATH,
	"version": 3,
	"tasks": [],
	"done": []
}

func _ready():
	load_data()


func load_data():
	if not FileAccess.file_exists(SAVE_FILE_PATH):
		return
		
	var raw_save_file := FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	print("raw save file: ", raw_save_file.get_as_text())
	
	var parsed_save_file: Dictionary = JSON.parse_string(raw_save_file.get_as_text())
	print("parsed save file: ")
	
	if not parsed_save_file.has("version"):
		print("no version, overwriting file..")
		save()
		parsed_save_file = JSON.parse_string(raw_save_file.get_as_text())
	if parsed_save_file["version"] != save_data["version"]:
		print("version is wronk, overwriting file..")
		save()
		parsed_save_file = JSON.parse_string(raw_save_file.get_as_text())
	
	save_data = parsed_save_file
	print("runtime save data updated: ", save_data)
	
	for element in save_data["tasks"]:
		spawn_task(element)
		


func save() -> void:
	var data: String = JSON.stringify(save_data)
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	file.store_string(data)
	


func spawn_task(task: Dictionary) -> void:
	var task_element = preload(TASK_ELEMENT_PATH).instantiate()
	todo_list.add_child(task_element)
	task_element.setup(self, task)


func new_task(task: Dictionary) -> void:
	var data_index = save_data["tasks"].size()
	task["index"] = data_index
	save_data["tasks"].append(task)
	print("new task being made at index ", data_index, ":", task)
	spawn_task(task)
	save()


func complete_task(task_node: PanelContainer) -> void:
	var task: Dictionary = task_node.task
	save_data["tasks"].remove_at(task["index"])
	task["index"] = save_data["done"].size()
	save_data["done"].append(task)
	todo_list.remove_child(task_node)
	done_list.add_child(task_node)


func _on_new_task_button_pressed() -> void:
	var newtask: Control = preload(NEW_TASK_PATH).instantiate()
	add_child(newtask)
	newtask.setup(self)


func _on_side_menu_button_pressed() -> void:
	var side_menu: Control = preload(SIDE_MENU_PATH).instantiate()
	add_child(side_menu)
