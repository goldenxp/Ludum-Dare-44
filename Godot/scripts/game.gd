extends Node2D

var windowWidth
var windowHeight
var scores = [0, 0, 0, 0]
var scoreDelta = [0, 0, 0, 0]
var nodeCard
var captionIndex = 0
var captions = []

func _ready():
	get_tree().connect("screen_resized",self,"Resize")
	Resize()
	
	get_node("HUD/HBoxContainer/Button_Prev").connect("pressed",self,"SelectPrevCaption")
	get_node("HUD/HBoxContainer/Button_Next").connect("pressed",self,"SelectNextCaption")
	get_node("HUD/HBoxContainer/Button_Upload").connect("pressed",self,"Upload")
	
	pass
	
func _process(delta):
	pass

func Resize():
	windowWidth= OS.get_window_size().x
	windowHeight = OS.get_window_size().y
	# Ensure we can see the playing field
	var zoom = max(800/windowHeight, 500/windowWidth)
	get_node("Camera2D").make_current()
	get_node("Camera2D").set_zoom(Vector2(zoom,zoom))
	# Adjust the HUD
	# get_node("HUD/Panel").set_re
	pass

func Start():
	DrawNewCard()
	
	pass
	
func SelectPrevCaption():
	captionIndex -= 1
	if (captionIndex < 0):
		captionIndex = captions.size() - 1
	Deck.UpdateCardCaption(captions[captionIndex], nodeCard)
	pass
	
func SelectNextCaption():
	captionIndex += 1
	if (captionIndex >= captions.size()):
		captionIndex = 0
	Deck.UpdateCardCaption(captions[captionIndex], nodeCard)
	pass

func Upload():
	# Calculate score
	var scoreFromCaption = captions[captionIndex]["effect"]
	for i in range(scores.size()):
		scores[i] += scoreDelta[i]
		scores[i] += scoreFromCaption[i]
	
	var defeat = false
	# Check for defeat condition
	
	var offScreenPos = Vector2(
		rand_range(-windowWidth, windowWidth), 
		-windowHeight*2)
	Deck.TossCard(nodeCard,offScreenPos)
	
	DrawNewCard()
	
	pass
	
func DrawNewCard():
	
	# Pick next card based on current score
	var index = Deck.PickCard(scores)
	# How this card will affect the score
	scoreDelta = Deck.GetScoreFromCard(index)
	# Add card to the table
	nodeCard = Deck.DrawCard(index)
	get_node("Table").add_child(nodeCard)	
	# Get captions for the card and set index to the first
	captions = Deck.GetCaptionsForCard(index, nodeCard)
	captionIndex = 0

	pass