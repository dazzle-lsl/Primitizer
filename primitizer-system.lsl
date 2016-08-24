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
integer link_default_dialog_add = 13000;
integer link_options_dialog_add = 13001; // @todo move too primitizer-options.lsl
integer link_functions_dialog_add = 13002; // @todo move too primitizer-functions.lsl
integer link_help_dialog_add = 13003; // @todo move too primitizer-help.lsl
// internal + external added via there own methods scripts
// textures added via main menu via primitizer-textures.lsl
// effects added via main menu via primitizer-particles.lsl
// lights added via main menu via primitizer-lights.lsl

integer link_primitizer_interface_hud = 13000; // @todo move too primitizer-options.lsl

integer link_primitizer_interface_initialize = 13000;

integer link_primitizer_tutorial = 13000;


// Define API Seperator For Parsing String Data
string primitizer_seperator = "||";

// Dialog Time-Out Defined In Dialog Menu Creation.
integer dialog_timeout = 30;

// Define A List Containing All The Possible Default Dialog Buttons
list dialog_default_buttons = [];

// Define A List Containing All The Possible Default Dialog Returns
list dialog_default_returns = [];

// Define A List Containing All The Possible Options Dialog Buttons
list dialog_options_buttons = [];

// Define A List Containing All The Possible Options Dialog Returns
list dialog_options_returns = [];

// Define A List Containing All The Possible Functions Dialog Buttons
list dialog_functions_buttons = [];

// Define A List Containing All The Possible Functions Dialog Returns
list dialog_functions_returns = [];

// Define A List Containing All The Possible Help Dialog Buttons
list dialog_help_buttons = [];

// Define A List Containing All The Possible Help Dialog Returns
list dialog_help_returns = [];

///////////////////////////////////////////////////////////////////////////////
// Inventory Index Variables
///////////////////////////////////////////////////////////////////////////////
integer notecard_line;
///////////////////////////////////////////////////////////////////////////////
// Notecard System Variables
///////////////////////////////////////////////////////////////////////////////
string language_notecard;
string language_prefix = "lang_";
key language_query;

integer hud_handle;
key current_hud_key;
integer current_hud_channel;

integer hud_previous_channel;
key hud_previous_key;

// Packed Dialog Command
string packed(string message, list buttons, list returns, integer timeout)
{
    string packed_message = message + primitizer_seperator + (string)timeout;
    integer i;
    integer count = llGetListLength(buttons);
    for(i=0; i<count; i++) packed_message += primitizer_seperator + llList2String(buttons, i) + primitizer_seperator + llList2String(returns, i);
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
    llMessageLinked(LINK_THIS, link_interface_textbox, message + primitizer_seperator + (string)timeout, id);
}

// Create Button Sounds
dialog_sound(string sound, float volume)
{
    llMessageLinked(LINK_THIS, link_interface_sound, sound + primitizer_seperator + (string)volume, NULL_KEY);
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
        language_notecard = llGetInventoryName(INVENTORY_NOTECARD, notecard_line = 0);
        if( ~llGetInventoryType(  language_prefix + language_notecard ) ) language_query = llGetNotecardLine(language_prefix + language_notecard, notecard_line = 0);
    }

    changed(integer change) 
    {
        if (change & CHANGED_INVENTORY) 
        {
			llMessageLinked(LINK_THIS, link_primitizer_tutorial, "CHANGED_INVENTORY", NULL_KEY);
            llResetScript();
        } 
        if (change & CHANGED_OWNER) 
        { 
			llMessageLinked(LINK_THIS, link_primitizer_tutorial, "CHANGED_OWNER", NULL_KEY);
            llResetScript(); 
        }
        if (change & CHANGED_ALLOWED_DROP) 
        {
			llMessageLinked(LINK_THIS, link_primitizer_tutorial, "CHANGED_ALLOWED_DROP", NULL_KEY);
            llResetScript(); 
        }
    }

    dataserver(key query_id, string data)
    {
        if (query_id == language_query && language_prefix == "lang_")
        {
            // not at the end of the notecard
            // yay!  Parsing time
            if (data != EOF)
            {
                // pesky whitespace
                data = llStringTrim(data, STRING_TRIM_HEAD);

                // is it a comment?
                if (llGetSubString (data, 0, 0) != "#")
                {
                    integer s = llSubStringIndex(data, "=");
                    if(~s)//does it have an "=" in it?
                    {
                        string token = llToLower(llStringTrim(llDeleteSubString(data, s, -1), STRING_TRIM));
                        data = llStringTrim(llDeleteSubString(data, 0, s), STRING_TRIM);

                        //Insert your token parsers here.
                        if (token == "email_address")
                        {
                            //email_address = data;
                        }
                        else if (token == "channel")
                        {
                            //channel = (integer)data;
                        }
                    }
                }

                if( ~llGetInventoryType(  language_prefix + language_notecard ) ) language_query = llGetNotecardLine(language_prefix + language_notecard, ++notecard_line);
                llOwnerSay("Notecard Data: " + data);
            }
            else
            {
                llOwnerSay("Done Reading Notecard");
            }
        }
    }

    link_message(integer sender_num, integer num, string str, key id)
    {
        list data = llParseString2List(str, [primitizer_seperator], []);
        if(num == link_primitizer_interface_initialize)
        {
            //
        }
        else if(num == link_default_dialog_add)
        {
            string dialog_default_message = llList2String(data, 0);
            dialog_timeout = llList2Integer(data, 1);
            list dialog_menu_buttons = [];
            list dialog_menu_returns = [];
            integer index = 0;
            integer count = llGetListLength(data);
            for(index = 0; index < count; index)
            {
                dialog_default_buttons += [llList2String(data, index++)];
                dialog_default_returns += [llList2String(data, index++)];
            }
            add_menu("DEFAULT", dialog_default_message, dialog_default_buttons, dialog_default_returns, dialog_timeout);
        }
        else if(num == link_options_dialog_add)
        {
            string dialog_options_message = llList2String(data, 0);
            dialog_timeout = llList2Integer(data, 1);
            list dialog_menu_buttons = [];
            list dialog_menu_returns = [];
            integer index = 0;
            integer count = llGetListLength(data);
            for(index = 0; index < count; index)
            {
                dialog_options_buttons += [llList2String(data, index++)];
                dialog_options_returns += [llList2String(data, index++)];
            }
            add_menu("OPTIONS", dialog_options_message, dialog_options_buttons, dialog_options_returns, dialog_timeout);
        }
        else if(num == link_functions_dialog_add)
        {
            string dialog_functions_message = llList2String(data, 0);
            dialog_timeout = llList2Integer(data, 1);
            list dialog_menu_buttons = [];
            list dialog_menu_returns = [];
            integer index = 0;
            integer count = llGetListLength(data);
            for(index = 0; index < count; index)
            {
                dialog_functions_buttons += [llList2String(data, index++)];
                dialog_functions_returns += [llList2String(data, index++)];
            }
            add_menu("FUNCTIONS", dialog_functions_message, dialog_functions_buttons, dialog_functions_returns, dialog_timeout);
        }
        else if(num == link_help_dialog_add)
        {
            string dialog_help_message = llList2String(data, 0);
            dialog_timeout = llList2Integer(data, 1);
            list dialog_menu_buttons = [];
            list dialog_menu_returns = [];
            integer index = 0;
            integer count = llGetListLength(data);
            for(index = 0; index < count; index)
            {
                dialog_help_buttons += [llList2String(data, index++)];
                dialog_help_returns += [llList2String(data, index++)];
            }
            add_menu("HELP", dialog_help_message, dialog_help_buttons, dialog_help_returns, dialog_timeout);
        }
        /*
        options
        functions
        help
        interieer < neeeds be registered on it ows script
        exterior < neeeds be registered on it ows script
        
        */
        else if(num == link_primitizer_interface_hud)
        {
            current_hud_key = (key)llList2String(data, 0);
            current_hud_channel = (integer)llList2String(data, 1);
            if(current_hud_channel != hud_previous_channel)
            {
				llListenRemove(hud_handle);
				if(current_hud_key != hud_previous_key)
				{
					hud_previous_key = current_hud_key;
					hud_previous_channel = current_hud_channel;
					hud_handle = llListen(current_hud_channel, "", current_hud_key, "");
				}
            }
        }
    }

	touch_start(integer start)
	{
		language_notecard = "english";
		if( ~llGetInventoryType(  language_prefix + language_notecard ) )  language_query = llGetNotecardLine(language_prefix + language_notecard, notecard_line = 0);
	}
}