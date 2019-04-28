extends Node

var unit = preload("res://scenes/card.tscn")

const MAX = 1
const MED = 0.5
const NIL = 0
const NEG = -1

const EFFECT1 = [ MAX, MED, NIL, NEG ]
const EFFECT2 = [ NEG, MAX, MED, NIL ]
const EFFECT3 = [ NIL, NEG, MAX, MED ]
const EFFECT4 = [ MED, NIL, NEG, MAX ] 

# Photos that are uploaded
const CARDS = [
{ "image":preload("res://images/cafelatte.svg"), "effect":EFFECT1, "mod-tags":["coffee"] },
{ "image":preload("res://images/trashybeach.svg"), "effect":EFFECT2, "mod-tags":[] },
{ "image":preload("res://images/finger.svg"), "effect":EFFECT3, "mod-tags":[] },
{ "image":preload("res://images/dance.svg"), "effect":EFFECT4, "mod-tags":["expression"] },

]

# How the Pandering happens 
const MODS_GENERIC = [
{ "caption": "Hashtag Blessed", "effect":EFFECT1},
{ "caption": "Things were better in the past", "effect":EFFECT2 },
{ "caption": "Am I doing Social Media right, ahyuk?", "effect":EFFECT3 },
{ "caption": "Shoutout to my peeps", "effect":EFFECT4},
]

# Pandering for specific content as defined by mod-tags
const MODS_SPECIFIC = {
	"coffee": [ { "caption":"Beans from Ethiopia!", "effect":EFFECT1 }  ],
	"expression": [ { "caption":"I feel most alive with art", "effect":EFFECT4 }  ]
}

func _ready():

	pass

func PickCard(scores):
	var index = 0
	
	var channelToTarget = 0
	for i in range(scores.size()):
		if (scores[i] > scores[channelToTarget]):
			channelToTarget = i
		
	for i in range(CARDS.size()):
		var effect = CARDS[i]["effect"]
		var intention = effect[channelToTarget]
		if (intention == MAX):
			index = i
			break
	
	return index

func TossCard(nodeCard, offScreenPos):
	var tween = nodeCard.get_node("Tween")
	tween.remove_all()
	tween.interpolate_property(nodeCard,"global_position",
			nodeCard.get_global_position(),offScreenPos,
			1,Tween.TRANS_QUAD,Tween.EASE_OUT)
	tween.interpolate_property(nodeCard,"rotation_degrees",
			nodeCard.rotation_degrees,
			rand_range(-1080,1080),
			1, Tween.TRANS_QUAD, Tween.EASE_IN)
	tween.start()
	pass

func DrawCard(index):
	var inst = unit.instance()
	
	inst.get_node("Image").set_texture(CARDS[index]["image"])
	
	return inst
	
func GetCaptionsForCard(index, nodeCard):
	var captions = []
	
	for i in range(MODS_GENERIC.size()):
		captions.append(MODS_GENERIC[i])
	
	var tags = CARDS[index]["mod-tags"]
	for i in range(tags.size()):
		var extraCaptions = MODS_SPECIFIC[tags[i]]
		for j in range(extraCaptions.size()):
			captions.append(extraCaptions[j])
	
	UpdateCardCaption(captions[0], nodeCard)
	
	return captions
	
func UpdateCardCaption(caption, nodeCard):
	nodeCard.get_node("Caption").set_text(caption["caption"])
	
func GetScoreFromCard(index):
	return CARDS[index]["effect"]
	