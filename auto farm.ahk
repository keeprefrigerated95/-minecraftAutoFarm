/**********************************************
 * ~~~ AUTO FARM ~~~
 * A script that harvests and replants fields in minecraft
 **********************************************/

#Include coordinates.ahk
#Include direction.ahk

CoordMode "Pixel", "Client"

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
    OutputDebug "`n---------------------------------------------------------------------------------------------------`nSTEP`nINPUT`n"
    OutputDebug "timer: " timer "`n"
    OutputDebug "key: " key "`n"
    OutputDebug "numSteps: " numSteps "`n----------------`n"

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
getPixels(firstPixel, width, height)
{
    OutputDebug "`n----------------`nGETPIXELS`nINPUT`n"
    OutputDebug "firstPixel: " firstPixel.ToString() "`n"
    OutputDebug "width: " width "`n"
    OutputDebug "height: " height "`n"

    pixelToRead := Coordinates(firstPixel.x, firstPixel.y, 0)
    whitePixels := 0

    ;gets the columns of pixels
    loop height
    {
        ;gets the rows of pixels
        loop width
        {
            pixelColor := PixelGetColor(pixelToRead.x, pixelToRead.y)
            if (pixelColor = "0xdddddd")
            {
                whitePixels := whitePixels + 1
            }

            pixelToRead.x += 2
        }
        pixelToRead.y += 2
        pixelToRead.x := firstPixel.x
    }

    OutputDebug "OUTPUT`n"
    OutputDebug "whitePixels: " whitePixels "`n----------------`n"
    return whitePixels
}

/************************************************
* CHECKIFDECIMAL
* Checks to see if a block of text at the coordinates
* is a decimal
* returns 0 if no, 1 if yes
************************************************/
checkIfDecimal(currentSlot)
{
    OutputDebug "`n----------------`nCHECK IF DECIMAL START`n"
    OutputDebug "INPUT`n"
    OutputDebug "currentSlot: " currentSlot.ToString() "`n----------------`n"

    isDecimal := 0
    sectionOne := Coordinates(currentSlot.x - 2, currentSlot.y, 0)
    sectionTwo := Coordinates(currentSlot.x - 2, currentSlot.y + 12, 0)
    sectionThree := Coordinates(currentSlot.x, currentSlot.y + 12, 0)

    ;if the top section above the pixel is blank, and if there is one pixel on the bottom center
    if (getPixels(sectionOne, 3, 6) = 0 and getPixels(sectionTwo, 3, 1) = 1 and PixelGetColor(sectionThree.x, sectionThree.y) = "0xdddddd")
    {
        isDecimal := 1
    }
    
    OutputDebug "`n----------------`nCHECK IF DECIMAL END`n"
    OutputDebug "OUTPUT`n"
    OutputDebug "isDecimal: " isDecimal "`n----------------`n"
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
pixelToNum(whitePixels, topLeftCoords)
{
    OutputDebug "`n----------------`nPIXELNOTNUM`nINPUT`n"
    OutputDebug "whitePixels: " whitePixels "`n"
    OutputDebug "topLeftCoords: " topLeftCoords.ToString() "`n"

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
    if (whitePixels = 12 and PixelGetColor(topLeftCoords.x, topLeftCoords.y) = "0xdddddd")
    {
        numToPush := 7.0
    }

    else if (whitePixels = 12)
    {
        numToPush := 1.0
    }



    ;15 white pixels
    if (whitePixels = 15 and PixelGetColor(topLeftCoords.x + 2, topLeftCoords.y) = "0xdddddd")
    {
        numToPush := 9.0
    }

    else if (whitePixels = 15 and PixelGetColor(topLeftCoords.x + 8, topLeftCoords.y) = "0xdddddd")
    {
        numToPush := 4.0
    }

    else if (whitePixels = 15)
    {
        numToPush := 6.0
    }

    ;17 white pixels
    if (whitePixels = 17 and PixelGetColor(topLeftCoords.x, topLeftCoords.y) = "0xdddddd")
    {
        numToPush := 5.0
    }

    else if (whitePixels = 17)
    {
        numToPush := 8.0
    }

    OutputDebug "OUTPUT`n"
    OutputDebug "numToPush: " numToPush "`n----------------`n"
    return numToPush
}

/****************************************************
* GET COORDS 
* A function that gets the coordinates from the minecraft
* debug screen and saves them to global variables
*****************************************************/
getCoords()
{ 
    topLeftCoords := Coordinates(53, 167, 0)
    textWidth := 5
    textHeight := 7
    xIsNegative := 1.0
    yIsNegative := 1.0
    zIsNegative := 1.0
    xValues := Array()
    yValues := Array()
    zValues := Array()

    OutputDebug "`n----------------`nGET COORDS START`n"
    OutputDebug "topLeftCoords: " topLeftCoords.ToString() "`n----------------`n"

    /*quit loop 0 assigns the x value
      1 assigns y, 2 assigns z, 3 quits the loop */
    quitLoop := 0
    while (quitLoop < 3)
    {
        ;check to see if there is a decimal and adjst x coordinate
        isDecimal := checkIfDecimal(topLeftCoords)
        if (isDecimal = 1)
        {
            topLeftCoords.x += 4
            ;OutputDebug "Is Decimal`n"
        }

        ;gets the number of pixels in this quadrant
        whitePixels := getPixels(topLeftCoords, textWidth, textHeight)

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
            numToPush := pixelToNum(whitePixels, topLeftCoords)
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
            ;xStart := xStart + 12
            topLeftCoords.x += 12
        }

        ;ends the loop
        if(isDecimal = 1 and quitLoop = 2)
        {
            quitLoop := quitLoop + 1
        }

        ;moves to the Z coordinate
        if(isDecimal = 1 and quitLoop = 1)
        {
            quitLoop := quitLoop + 1
            ;xStart := xStart + 88
            topLeftCoords.x += 88
        }

        ;moves to the Y coordinate
        if(isDecimal = 1 and quitLoop = 0)
        {
            quitLoop := quitLoop + 1
            ;xStart := xStart + 64
            topLeftCoords.x += 64
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

    output := Coordinates(xIn, yIn, zIn)

    OutputDebug "`n----------------`nGETCOORDS END`n"
    OutputDebug "OUTPUT`n"
    OutputDebug "output coordinates: " output.ToString() "`n----------------`n"
    return output
}

/*************************************************
* GETDIRECTION
* gets the direction in which the player is facing
* returns a string n, s, e or w
*************************************************/
getDirection()
{
    topLeftCoords := Coordinates(81, 225, 0)
    textWidth := 5
    textHeight := 7
    direction := ""

    OutputDebug "`n----------------`nGETDIRECTION`n"

    ;gets the number of pixels in this quadrant
    whitePixels := getPixels(topLeftCoords, textWidth, textHeight)

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
    
    OutputDebug "OUTPUT`n"
    OutputDebug "direction: " direction "`n----------------`n"
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
centerPlayer(targetCoords, timer, facingData)
{
    OutputDebug "`n----------------`nCENTER PLAYER`nINPUT`n"
    OutputDebug "targetCoords: " targetCoords.ToString() "`n----------------`n"

    ;sets the current coordinates
    currentCoords := getCoords()
    centered := 0

    ;take the player to the correct coordinates
    while(centered = 0)
    {
        if(Integer(targetCoords.x) > Integer(currentCoords.x))
        {
            step(timer, facingData.positiveX, Integer(targetCoords.x) - Integer(currentCoords.x))
            currentCoords := getCoords()
        }

        else if(Integer(targetCoords.x) < Integer(currentCoords.x))
        {
            step(timer, facingData.negativeX, Integer(currentCoords.x) - Integer(targetCoords.x))
            currentCoords := getCoords()
        }

        if(Integer(targetCoords.z) > Integer(currentCoords.z))
        {
            step(timer, facingData.positiveZ, Integer(targetCoords.z) - Integer(currentCoords.z))
            currentCoords := getCoords()
        }

        else if(Integer(targetCoords.z) < Integer(currentCoords.z))
        {
            step(timer, facingData.negativeZ, Integer(targetCoords.z) - Integer(targetCoords.z))
            currentCoords := getCoords()
        }

        if(Integer(currentCoords.x) = Integer(targetCoords.x) and Integer(currentCoords.z) = Integer(targetCoords.z))
        {
            centered := 1
        }
    }

    ;centers the player on the block itself
    centered := 0
    roundedDown := Coordinates(Float(Integer(currentCoords.x)), Float(Integer(currentCoords.y)), Float(Integer(currentCoords.z)))
    while (centered = 0)
    {
        if(Abs(currentCoords.x - roundedDown.x) >= 0.3 and Abs(currentCoords.x - roundedDown.x) <= 0.7 and Abs(currentCoords.z - roundedDown.z) >= 0.3 and Abs(currentCoords.z - roundedDown.z) <= 0.7)
        {
            centered := 1
        }

        else if(currentCoords.x - roundedDown.x < 0.3 and currentCoords.x - 0.3 >= 0 or currentCoords.x - roundedDown.x < -0.7)
        {
            step(timer / 8, facingData.positiveX, 1)
            currentCoords := getCoords()
        }

        else if(currentCoords.x - roundedDown.x > 0.7 or currentCoords.x - roundedDown.x > -0.3 and currentCoords.x - roundedDown.x <= 0)
        {
            step(timer / 8, facingData.negativeX, 1)
            currentCoords := getCoords()
        }

        else if(currentCoords.z - roundedDown.z < 0.3 and currentCoords.z - 0.3 >= 0 or currentCoords.z - roundedDown.z < -0.7)
        {
            step(timer / 8, facingData.positiveZ, 1)
            currentCoords := getCoords()
        }

        else if(currentCoords.z - roundedDown.z > 0.7 or currentCoords.z - roundedDown.z > -0.3 and currentCoords.z - roundedDown.z <= 0)
        {
            step(timer / 8, facingData.negativeZ, 1)
            currentCoords := getCoords()
        }
    }
}

/*******************************************
* UPDATESINGLESTEP
* updates the expected location by one step depending
* on the input, w a s or d
********************************************/
updateSingleStep(keyPress, currentCoords, facingData)
{

    if(facingData.positiveX = keyPress)
    {
        currentCoords.x += 1
    }

    else if (facingData.negativeX = keyPress)
    {
        currentCoords.x -= 1
    }

    else if (facingData.positiveZ = keyPress)
    {
        currentCoords.z += 1
    }

    else if (facingData.negativeZ = keyPress)
    {
        currentCoords.z -= 1
    }

    return currentCoords
}

/**************************************************
 * PASS 
 * Harvests two rows, a full pass
 * TIMER: the amount of time needed to take one step
 *    needed for the step function
 * STEPSINROW: the number of steps needed to reach the
 *    end of one row
 ***************************************************/
pass(timer, stepsInRow, currentPos, facingData)
{
    loop stepsInRow {
        step(timer, "w", 1)
        currentPos := updateSingleStep("w", currentPos, facingData)
        harvest()
    }
    
    step(timer, "d", 1)
    currentPos := updateSingleStep("d", currentPos, facingData)

    loop stepsInRow {
        harvest()
        step(timer, "s", 1)
        currentPos := updateSingleStep("s", currentPos, facingData)
    }

    return currentPos
}

/**********************************************
 * DEPOSIT
 * deposits all items into a chest
 * X & Y: The x and y coordinates of the top Left
 *   inventory slot when opening a chest or hopper
 * OFFSET: the number of pixels the cursor needs to
     move to go to the next invnetory slot
 ***********************************************/
deposit(topLeftInv, offset) {
    click "Right"
    cursorCoords := topLeftInv
    loop 3 {
        loop 9 {
            Send "{Shift down}"
            sleep 200
            click cursorCoords.x, cursorCoords.y
            sleep 200
            Send "{Shift up}"
            sleep 200
            
            cursorCoords.x += offset
        }
        cursorCoords.y += offset
        cursorCoords.x := topLeftInv.x
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

    inventoryX := 267
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

    invCoords := Coordinates(inventoryX, inventoryY, 0)

    ;sets the window size and opens the minecraft debug menu
    WinMove 0, 0, 854, 560, windowName
    sleep 50
    send "{F3}"
    sleep 50

    ;coordinates where the player starts
    initialCoords := getCoords()

    /*keeps track of where the player should be
    (prevents overuse of getCoords function becuase it's slow)*/
    expectedCoords := initialCoords
    facingData := Direction(getDirection(),,,,)
    
    ;center player on the block they are standing on
    centerPlayer(initialCoords, stepTime, facingData)

    /* implements functions to complete the harvest, storage, and replanting process*/
    loop sections {
        loop passes {
            expectedCoords := pass(stepTime, rowLength, expectedCoords, facingData)
            centerPlayer(expectedCoords, stepTime, facingData)
            deposit(invCoords, boxSize)
            step(stepTime, "d", 1)
            updateSingleStep("d", expectedCoords, facingData)
        }
         step(stepTime, "d", 1)
         updateSingleStep("d", expectedCoords, facingData)
    }
    MsgBox "Harvest Complete OwO"
    ExitApp
}
