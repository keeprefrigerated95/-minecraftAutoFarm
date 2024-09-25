/**********************************************
 * ~~~ AUTO FARM ~~~
 * A script that harvests and replants fields in minecraft
 **********************************************/

/************************************************
* GLOBAL VARIABLES
************************************************/
XPOS := 0.0 ;the players x coordinates
YPOS := 0.0 ;the players y coordinates
ZPOS := 0.0 ;the players z coordinates

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

/****************************************************
* GETPIXELS
* A function that gets the number of white pixels
* within a certain range
* X & Y: coordinates of the top left coner of the target
*        area 
* LENGHT: Length of the target area
* WIDTH: Width of the target area
*****************************************************/
getPixels(x, y, width, height)
{
    xStart := x
    yStart := y
    whitePixels := 0

    ;gets the columns of pixels
    loop height
    {
        ;gets the rows of pixels
        loop width
        {
            pixelColor := PixelGetColor(x, y)
            if (pixelColor = "0xdddddd")
            {
                whitePixels := whitePixels + 1
            }

            x := x + 2
        }
        y := y + 2
        x := xStart
    }
    return whitePixels
}

/************************************************
* CHECKIFDECIMAL
* Checks to see if a block of text at the coordinates
* is a decimal
* returns 0 if no, 1 if yes
************************************************/
checkIfDecimal(x, y)
{
    isDecimal := 0

    if (getPixels(x - 2, y, 3, 6) = 0 and getPixels(x - 2, y + 12, 3, 1) = 1 and PixelGetColor(x, y + 12) = "0xdddddd")
        {
            isDecimal := 1
        }
    return isDecimal
}

/**************************************************
* PIXELSTONUM
* converts raw data from the minecract debug screen
*  into a number
* WHITE PIXELS: The number of pixels with a portion of 
* text in a given area
***************************************************/
pixelToNum(whitePixels, xStart, yStart)
{
    numToPush := -1

    ;unique number of pixels
    if (whitePixels = 19)
    {
        numToPush := 0.0
    }
        
    else if (whitePixels = 16)
    {
        numToPush := 2.0
    }

    else if (whitePixels = 14)
    {
        numToPush := 3.0
    }

    ;12 white pixels
    if (whitePixels = 12 and PixelGetColor(xStart, yStart) = "0xdddddd")
    {
        numToPush := 7.0
    }

    else if (whitePixels = 12)
    {
        numToPush := 1.0
    }



    ;15 white pixels
    if (whitePixels = 15 and PixelGetColor(xStart + 2, yStart) = "0xdddddd")
    {
        numToPush := 9.0
    }

    else if (whitePixels = 15 and PixelGetColor(xStart + 8, yStart) = "0xdddddd")
    {
        numToPush := 4.0
    }

    else if (whitePixels = 15)
    {
        numToPush := 6.0
    }

    ;17 white pixels
    if (whitePixels = 17 and PixelGetColor(xStart, yStart) = "0xdddddd")
    {
        numToPush := 5.0
    }

    else if (whitePixels = 17)
    {
        numToPush := 8.0
    }

    return numToPush
}

/************************************************
* SETGLOBALCOORDINATES
* X, Y, and Z, the coordinats of the player, which
* are global variables
************************************************/
setGlobalCoordinates(x, y, z)
{
    global
    XPOS := x 
    YPOS := y 
    ZPOS := z 
}

/****************************************************
* GET COORDS 
* A function that gets the coordinates from the minecraft
* debug screen and saves them to global variables
*****************************************************/
getCoords(x, y)
{ 
    xStart := x
    yStart := y
    textWidth := 5
    textHeight := 7
    xIsNegative := 1.0
    yIsNegative := 1.0
    zIsNegative := 1.0
    xValues := Array()
    yValues := Array()
    zValues := Array()

    /*quit loop 0 assigns the x value
      1 assigns y, 2 assigns z, 3 quits
      the loop */
    quitLoop := 0
    while (quitLoop < 3)
    {
        ;check to see if there is a decimal and adjst x coordinate
        isDecimal := checkIfDecimal(xStart, yStart)
        if (isDecimal = 1)
        {
            xStart := xStart + 4
        }

        ;gets the number of pixels in this quadrant
        whitePixels := getPixels(xStart, yStart, textWidth, textHeight)

        ;check if the coordinate is a negative symbol
        if (whitePixels = 5)
        {
            if(quitLoop = 0)
            {
                xIsNegative := -1.0
            }
            
            if(quitLoop = 1)
            {
                yIsNegative := -1.0
            }

            if(quitLoop = 2)
            {
                zIsNegative := -1.0
            }
        }
        
        ;if not a negative symbol, figures out which number is being read, if any
        else
        {
            numToPush := pixelToNum(whitePixels, xStart, yStart)

            ;pushes the number that was read to the appropriate array
            if (numToPush != -1)
            {
                if(quitLoop = 0)
                {
                    xValues.Push(numToPush)
                }

                if(quitLoop = 1)
                {
                    yValues.Push(numToPush)
                }

                if(quitLoop = 2)
                {
                    zValues.Push(numToPush)
                }
            }
        }
        ;moves to the next number in the row
        if(isDecimal = 0)
        {
            xStart := xStart + 12
        }

        ;moves to the next coordinate
        if(isDecimal = 1 and quitLoop = 2)
        {
            quitLoop := quitLoop + 1
        }

        if(isDecimal = 1 and quitLoop = 1)
        {
            quitLoop := quitLoop + 1
            xStart := xStart + 88
        }


        if(isDecimal = 1 and quitLoop = 0)
        {
            quitLoop := quitLoop + 1
            xStart := xStart + 64
        }
       
    }
    
    ;converts the arrays to floats and saves to global variable
    xIn := 0.0
    yIn := 0.0
    zIn := 0.0

    multiplier := 0.1
    xArrayLength := xValues.Length
    loop xArrayLength
    {
        ;MsgBox xValues.Pop()
        xIn := xIn + (xValues.Pop() * multiplier)
        multiplier := multiplier * 10.0 
    }
    xIn := xIn * xIsNegative

    multiplier := 0.1
    yArrayLength := yValues.Length
    loop yArrayLength
    {
        yIn := yIn + (yValues.Pop() * multiplier)
        multiplier := multiplier * 10.0
    }
    yIn := yIn * yIsNegative

    multiplier := 0.1
    zArrayLength := zValues.Length
    loop zArrayLength
    {
        zIn := zIn + (zValues.Pop() * multiplier)
        multiplier := multiplier * 10.0
    }
    zIn := zIn * zIsNegative

    setGlobalCoordinates(xIn, yIn, zIn)
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
    windowName := ""

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

        if InStr(A_LoopReadLine, "windowName")
        {
            Loop parse, A_LoopReadLine, ":"
            {
                windowName := A_LoopField
            }

        }
    }

    WinMove 0, 0, 854, 560, windowName
    sleep 50
    send "{F3}"
    sleep 50
    CoordMode "Pixel", "Client"
    ;getCoords(53, 184)
    ;MsgBox(XPOS " " YPOS " " ZPOS)

    /* implements functions to complete the harvest, storage, and replanting process*/
    loop sections {
        loop passes {
            bumperSet(stepTime)

            ;moves the character from the bumpers onto a chest
            step(stepTime, "w")

            pass(stepTime, rowLength)
            deposit(inventoryX, invnetoryY, boxSize)
            
            ;moves the character into the bumpers 
            step(stepTime, "d")
            step(stepTime, "s")
        }
         step(stepTime, "d")
    }
   
    MsgBox "Harvest Complete OwO"
    ExitApp
}
