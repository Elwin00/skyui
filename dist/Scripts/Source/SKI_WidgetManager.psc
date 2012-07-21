scriptname SKI_WidgetManager extends SKI_QuestBase hidden

; CONSTANTS ---------------------------------------------------------------------------------------

string property		HUD_MENU = "HUD Menu" autoReadOnly


; PRIVATE VARIABLES -------------------------------------------------------------------------------

SKI_WidgetBase[]	_widgets
string[]			_widgetTypes
int					_curWidgetID
int					_widgetCount


; INITIALIZATION ----------------------------------------------------------------------------------

event OnInit()
	_widgets		= new SKI_WidgetBase[128]
	_widgetTypes	= new string[128]
	_curWidgetID	= 0
	_widgetCount	= 0
	
	OnGameReload()
endEvent

event OnGameReload()
	RegisterForModEvent("widgetLoaded", "OnWidgetLoad")
	
	CleanUp()
	
	; Load already registered widgets
	UI.InvokeStringA(HUD_MENU, "_global.WidgetLoader.loadWidgets", _widgetTypes);
endEvent

function CleanUp()
	_widgetCount = 0
	int i = 0
	while (i < _widgets.length)
		if (_widgets[i] == none)
			_widgetTypes[i] = none
		else
			_widgetCount += 1
		endIf
		
		i += 1
	endWhile
endFunction


; EVENTS ------------------------------------------------------------------------------------------

event OnWidgetLoad(string a_eventName, String a_strArg, float a_numArg, Form a_sender)
	int widgetID = a_strArg as int
	SKI_WidgetBase client = _widgets[widgetID]
	
	if (client != none)
		client.OnWidgetLoad()
	endIf
endEvent


; FUNCTIONS ---------------------------------------------------------------------------------------

int function RequestWidgetID(SKI_WidgetBase a_client)
	if (_widgetCount >= 128)
		return -1 ;TODO 20120919 need to check for these
	endIf

	int widgetID = NextWidgetID()
	_widgets[widgetID] = a_client
	_widgetCount += 1
	
	return widgetID
endFunction

int function NextWidgetID()
	int startIdx = _curWidgetID
	
	while (_widgets[_curWidgetID] != none)
		_curWidgetID += 1
		if (_curWidgetID >= 128)
			_curWidgetID = 0
		endIf
		if (_curWidgetID == startIdx)
			return -1 ; Should never happen because we have widgetCount. Just to be sure. 
		endIf
	endWhile
	
	return _curWidgetID
endFunction

function CreateWidget(int a_widgetID, string a_widgetType)
	_widgetTypes[a_widgetID] = a_widgetType
	string[] args = new string[2]
	args[0] = a_widgetID as string
	args[1] = a_widgetType
	UI.InvokeStringA(HUD_MENU, "_global.WidgetLoader.loadWidget", args);
endFunction
