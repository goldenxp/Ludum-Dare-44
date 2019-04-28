extends CanvasLayer

# class member variables go here, for example:
# Constants
const LOCALE_LIST = ["en", "en_GB", "ja", "fr", "de", "sw_TZ"]
# Environment
var isWeb
var isMobile
# Options
var isFullScreen
var isSoundOn
var isMusicOn
var myLocale

func _ready():
	# Called when the node is added to the scene for the first time.
	isWeb = OS.has_feature("web")
	isMobile = OS.has_feature("mobile")
	
	LoadOptions()
	
	# Connect canvas
	get_tree().connect("screen_resized",self,"Resize")
	
	# Connect buttons
	get_node("Container_MainMenu/Button_Start").connect("pressed",self,"StartGame")
	get_node("Container_MainMenu/Button_Options").connect("pressed",self,"ShowOptions")
	get_node("Dialog_Options/Container_Options/Option_Lang").connect("item_selected",self,"ChangeLocale")
	
	# Build option buttons for locales
	for i in range(LOCALE_LIST.size()):
		var lang = tr("KEY_"+ LOCALE_LIST[i].to_upper())
		get_node("Dialog_Options/Container_Options/Option_Lang").add_item(lang,i)
	
	pass
	
func LoadOptions():
	var options = ConfigFile.new()
	options.load("user://options.ini")
	
	isFullScreen = options.get_value("options","fullscreen",false)
	isSoundOn = options.get_value("options","sound",true)
	isMusicOn = options.get_value("options","music",true)
	myLocale = options.get_value("options","locale",GetDefaultLocale())
	
	UpdateAllOptions()
	
	pass

func UpdateAllOptions():
	OS.set_window_fullscreen(isFullScreen)
	AudioServer.set_bus_mute(1, !isSoundOn)
	AudioServer.set_bus_mute(2, !isMusicOn)
	TranslationServer.set_locale(myLocale)
	SaveOptions()
	pass
	
func SaveOptions():
	var options = ConfigFile.new()
	
	options.set_value("options","fullscreen",isFullScreen)
	options.set_value("options","sound",isSoundOn)
	options.set_value("options","music",isMusicOn)
	options.set_value("options","locale",myLocale)
	
	options.save("user://options.ini")
	pass

func GetDefaultLocale():
	var defaultLocale = OS.get_locale();
	if !(defaultLocale in LOCALE_LIST):
		# If not found attempt to find again with only lang code
		defaultLocale = defaultLocale.split("_",1)[0]
		if !(defaultLocale in LOCALE_LIST):
			defaultLocale = LOCALE_LIST[0]
	return defaultLocale

func ShowOptions():
	# Set values based off current variables
	get_node("Dialog_Options/Container_Options/CheckBox_Fullscreen").set_pressed(isFullScreen)
	get_node("Dialog_Options/Container_Options/CheckBox_Sound").set_pressed(isSoundOn)
	get_node("Dialog_Options/Container_Options/CheckBox_Music").set_pressed(isMusicOn)
	# For language options, find the correct index
	var lang = tr("KEY_"+ myLocale.to_upper())
	var numOptions = get_node("Dialog_Options/Container_Options/Option_Lang").get_item_count()
	var selectedIndex = 0
	for i in range(numOptions):
		var optionName = get_node("Dialog_Options/Container_Options/Option_Lang").get_item_text(i)
		if optionName == lang:
			selectedIndex = i
			break
	get_node("Dialog_Options/Container_Options/Option_Lang").select(selectedIndex)
	
	get_node("Dialog_Options").popup_centered()
	
	pass

func ChangeLocale(index):
	# Update Locale
	myLocale = LOCALE_LIST[index]
	TranslationServer.set_locale(myLocale)
	# Rebuild Options Strings since they were dynamic
	var numOptions = get_node("Dialog_Options/Container_Options/Option_Lang").get_item_count()
	for i in range(numOptions):
		var lang = tr("KEY_"+ LOCALE_LIST[i].to_upper())
		get_node("Dialog_Options/Container_Options/Option_Lang").set_item_text(i, lang)
		# Also change the option's primary text with the selected index
		if (index == i):
			get_node("Dialog_Options/Container_Options/Option_Lang").set_text(lang)
	pass

func Resize():
	
	
	if (get_node("Dialog_Options").is_visible()):
		get_node("Dialog_Options").popup_centered()
		
	pass

func StartGame():
	get_node("Panel_Background").hide()
	get_node("Container_MainMenu").hide()
	Game.Start()
	
	pass