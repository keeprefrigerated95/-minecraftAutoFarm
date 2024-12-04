/***********************************************
 * TEMPLATE
 * A blank template for writing a Minecraft Bot
 ***********************************************/

#Requires AutoHotkey v2.0
#Include coordinates.ahk
#Include facing.ahk
#Include player.ahk

steve := Player()

/**********************************************
* X HOTKEY
* Press 'x' to cancel the script at any time
***********************************************/
*x::
{
    Send "{Shift up}"
    MsgBox "Script Cancelled"
    ExitApp
}

/************************************************
 * P HOTKEY
 * Press 'p' to pause the script at any time
 ************************************************/
*p::
{
    OutputDebug "PAUSED`n"
    Pause -1
    result := MsgBox("Would you like to continue? If you cancel, you will have to start the script over.", "Paused", "YesNo")
    if (result = "Yes")
    {
        OutputDebug "UNPAUSED`n"
        ;setUpWindow()
        Pause -1
    }

    else
    {
        Send "{Shift up}"
        MsgBox "Script Cancelled"
        ExitApp
    }
}

/****************************************
 * YOUR CODE HERE
 ****************************************/
OutputDebug steve.position.ToString() "`n"
steve.sneak(steve.sneakTime / 32, 'w', 1)

ExitApp