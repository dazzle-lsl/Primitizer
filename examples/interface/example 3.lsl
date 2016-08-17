// Add Menus To Interface API
integer LINK_INTERFACE_ADD = 0x3E8;

// Cancel Dialog Request
integer LINK_INTERFACE_CANCEL = 0x7D0;

// Cancel Button Is Triggered.
integer LINK_INTERFACE_CANCELLED = 0xBB8; // Message sent from LINK_INTERFACE_CANCEL to link message to be used in other scripts.

// Clear Dialog Request
integer LINK_INTERFACE_CLEAR = 0xFA0;

// Display Dialog Interface
integer LINK_INTERFACE_DIALOG = 0x1388;

// Dialog Not Found
integer LINK_INTERFACE_NOT_FOUND = 0x1770;

// Reshow Last Dialog Displayed
integer LINK_INTERFACE_RESHOW = 0x1B58;

// A Button Is Triggered, Or OK Is Triggered
integer LINK_INTERFACE_RESPONSE = 0x1F40;

// Display Dialog
integer LINK_INTERFACE_SHOW = 0x2328;

// Play Sound When Dialog Button Touched
integer LINK_INTERFACE_SOUND = 0x2710;

// Display Textbox Interface
integer LINK_INTERFACE_TEXTBOX = 0x2AF8;

// No Button Is Hit, Or Ignore Is Hit
integer LINK_INTERFACE_TIMEOUT = 0x2EE0;

// Define API Seperator For Parsing String Data
string DIALOG_SEPERATOR = "||";

// Dialog Time-Out Defined In Dialog Menu Creation.
integer DIALOG_TIMEOUT = 30;

// Packed Dialog Command
string packed(string message, list buttons, list returns, integer timeout)
{
    string packed_message = message + DIALOG_SEPERATOR + (string)timeout;
    integer i;
    integer count = llGetListLength(buttons);
    for(i=0; i<count; i++) packed_message += DIALOG_SEPERATOR + llList2String(buttons, i) + DIALOG_SEPERATOR + llList2String(returns, i);
    return packed_message;
}

// Show Dialog, If Name Not Specified Will Show First Menu In List
dialog_show(string name, key id)
{
    llMessageLinked(LINK_THIS, LINK_INTERFACE_SHOW, name, id);
}

// Reshow Last Dialog
dialog_reshow()
{
    llMessageLinked(LINK_THIS, LINK_INTERFACE_RESHOW, "", NULL_KEY);
}

// Cancel Dialog Request
dialog_cancel()
{
    llMessageLinked(LINK_THIS, LINK_INTERFACE_CANCEL, "", NULL_KEY);
    llSleep(1);
}

// Create Dialog
add_menu(key id, string message, list buttons, list returns, integer timeout)
{
    llMessageLinked(LINK_THIS, LINK_INTERFACE_ADD, packed(message, buttons, returns, timeout), id);
}

// Create TextBox
add_textbox(key id, string message, integer timeout)
{
    llMessageLinked(LINK_THIS, LINK_INTERFACE_TEXTBOX, message + DIALOG_SEPERATOR + (string)timeout, id);
}

// Create Button Sounds
dialog_sound(string sound, float volume)
{
    llMessageLinked(LINK_THIS, LINK_INTERFACE_SOUND, sound + DIALOG_SEPERATOR + (string)volume, NULL_KEY);
}

// Clear Dialog API Memory
dialog_clear()
{
    llMessageLinked(LINK_THIS, LINK_INTERFACE_CLEAR, "", NULL_KEY);
}
// ********** END DIALOG FUNCTIONS **********

string TEXTURE_DIALOG;

list TEXTURE_BUTTONS = [];
list TEXTURE_RETURNS = [];

string INVENTORY_TEXTURE_NAME; // Get Texture Name

list inventory(integer type)
{
    list inventory = [];
    integer index;
    integer count = llGetInventoryNumber(type);
    string  inventory_name;
    for(index=0; index<count; index++)
    {
        inventory_name = llGetInventoryName(type, index);
        inventory += [inventory_name];
    }
    return inventory;
}

initTextures()
{
    llOwnerSay("Inventory change detected; re-initializing...");

    dialog_clear();

    TEXTURE_DIALOG = "Click BACK/NEXT to change page.\n" +
        "Click a texture button to choose.";

    integer count = llGetInventoryNumber(INVENTORY_TEXTURE);
    integer index;
    for(index = 0; index<count; ++index)
    {
        INVENTORY_TEXTURE_NAME = llGetInventoryName(INVENTORY_TEXTURE, index);
        
        llSay(0, "DEBUG TEXTURE_NAME:" + INVENTORY_TEXTURE_NAME);
        TEXTURE_BUTTONS += [llGetSubString(INVENTORY_TEXTURE_NAME, 0, 12)];
        TEXTURE_RETURNS += [INVENTORY_TEXTURE_NAME];
		llSleep(0.1);
    }
        add_menu("MainMenu",

            TEXTURE_DIALOG, // Dialog Messages

            TEXTURE_BUTTONS, // Dialog Buttons

            TEXTURE_RETURNS, // Dialog Returns

            DIALOG_TIMEOUT // Dialog Timeout
        );

    llOwnerSay("Initializing completed.");
}
 
default
{
    state_entry()
	{
        initTextures();
    }

    changed(integer changes)
	{
        if(changes & CHANGED_INVENTORY) llResetScript();
    }

    link_message(integer sender_num, integer num, string str, key id)
	{
        if(num == LINK_INTERFACE_RESPONSE)
        {
            llOwnerSay("LINK_INTERFACE_RESPONSE:" + str);
            if(llGetInventoryType(str) == INVENTORY_TEXTURE) llSetTexture(str, ALL_SIDES);
        }
    }

    touch_start(integer num_detected)
    {
        dialog_show("MainMenu", llDetectedOwner(0));
    }
}