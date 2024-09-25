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

;the players starting position
XINI := 0
YINI := 0
ZINI := 0

;the coordinates the player should be at
EXPECTEDX := 0
EXPECTEDY := 0
EXPECTEDZ := 0

;the direction the player is facing, n, s, e, w
DIRECTION := ""

;the button that needs to be pressed to go a certain direction
POSITIVEX := ""
NEGATIVEX := ""
POSITIVEZ := ""
NEGATIVEZ := ""

;sets the coordinate mode to the active client, not the entire window or screen
CoordMode "Pixel", "Client"

/************************************************
* SETGLOBALCOORDINATES
* X, Y, and Z, the current coordinats of the player, which
* are global variables
************************************************/
setGlobalCoordinates(x, y, z)
{
    global
    XPOS := x 
    YPOS := y 
    ZPOS := z 
}

/************************************************
* SETINITIALCOORDINATES
* X, Y, and Z, the starting coordinats of the player, which
* are global variables
************************************************/
setInitialCoordinates(x, y, z)
{
    global
    XINI := Integer(x)
    YINI := Integer(y)
    ZINI := Integer(z)
}

/************************************************
* SETEXPECTEDCOORDS
* used to set expected coordinate global variables
* this is where the player is supposed to be, commonly
* called after the step function
*************************************************/
setExpectedCoords(x, y, z)
{
    global
    EXPECTEDX := Integer(x)
    EXPECTEDY := Integer(y)
    EXPECTEDZ := Integer(z)
}

/************************************************
* SETDIRECTION
* the direction the player is facing, n, s, e, w
* sets the global variable
* also sets global variable for POSITIVE and NEGATIVE globals
************************************************/
setDirection(d)
{
    global
    DIRECTION := d

    if(DIRECTION = "n")
    {
        POSITIVEX := "d"
        NEGATIVEX := "a"
        POSITIVEZ := "s"
        NEGATIVEZ := "w"
    }

    if(DIRECTION = "s")
    {
        POSITIVEX := "a"
        NEGATIVEX := "d"
        POSITIVEZ := "w"
        NEGATIVEZ := "s"
    }

    if(DIRECTION = "e")
    {
        POSITIVEX := "w"
        NEGATIVEX := "s"
        POSITIVEZ := "d"
        NEGATIVEZ := "a"
    }

    if(DIRECTION = "w")
    {
        POSITIVEX := "s"
        NEGATIVEX := "w"
        POSITIVEZ := "a"
        NEGATIVEZ := "d"
    }
}

/* ***********************************************
 * STEP
 * steps the charachter forward a single block
 * timer: how many milliseconds the script will press
 * a certain key for
 * key: the key that will be pressed w, a, s or d
 * numSteps: the number of steps that will be taken
 **************************************************/
step(timer, key, numSteps)
{
    loop numSteps
    {
        Send "{Shift down}"
        sleep 100
        Send "{" key " down}"
        sleep timer
        Send "{" key " up}"
        sleep 100
        Send "{Shift up}"
        sleep 100
    }
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
* xStart and yStart: the coordinates of the number which 
* is being read, the center of the top left pixel in 
* the field where it is located (in groups of four pixels)
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

/****************************************************
* GET COORDS 
* A function that gets the coordinates from the minecraft
* debug screen and saves them to global variables
*****************************************************/
getCoords()
{ 
    xStart := 53
    yStart := 185
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

/*************************************************
* GETDIRECTION
* gets the direction in which the player is facing
* returns a string n, s, e or w
*************************************************/
getDirection()
{
    xStart := 81
    yStart := 243
    textWidth := 5
    textHeight := 7
    direction := ""

    ;gets the number of pixels in this quadrant
    whitePixels := getPixels(xStart, yStart, textWidth, textHeight)

    if (whitePixels = 12)
    {
        direction := "n"
    }

    else if (whitePixels = 15)
    {
        direction := "e"
    }

    else if (whitePixels = 13)
    {
        direction := "s"
    }

    else if (whitePixels = 14)
    {
        direction := "w"
    }

    return direction
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

/**************************************************
* CENTER PLAYER 
* centers the player on the target coordinates
* targetX & targetZ: the target coordinates
**************************************************/
centerPlayer(targetX, targetZ, timer)
{
    ;sets the current coordinates
    getCoords()
    centered := 0

    ;take the player to the correct coordinates
    while(centered = 0)
    {
        if(Integer(targetX) > Integer(XPOS))
        {
            step(timer, POSITIVEX, Integer(targetX) - Integer(XPOS))
            getCoords()
        }

        else if(Integer(targetX) < Integer(XPOS))
        {
            step(timer, NEGATIVEX, Integer(XPOS) - Integer(targetX))
            getCoords()
        }

        if(Integer(targetZ) > Integer(ZPOS))
        {
            step(timer, POSITIVEZ, Integer(targetZ) - Integer(ZPOS))
            getCoords()
        }

        else if(Integer(targetZ) < Integer(ZPOS))
        {
            step(timer, NEGATIVEZ, Integer(ZPOS) - Integer(targetZ))
            getCoords()
        }

        if(Integer(XPOS) = Integer(targetX) and Integer(ZPOS) = Integer(targetZ))
        {
            centered := 1
        }
    }

    ;centers the player on the block itself
    centered := 0
    xRoundedDown := Float(Integer(XPOS))
    zRoundedDown := Float(Integer(ZPOS))

    while (centered = 0)
    {
        if(XPOS - xRoundedDown < 0.4)
        {
            step(timer / 8, POSITIVEX, 1)
            getCoords()
        }

        else if(XPOS - xRoundedDown > 0.7)
        {
            step(timer / 8, NEGATIVEX, 1)
            getCoords()
        }

        if(ZPOS - zRoundedDown < 0.4)
        {
            step(timer / 8, POSITIVEZ, 1)
            getCoords()
        }

        else if(ZPOS - zRoundedDown > 0.7)
        {
            step(timer / 8, NEGATIVEZ, 1)
            getCoords()
        }

        xRoundedDown := Float(Integer(XPOS))
        zRoundedDown := Float(Integer(ZPOS))

        if(XPOS - xRoundedDown >= 0.4 and XPOS - xRoundedDown <= 0.7 and ZPOS - zRoundedDown >= 0.4 and ZPOS - zRoundedDown <= 0.7)
        {
            centered := 1
        }
    }
}

/*******************************************
* UPDATESINGLESTEP
* updates the expected location by one step depending
* on the input, w a s or d
********************************************/
updateSingleStep(keyPress)
{
    if(DIRECTION = "n")
    {
        if(keyPress = "w")
        {
            setExpectedCoords(EXPECTEDX, EXPECTEDY, EXPECTEDZ - 1)
        }

        if(keyPress = "a")
        {
            setExpectedCoords(EXPECTEDX - 1, EXPECTEDY, EXPECTEDZ)
        }

        if(keyPress = "s")
        {
            setExpectedCoords(EXPECTEDX, EXPECTEDY, EXPECTEDZ + 1)
        }

        if(keyPress = "d")
        {
            setExpectedCoords(EXPECTEDX + 1, EXPECTEDY, EXPECTEDZ)
        }
    }

    if(DIRECTION = "s")
    {
        if(keyPress = "w")
        {
            setExpectedCoords(EXPECTEDX, EXPECTEDY, EXPECTEDZ + 1)
        }

        if(keyPress = "a")
        {
            setExpectedCoords(EXPECTEDX + 1, EXPECTEDY, EXPECTEDZ)
        }

        if(keyPress = "s")
        {
            setExpectedCoords(EXPECTEDX, EXPECTEDY, EXPECTEDZ - 1)
        }

        if(keyPress = "d")
        {
            setExpectedCoords(EXPECTEDX - 1, EXPECTEDY, EXPECTEDZ)
        }
    }

    if(DIRECTION = "e")
    {
        if(keyPress = "w")
        {
            setExpectedCoords(EXPECTEDX + 1, EXPECTEDY, EXPECTEDZ)
        }

        if(keyPress = "a")
        {
            setExpectedCoords(EXPECTEDX, EXPECTEDY, EXPECTEDZ - 1)
        }

        if(keyPress = "s")
        {
            setExpectedCoords(EXPECTEDX - 1, EXPECTEDY, EXPECTEDZ)
        }

        if(keyPress = "d")
        {
            setExpectedCoords(EXPECTEDX, EXPECTEDY, EXPECTEDZ + 1)
        }
    }

    if(DIRECTION = "w")
    {
        if(keyPress = "w")
        {
            setExpectedCoords(EXPECTEDX - 1, EXPECTEDY, EXPECTEDZ)
        }

        if(keyPress = "a")
        {
            setExpectedCoords(EXPECTEDX, EXPECTEDY, EXPECTEDZ + 1)
        }

        if(keyPress = "s")
        {
            setExpectedCoords(EXPECTEDX + 1, EXPECTEDY, EXPECTEDZ)
        }

        if(keyPress = "d")
        {
            setExpectedCoords(EXPECTEDX, EXPECTEDY, EXPECTEDZ - 1)
        }
    }
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
        step(timer, "w", 1)
        updateSingleStep("w")
        harvest()
    }
    
    step(timer, "d", 1)
    updateSingleStep("d")

    loop stepsInRow {
        harvest()
        step(timer, "s", 1)
        updateSingleStep("s")
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

MsgBox "Welcome to Auto Farm! Press R to begin the harvest process. Press X to cancel at any time :3 You may close this window "

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
    inventoryX := 267
    invnetoryY := 0
    depositContainer := ""
    boxSize := 35
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

        if InStr(A_LoopReadLine, "depositContainer")
        {
            Loop parse, A_LoopReadLine, ":"
            {
                depositContainer := A_LoopField
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

    ;sets proper coordinates for target deposit container
    if(depositContainer = "single")
    {
        inventoryY := 270
    }

    if(depositContainer = "barrel")
    {
        inventoryY := 270
    }

    if(depositContainer = "double")
    {
        inventoryY := 323
    }

    if(depositContainer = "hopper")
    {
        inventoryY := 237
    }

    ;sets the window size and opens the minecraft debug menu
    WinMove 0, 0, 854, 560, windowName
    sleep 50
    send "{F3}"
    sleep 50

    ;gets the players current coordinates, saves them to the initial coordinates and direction
    getCoords()
    setInitialCoordinates(XPOS, YPOS, ZPOS)
    setDirection(getDirection())
    setExpectedCoords(XPOS, YPOS, ZPOS)
    centerPlayer(XPOS, ZPOS, stepTime)
    
    /* implements functions to complete the harvest, storage, and replanting process*/
    loop sections {
        loop passes {
            pass(stepTime, rowLength)
            centerPlayer(EXPECTEDX, EXPECTEDZ, stepTime)
            deposit(inventoryX, inventoryY, boxSize)
            step(stepTime, "d", 1)
            updateSingleStep("d")
        }
         step(stepTime, "d", 1)
         updateSingleStep("d")
    }
    MsgBox "Harvest Complete OwO"
    ExitApp
}
