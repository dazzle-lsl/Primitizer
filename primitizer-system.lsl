///////////////////////////////////////////////////////////////////////////////
// Interface Link Messages
///////////////////////////////////////////////////////////////////////////////
// Add Menus To Interface API
integer link_interface_add = 0x3E8;

// Cancel Dialog Request
integer link_interface_cancel = 0x7D0;

// Cancel Button Is Triggered.
integer link_interface_cancelled = 0xBB8; // Message sent from link_interface_cancel to link message to be used in other scripts.

// Clear Dialog Request
integer link_interface_clear = 0xFA0;

// Display Dialog Interface
integer link_interface_dialog = 0x1388;

// Dialog Not Found
integer link_interface_not_found = 0x1770;

// Reshow Last Dialog Displayed
integer link_interface_reshow = 0x1B58;

// A Button Is Triggered, Or OK Is Triggered
integer link_interface_response = 0x1F40;

// Display Dialog
integer link_interface_show = 0x2328;

// Play Sound When Dialog Button Touched
integer link_interface_sound = 0x2710;

// Display Textbox Interface
integer link_interface_textbox = 0x2AF8;

// No Button Is Hit, Or Ignore Is Hit
integer link_interface_timeout = 0x2EE0;

///////////////////////////////////////////////////////////////////////////////
// System Link Messages
///////////////////////////////////////////////////////////////////////////////
integer link_primitizer_interface_add = 13000;

integer link_primitizer_interface_hud = 13000;

integer link_primitizer_interface_initialize = 13000;

///////////////////////////////////////////////////////////////////////////////
// Inventory Index Variables
///////////////////////////////////////////////////////////////////////////////
integer INDEX;
///////////////////////////////////////////////////////////////////////////////
// Notecard System Variables
///////////////////////////////////////////////////////////////////////////////
list LANGUAGE_NOTECARD_READ;
string LANGUAGE_NOTECARD;
string LANGUAGE_NOTECARD_PREFIX = "lang_";
key LANGUAGE_NOTECARD_QUERY;


// Define API Seperator For Parsing String Data
string dialog_seperator = "||";

// Dialog Time-Out Defined In Dialog Menu Creation.
integer primitizer_interface_timeout = 30;

// Define A List Containing All The Possible System Buttons
list primitizer_interface_buttons = [];

// Define A List Containing All The Possible System Returns
list primitizer_interface_returns = [];

// Packed Dialog Command
string packed(string message, list buttons, list returns, integer timeout)
{
    string packed_message = message + dialog_seperator + (string)timeout;
    integer i;
    integer count = llGetListLength(buttons);
    for(i=0; i<count; i++) packed_message += dialog_seperator + llList2String(buttons, i) + dialog_seperator + llList2String(returns, i);
    return packed_message;
}

// Show Dialog, If Name Not Specified Will Show First Menu In List
dialog_show(string name, key id)
{
    llMessageLinked(LINK_THIS, link_interface_show, name, id);
}

// Reshow Last Dialog
dialog_reshow()
{
    llMessageLinked(LINK_THIS, link_interface_reshow, "", NULL_KEY);
}

// Cancel Dialog Request
dialog_cancel()
{
    llMessageLinked(LINK_THIS, link_interface_cancel, "", NULL_KEY);
    llSleep(1);
}

// Create Dialog
add_menu(key id, string message, list buttons, list returns, integer timeout)
{
    llMessageLinked(LINK_THIS, link_interface_add, packed(message, buttons, returns, timeout), id);
}

// Create TextBox
add_textbox(key id, string message, integer timeout)
{
    llMessageLinked(LINK_THIS, link_interface_textbox, message + dialog_seperator + (string)timeout, id);
}

// Create Button Sounds
dialog_sound(string sound, float volume)
{
    llMessageLinked(LINK_THIS, link_interface_sound, sound + dialog_seperator + (string)volume, NULL_KEY);
}

// Clear Dialog API Memory
dialog_clear()
{
    llMessageLinked(LINK_THIS, link_interface_clear, "", NULL_KEY);
}

default
{
    state_entry()
    {
        dialog_clear();
    }

    link_message(integer sender_num, integer num, string str, key id)
    {
        list data = llParseString2List(str, [dialog_seperator], []);
		if(num == link_primitizer_interface_initialize)
		{
			add_menu("MainMenu",

				primitizer_interface_message, // Dialog Messages

				primitizer_interface_buttons, // Dialog Buttons

				primitizer_interface_returns, // Dialog Returns

				primitizer_interface_timeout // Dialog Timeout
			);
		}
		if(num == link_primitizer_interface_add)
		{
            primitizer_interface_message = llList2String(data, 0);
            primitizer_interface_timeout = llList2Integer(data, 1);
            //dialog_menu_buttons = [];
            //dialog_menu_returns = [];
            integer index = 0;
            integer count = llGetListLength(data);
            for(index = 0; index < count; index)
            {
                primitizer_interface_buttons += [llList2String(data, index++)];
                primitizer_interface_returns += [llList2String(data, index++)];
            }
		}
		else if(num == link_primitizer_interface_hud)
		{
			//
		}
}
state initialize
{
    state_entry()
    {
        llSay(0, "Hello, Avatar!");
    }
}

state running
{
    state_entry()
    {
        llSay(0, "Hello, Avatar!");
    }
}