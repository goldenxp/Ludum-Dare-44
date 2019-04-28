extends Node2D

var windowWidth
var windowHeight
var scoreLimit = 8
var scores = [0, 0, 0, 0]
var scoreDelta = [0, 0, 0, 0]
var nodeCard
var numNodeCards = 0
var captionIndex = 0
var captions = []

func _ready():
	get_tree().connect("screen_resized",self,"Resize")
	Resize()
	
	get_node("HUD/Controls").show()
	get_node("HUD/Controls/Button_Prev").connect("pressed",self,"SelectPrevCaption")
	get_node("HUD/Controls/Button_Next").connect("pressed",self,"SelectNextCaption")
	get_node("HUD/Controls/Button_Upload").connect("pressed",self,"Upload")
	
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
	var defeat = false
	var defeatedChannel = 0
	
	# Calculate score
	var scoreFromCaption = captions[captionIndex]["effect"]
	for i in range(scores.size()):
		scores[i] += scoreDelta[i]
		scores[i] += scoreFromCaption[i]
		if (abs(scores[i]) >= scoreLimit):
			defeat = true
			defeatedChannel = i
		
	# Clear delta
	scoreDelta = [0, 0, 0, 0]
	
	var offScreenPos = Vector2(
		rand_range(-windowWidth, windowWidth), 
		-windowHeight*2)
	Deck.TossCard(nodeCard,offScreenPos,rand_range(-1080,1080))
	
	if (defeat):
		TriggerDefeat(defeatedChannel)
	else:
		DrawNewCard()
	
	pass

func TriggerDefeat(channel):
	get_node("HUD/Controls").hide()
	# Did we go over or under
	var direction = scores[channel] > 0
	nodeCard = Deck.DrawGameOverCard(channel, direction)
	get_node("Table").add_child(nodeCard)
	
	UpdateUIChannels()
	pass

func DrawNewCard():
	get_node("HUD/Controls").show()
	
	# Pick next card based on current score
	var index = Deck.PickCard(scores)
	# How this card will affect the score
	scoreDelta = Deck.GetScoreFromCard(index)
	# Add card to the table
	nodeCard = Deck.DrawCard(index)
	get_node("Table").add_child(nodeCard)
	# Track cards
	numNodeCards += 1
	# Stack cards properly
	nodeCard.z_index = -1 * numNodeCards 
	# Get captions for the card and set index to the first
	captions = Deck.GetCaptionsForCard(index, nodeCard)
	captionIndex = 0
	
	UpdateUIChannels()
	pass
	
func UpdateUIChannels():
	var worth = 0; 
	
	for i in range(scores.size()):
		# update worth
		randomize()
		worth += max(0, scores[i]) * (1000 + randi() % 2000)
		# Shift score based on limit
		var score = float(scores[i] / scoreLimit)
		score = (1 + score) * 0.5
		var scale = Vector2(1, score)
		var node = get_node("Channels/Container"+String(i+1)+"/Channel")
		node.rect_scale = scale
	
	get_node("HUD/Container/Money").set_text("$ "+ String(worth))
	
	
	pass
	