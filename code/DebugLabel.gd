extends Label

class_name DebugLabel

func _process(delta):
	text = ""
	for line in Debug.lines():
		text = text + line + "\n"
