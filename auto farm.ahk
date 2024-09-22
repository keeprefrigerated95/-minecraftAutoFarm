/**********************************************
 * ~~~ AUTO FARM ~~~
 * A script that harvests and replants fields in minecraft
 **********************************************/

/* ***********************************************
 * STEP
 * steps the charachter forward a single block
 * timer: how many milliseconds the script will press
 * a certain key for
 * key: the key that will be pressed w, a, s or d
 **************************************************/
step(timer, key)
{
    Send "{Shift down}"
    sleep 100
    Send "{" key " down}"
    sleep timer
    Send "{" key " up}"
    sleep 100
    Send "{Shift up}"
    sleep 100
    return
}

/************************************************
* HARVEST 
* Harvests and plants one tile
*************************************************/
harvest()
{
    click "Left"
    sleep 200
    click "Right"
    sleep 200
    return
}

/************************************************
* BUMPERSET 
* centers the charachter on a block using bumpers
* TIMER: The time needed to take a single step
*************************************************/
bumperSet(timer)
{
    step(timer, "s")
    step(timer, "a")
    step(timer / 8, "d")
    step(timer / 8, "w")
}

/**************************************************
 * PASS 
 * Harvests two rows, a full pass
 * TIMER: the amount of time needed to take one step
 *    needed for the step function
 * STEPSINROW: the number of steps needed to reach the
 *    end of one row
 ***************************************************/
pass(timer, stepsInRow)
{
    loop stepsInRow {
        step(timer, "w")
        harvest()
    }
    
    step(timer, "d")

    loop stepsInRow {
        harvest()
        step(timer, "s")
    }
    ;step(timer, "s") ;puts you on top of a chest or hopper
}

/**********************************************
 * DEPOSIT
 * deposits all items into a chest
 * X & Y: The x and y coordinates of the top Left
 *   inventory slot when opening a chest or hopper
 * OFFSET: the number of pixels the cursor needs to
     move to go to the next invnetory slot
 ***********************************************/
deposit(x, y, offset) {
    click "Right"
    xActive := x
    yActive := y
    loop 3 {
        loop 9 {
            Send "{Shift down}"
            sleep 200
            click xActive, yActive
            sleep 200
            Send "{Shift up}"
            sleep 200
            
            xActive := xActive + offset
        }
        yActive := yActive + offset
        xActive := x
    }
    send "{Escape}"
}

MsgBox "Welcome to Auto Farm! Press R to begin the harvest process. Press X to cancel at any time :3 You may close this window"

/**********************************************
 * X HOTKEY
 * Press 'x' to cancel the script at any time
 * works if shift is being used by the script
 ***********************************************/
x::
{
    Send "{Shift up}"
    MsgBox "Script Cancelled"
    ExitApp
}

+x::
{
    Send "{Shift up}"
    MsgBox "Script Cancelled"
    ExitApp
}


/**********************************************
 * R HOTKEY
 * Press 'R' to run the farming process
 ***********************************************/
r::
{
    sections := 0
    passes := 0
    rowLength := 0
    stepTime := 0
    inventoryX := 0
    invnetoryY := 0
    boxSize := 0

    /* reads and loads data from the autoFarmData.txt file */
    Loop read, "autoFarmData.txt"
    {
        if InStr(A_LoopReadLine, "sections")
        {
            Loop parse, A_LoopReadLine, ":"
            {
                sections := A_LoopField
            }
        }

        if InStr(A_LoopReadLine, "passes")
        {
            Loop parse, A_LoopReadLine, ":"
            {
                passes := A_LoopField
            }
        }

        if InStr(A_LoopReadLine, "rowLength")
        {
            Loop parse, A_LoopReadLine, ":"
            {
                rowLength := A_LoopField
            }
        }

        if InStr(A_LoopReadLine, "stepTime")
        {
            Loop parse, A_LoopReadLine, ":"
            {
                stepTime := A_LoopField
            }
        }

        if InStr(A_LoopReadLine, "inventoryX")
        {
            Loop parse, A_LoopReadLine, ":"
            {
                inventoryX := A_LoopField
            }
        }

        if InStr(A_LoopReadLine, "inventoryY")
        {
            Loop parse, A_LoopReadLine, ":"
            {
                invnetoryY := A_LoopField
            }
        }

        if InStr(A_LoopReadLine, "boxSize")
        {
            Loop parse, A_LoopReadLine, ":"
            {
                boxSize := A_LoopField
            }

        }
    }

    /* implements functions to complete the harvest, storage, and replanting process*/
    loop sections {
        loop passes {
            bumperSet(stepTime)

            ;moves the character from the bumpers onto a chest
            step(stepTime, "w")

            pass(stepTime, rowLength)
            deposit(inventoryX, invnetoryY, boxSize)
            
            ;moves the charachter into the bumpers 
            step(stepTime, "d")
            step(stepTime, "s")
        }
         step(stepTime, "d")
    }

   
    MsgBox "Harvest Complete OwO"
    ExitApp
}
