extends Node2D

func _ready():
	get_tree().connect("screen_resized",self,"Resize")
	Resize()
	pass
	
func _process(delta):
	pass

func Resize():
	var width = OS.get_window_size().x
	var height = OS.get_window_size().y
	# Ensure we can see the playing field
	var zoom = max(800/height, 500/width)
	get_node("Camera2D").make_current()
	get_node("Camera2D").set_zoom(Vector2(zoom,zoom))
	# Adjust the HUD
	# get_node("HUD/Panel").set_re
	pass

func Start():
	var node = Deck.DrawCard()
	get_node("Table").add_child(node)
	
	pass