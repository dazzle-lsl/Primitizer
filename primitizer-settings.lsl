list script_order()
{
    list inventory = [];
    integer index;
    integer count = llGetInventoryNumber(INVENTORY_SCRIPT);
    string  inventory_name;
    for(index=0; index<count; index++)
    {
        inventory_name = llGetInventoryName(INVENTORY_SCRIPT, index);
        if(inventory_name != "primitizer-interface.lsl" && inventory_name != llGetScriptName()) inventory += [inventory_name];
    }
    return inventory;
}

script_init(list scripts)
{
    integer index;
    integer count = llGetListLength(scripts);
    for(index=0; index<count; index++)
    {
        llResetOtherScript(llList2String(scripts, index));
    }
}

// RESET SCRIPTS IN ORDER OF LIST
default
{
    state_entry()
    {
        script_init(script_order());
    }

    touch_start(integer total_number)
    {
        script_init(script_order());
        //llSay(0, llDumpList2String(test, "||"));
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