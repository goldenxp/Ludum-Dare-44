extends Node

var unit = preload("res://scenes/card.tscn")

const MAX = 1
const MED = 0.5
const NIL = 0
const NEG = -1

const CARDS = [
{ "image":preload("res://images/cafelatte.svg"), "effect" : [ MAX, MED, NIL, NEG ] },
{ "image":preload("res://images/cafelatte.svg"), "effect" : [ MAX, MED, NIL, NEG ] }
]

const CAPTIONS = [
{ "text":"KEY_CAPTION1", "effect" : [ MED, MED, NIL, NIL ] },

]

func _ready():

	pass
	
func DrawCard():
	var inst = unit.instance()
	inst.get_node("Image").set_texture(CARDS[0]["image"])
	return inst