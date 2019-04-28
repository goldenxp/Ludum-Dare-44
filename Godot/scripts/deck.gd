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

const MIN_EFFECT1 = [ MED, NIL, NIL, NIL ]
const MIN_EFFECT2 = [ NIL, MED, NIL, NIL ]
const MIN_EFFECT3 = [ NIL, NIL, MED, NIL ]
const MIN_EFFECT4 = [ NIL, NIL, NIL, MED ]

const BOOST_EFFECT1 = [ MAX, NIL, NIL, NIL ]
const BOOST_EFFECT2 = [ NIL, MAX, NIL, NIL ]
const BOOST_EFFECT3 = [ NIL, NIL, MAX, NIL ]
const BOOST_EFFECT4 = [ NIL, NIL, NIL, MAX ]

# Photos that are uploaded
const CARDS = [
{ "image":preload("res://images/cafelatte.svg"), "effect":EFFECT1, "mod-tags":["coffee"] },
{ "image":preload("res://images/trashybeach.svg"), "effect":EFFECT2, "mod-tags":[] },
{ "image":preload("res://images/finger.svg"), "effect":EFFECT3, "mod-tags":[] },
{ "image":preload("res://images/yoga.svg"), "effect":EFFECT1, "mod-tags":[] },
{ "image":preload("res://images/dance.svg"), "effect":EFFECT4, "mod-tags":["expression"] },
{ "image":preload("res://images/supervillain.svg"), "effect":EFFECT3, "mod-tags":["comics"] },

]

const CARDS_FAIL_OVER = [
{ "image":preload("res://images/failover_default.svg"), "caption":"You're too popular with the wrong crowd. We're shutting you down."}
]

const CARDS_FAIL_UNDER = [
{ "image":preload("res://images/failunder_default.svg"), "caption":"Your life is too boring. We're cutting your monetization."}
]

# How the Pandering happens 
const MODS_GENERIC = [
{ "caption": "Hashtag Blessed", "effect":MIN_EFFECT1},
{ "caption": "Things were better in the past", "effect":MIN_EFFECT2 },
{ "caption": "Am I doing Social Media right, ahyuk?", "effect":MIN_EFFECT3 },
{ "caption": "Shoutout to my peeps", "effect":MIN_EFFECT4},
]

# Pandering for specific content as defined by mod-tags
const MODS_SPECIFIC = {
	"coffee": [ { "caption":"Beans from Ethiopia!", "effect":BOOST_EFFECT1 }  ],
	"expression": [ { "caption":"I feel most alive with art", "effect":BOOST_EFFECT4 } ],
	"comics": [ { "caption":"Nerds are now cool", "effect":BOOST_EFFECT3 } ]
}

func _ready():

	pass

func PickCard(scores):
	var index = 0
	randomize()
	var channelToTarget = randi() % 4
	var pool = []
	
	for i in range(CARDS.size()):
		var effect = CARDS[i]["effect"]
		var intention = effect[channelToTarget]
		if (intention == MAX):
			pool.append(i)
	
	randomize()
	index = pool[randi() % pool.size()]
	
	return index

func TossCard(nodeCard, offScreenPos, rotation):
	var tween = nodeCard.get_node("Tween")
	tween.remove_all()
	tween.interpolate_property(nodeCard,"global_position",
			nodeCard.get_global_position(),offScreenPos,
			1,Tween.TRANS_QUAD,Tween.EASE_OUT)
	tween.interpolate_property(nodeCard,"rotation_degrees",
			nodeCard.rotation_degrees,
			rotation,
			1, Tween.TRANS_QUAD, Tween.EASE_IN)
	tween.start()
	pass

func DrawCard(index):
	var inst = unit.instance()
	
	inst.get_node("Image").set_texture(CARDS[index]["image"])
	
	return inst

func DrawGameOverCard(channel, direction):
	var inst = unit.instance()
	
	var card
	if direction:
		card = CARDS_FAIL_OVER[0]
	else:
		card = CARDS_FAIL_UNDER[0]
	
	inst.get_node("Image").set_texture(card["image"])
	inst.get_node("Caption").set_text(card["caption"])
	
	return inst
	
func GetCaptionsForCard(index, nodeCard):
	var captions = []
	
	for i in range(MODS_GENERIC.size()):
		captions.push_back(MODS_GENERIC[i])
	
	var tags = CARDS[index]["mod-tags"]
	for i in range(tags.size()):
		var extraCaptions = MODS_SPECIFIC[tags[i]]
		for j in range(extraCaptions.size()):
			captions.push_front(extraCaptions[j])
	
	UpdateCardCaption(captions[0], nodeCard)
	
	return captions
	
func UpdateCardCaption(caption, nodeCard):
	nodeCard.get_node("Caption").set_text(caption["caption"])
	
func GetScoreFromCard(index):
	var score = [0, 0, 0, 0]
	var effect = CARDS[index]["effect"]
	for i in range(effect.size()):
		score[i] = effect[i] 
	return score
	