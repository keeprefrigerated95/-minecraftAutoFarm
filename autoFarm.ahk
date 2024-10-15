/**********************************************
 * ~~~ AUTO FARM ~~~
 * A script that harvests and replants fields in minecraft
 **********************************************/

#Include coordinates.ahk
#Include direction.ahk
#Include settings.ahk

CoordMode "Pixel", "Client"

FARMSETTINGS := Settings()
try
    FARMSETTINGS.loadFromFile("autoFarmSettings.txt")
catch
{
    MsgBox "autoFarmSettings.txt not found!", "Error", "Iconx"
    ExitApp
}

/* ***********************************************
 * sneak
 * moves player while sneaking aka crouching
 * timer: how many milliseconds the script will press
 * a certain key for
 * key: the key that will be pressed w, a, s or d
 * numSteps: the number of steps that will be taken
 **************************************************/
sneak(timer, key, numSteps)
{
    ;OutputDebug "`n------------`nSTEP`nINPUT`n"
    ;OutputDebug "timer: " timer "`n"
    ;OutputDebug "key: " key "`n"
    ;OutputDebug "numSteps: " numSteps "`n----------------`n"

    if(numSteps < 1)
    {
        numSteps := 1
    }

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

/*******************************************************
 * WALK
 * walks the player
 * timer: how long each step takes
 * key: the key that will be pressed, w, a, s, or d
 * numSteps: the number of steps that will be taken
 *******************************************************/
walk(timer, key, numSteps)
{
    Send "{" key " down}"
    sleep timer * numSteps
    Send "{" key " up}"
    sleep 100
}

/*******************************************************
 * READ SCREEN
 * returns a single characher from the minecraft debug screen
 * coordsToRead: the coordinates of the charachter to be read
 ******************************************************/
readScreen(coordsToRead)
{
    ;OutputDebug "READSCREEN`ncoordsToRead: " coordsToRead.ToString() "`n"

    ;arrays of the pixels in various letters and numbers
    ;0 is no pixel, 1 is a lit pixel, 2 can be either lit or until  
    zeroPixels := [0, 1, 1, 1, 0, 1, 0, 0, 0, 1, 1, 0, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 1, 0, 1, 1, 1, 0]
    onePixels := [0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1, 1, 1, 1, 1]
    twoPixels := [0, 1, 1, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1]
    threePixels := [0, 1, 1, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 1, 1, 1, 0]
    fourPixels := [0, 0, 0, 1, 1, 0, 0, 1, 0, 1, 0, 1, 0, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1]
    fivePixels := [1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 1, 1, 1, 0]
    sixPixels := [0, 0, 1, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 1, 1, 1, 0]
    sevenPixels := [1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0]
    eightPixels := [0, 1, 1, 1, 0, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 1, 1, 1, 0, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 1, 1, 1, 0]
    ninePixels := [0, 1, 1, 1, 0, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 0, 1, 1, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 1, 0, 0]
    upperBpixels := [1, 1, 1, 1, 0, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0]
    upperMPixels := [1, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1]
    upperXpixels := [1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1]
    lowerEPixels := [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1]
    lowerNPixels := [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1]
    lowerSPixels := [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0]
    lowerWPixels := [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1]
    periodPixels := [0, 0, 2, 2, 2, 0, 0, 2, 2, 2, 0, 0, 2, 2, 2, 0, 0, 2, 2, 2, 0, 0, 2, 2, 2, 0, 0, 2, 2, 2, 1, 0, 2, 2, 2]
    minusSignPixels := [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

    ;an array of the pixels read from the screen
    pixelsRead := []

    pixelToRead := Coordinates(coordsToRead.x, coordsToRead.y, 0)

    ;gets the columns of pixels
    loop 7
    {
        ;gets the rows of pixels
        loop 5
        {
            pixelColor := PixelGetColor(pixelToRead.x, pixelToRead.y)
            if (pixelColor = "0xdddddd" or pixelColor = "0xfcfcfc")
            {
                pixelsRead.Push(1)
            }

            else
            {
                pixelsRead.Push(0)
            }
 
            pixelToRead.x += 2
        }
        pixelToRead.y += 2
        pixelToRead.x := coordsToRead.x
    }

    ;compares the array of pixels read with each of the arrays to determine the output
    isZero := 1
    isOne := 1
    isTwo := 1
    isThree := 1
    isFour := 1
    isFive := 1
    isSix := 1
    isSeven := 1
    isEight := 1
    isNine := 1
    isUpperB := 1
    isUpperM := 1
    isUpperX := 1
    isLowerE := 1
    isLowerN := 1
    isLowerS := 1
    isLowerW := 1
    arrayIndex := 1
    isPeriod := 1
    isMinusSign := 1
    loop pixelsRead.Length
    {
        if(zeroPixels[arrayIndex] != pixelsRead[arrayIndex])
            isZero := 0

        if(onePixels[arrayIndex] != pixelsRead[arrayIndex])
            isOne := 0

        if(twoPixels[arrayIndex] != pixelsRead[arrayIndex])
            isTwo := 0

        if(threePixels[arrayIndex] != pixelsRead[arrayIndex])
            isThree := 0

        if(fourPixels[arrayIndex] != pixelsRead[arrayIndex])
            isFour := 0

        if(fivePixels[arrayIndex] != pixelsRead[arrayIndex])
            isFive := 0

        if(sixPixels[arrayIndex] != pixelsRead[arrayIndex])
            isSix := 0

        if(sevenPixels[arrayIndex] != pixelsRead[arrayIndex])
            isSeven := 0

        if(eightPixels[arrayIndex] != pixelsRead[arrayIndex])
            isEight := 0

        if(ninePixels[arrayIndex] != pixelsRead[arrayIndex])
            isNine := 0

        if(upperMPixels[arrayIndex] != pixelsRead[arrayIndex])
            isUpperM := 0

        if(upperBpixels[arrayIndex] != pixelsRead[arrayIndex])
            isUpperB := 0

        if(upperXpixels[arrayIndex] != pixelsRead[arrayIndex])
            isUpperX := 0

        if(lowerEPixels[arrayIndex] != pixelsRead[arrayIndex])
            isLowerE := 0

        if(lowerNPixels[arrayIndex] != pixelsRead[arrayIndex])
            isLowerN := 0

        if(lowerSPixels[arrayIndex] != pixelsRead[arrayIndex])
            isLowerS := 0

        if(lowerWPixels[arrayIndex] != pixelsRead[arrayIndex])
            isLowerW := 0

        if(periodPixels[arrayIndex] != pixelsRead[arrayIndex] and periodPixels[arrayIndex] != 2)
            isPeriod := 0

        if(minusSignPixels[arrayIndex] != pixelsRead[arrayIndex])
            isMinusSign := 0

        arrayIndex += 1
    }

    output := "no text found"
    if(isZero)
        output := 0

    if(isOne)
        output := 1

    if(isTwo)
        output := 2

    if(isThree)
        output := 3

    if(isFour)
        output := 4

    if(isFive)
        output := 5

    if(isSix)
        output := 6

    if(isSeven)
        output := 7

    if(isEight)
        output := 8

    if(isNine)
        output := 9

    if(isUpperX)
        output := "X"

    if(isUpperB)
        output := "B"

    if(isUpperM)
        output := "M"

    if(isLowerE)
        output := "e"

    if(isLowerN)
        output := "n"

    if(isLowerS)
        output := "s"

    if(isLowerW)
        output := "w"

    if(isPeriod)
        output := "."

    if(isMinusSign)
        output := "-"

    ;OutputDebug "output: " output "`n`n"
    return output
}
/*******************************************************
 * FIND XYZ
 * Returns the coordinates of XYZ: on the minecraft debug screen
 ********************************************************/
findXYZ()
{
    outputCoords := Coordinates()
    searchStart := Coordinates(5, 113, 0)
    endSearch := 0
    while (endSearch = 0)
    {
        if(readScreen(searchStart) = "X")
        {
            outputCoords := searchStart
            endSearch := 1
        }

        else
        {
            searchStart := Coordinates(searchStart.x, searchStart.y + 18, 0)
        }
    }

    return outputCoords
}

/****************************************************
* GET COORDS 
* A function that gets the coordinates from the minecraft
* debug screen and saves them to global variables
* XYZcoords: the coordinates of "XYZ:" on the minecraft debug screen
*****************************************************/
getCoords(XYZcoords)
{ 
    topLeftCoords := Coordinates(XYZcoords.x + 48, XYZcoords.y, 0)
    textWidth := 5
    textHeight := 7
    xIsNegative := 1.0
    yIsNegative := 1.0
    zIsNegative := 1.0
    xValues := Array()
    yValues := Array()
    zValues := Array()

    ;OutputDebug "`n----------------`nGET COORDS START`n"
    ;OutputDebug "topLeftCoords: " topLeftCoords.ToString() "`n----------------`n"

    /*quit loop 0 assigns the x value
      1 assigns y, 2 assigns z, 3 quits the loop */
    quitLoop := 0
    while (quitLoop < 3)
    {

        ;the number that is to be added to the coordinates
        numToPush := readScreen(topLeftCoords)

        ;check to see if there is a decimal and adjst x coordinate to read the
        ;number, not the decimal
        goToNextCoord := 0 ;tells the loop to read the next coordinate, y or z, or leave the loop
        if (numToPush = ".")
        {
            topLeftCoords.x += 4
            numToPush := readScreen(topLeftCoords)
            goToNextCoord := 1
        }

        ;check if the coordinate is a negative symbol
        if (numToPush = "-")
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
            ;pushes the number that was read to the appropriate array
            if (numToPush != "no text found")
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
        if(goToNextCoord = 0)
        {
            topLeftCoords.x += 12
        }

        ;ends the loop
        if(goToNextCoord = 1 and quitLoop = 2)
        {
            quitLoop := quitLoop + 1
        }

        ;moves to the Z coordinate
        if(goToNextCoord = 1 and quitLoop = 1)
        {
            quitLoop := quitLoop + 1
            topLeftCoords.x += 88
        }

        ;moves to the Y coordinate
        if(goToNextCoord = 1 and quitLoop = 0)
        {
            quitLoop := quitLoop + 1
            topLeftCoords.x += 64
        }
    }
    
    ;converts the arrays to floats and returns the coordinates
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

    ;OutputDebug "`n----------------`nGETCOORDS END`n"
    ;OutputDebug "output coordinates: " output.ToString() "`n----------------`n"
    return output
}

/***************************************************
 * CENTER COORDINATES
 * gives the exact center coordinates of the block that
 * is given, rounds to 0.5
 * inputCoords: the coordinates that need to be rounded to 0.5
 ****************************************************/
centerCoordinates(inputCoords)
{
    ;OutputDebug "`n-----------------`nCENTER COORDINATES`ninputCoords: " inputCoords.ToString() "`n"

    outputCoords := Coordinates()
    roundedX := 0.0
    roundedY := 0.0
    roundedZ := 0.0

    
    if(inputCoords.x < 0)
    {
        roundedX := Float(Integer(inputCoords.x))
        centeredX := roundedX - 0.5
    }
    
   
    if(inputCoords.x >= 0.0)
    {
        roundedX := Float(Integer(inputCoords.x))
        centeredX := roundedX + 0.5
    }

    if(inputCoords.y < 0.0)
    {
        roundedY := Float(Integer(inputCoords.y))
        centeredY := roundedY - 0.5
    }
    
    if(inputCoords.y >= 0.0)
    {
        roundedY := Float(Integer(inputCoords.y))
        centeredY := roundedY + 0.5
    }

    if(inputCoords.z < 0.0)
    {
        roundedZ := Float(Integer(inputCoords.z))
        centeredZ := roundedZ - 0.5
    }
        
    if(inputCoords.z >= 0.0)
    {
        roundedZ := Float(Integer(inputCoords.z))
        centeredZ := roundedZ + 0.5
    }

    outputCoords := Coordinates(centeredX, centeredY, centeredZ)

    ;OutputDebug "outputCoords: " outputCoords.ToString() "`ninputCoords" inputCoords.ToString() "`n-------------------`n"

    return outputCoords
}

/**************************************************
* CENTER PLAYER 
* centers the player on the target coordinates
* targetCoords: the target coordinates
* sneakTimer: time in miliseconds it takes to walk one block while sneaking
* walkTimer: time in milliseconds it takes to walk one block
* facingData: info about which way the player is facing
* xyzCoords: the coordinates of "XYZ: " on the minecraft debug screen
**************************************************/
centerPlayer(targetCoords, sneakTimer, walkTimer, facingData, xyzCoords)
{

    ;sets the current coordinates
    currentCoords := getCoords(xyzCoords)
    currentCoordsCenter := centerCoordinates(currentCoords)
    targetCoords := centerCoordinates(targetCoords)
    centered := 0
    zIsCentered := 0
    xIsCentered := 0

    ;OutputDebug "`n----------------`nCENTER PLAYER`nINPUT`n"
    ;OutputDebug "targetCoords: " targetCoords.ToString() "`ncurrentCoordinates: " currentCoords.ToString() "`n"
    ;OutputDebug "Direction: " facingData.cardinalDir "`npositiveX: " facingData.positiveX "`nnegativeX: " facingData.negativeX "`npositiveZ: " facingData.positiveZ "`nnegativeZ: " facingData.negativeZ "`n"

    ;take the player to the correct coordinates
    while(centered = 0)
    {
        if(targetCoords.x > currentCoordsCenter.x)
        {
            walk(walkTimer, facingData.positiveX, targetCoords.x - currentCoordsCenter.x)
            currentCoords := getCoords(xyzCoords)
            currentCoordsCenter := centerCoordinates(currentCoords)
        }
    
        else if(targetCoords.x < currentCoordsCenter.x)
        {
            walk(walkTimer, facingData.negativeX, currentCoordsCenter.x - targetCoords.x)
            currentCoords := getCoords(xyzCoords)
            currentCoordsCenter := centerCoordinates(currentCoords)
        }
    
        if(targetCoords.z > currentCoordsCenter.z)
        {
            walk(walkTimer, facingData.positiveZ, targetCoords.z - currentCoordsCenter.z)
            currentCoords := getCoords(xyzCoords)
            currentCoordsCenter := centerCoordinates(currentCoords)
        }
            
        else if(targetCoords.z < currentCoordsCenter.z)
        {
            walk(walkTimer, facingData.negativeZ, currentCoordsCenter.z - targetCoords.z)
            currentCoords := getCoords(xyzCoords)
            currentCoordsCenter := centerCoordinates(currentCoords)
        }

        if(targetCoords.x = currentCoordsCenter.x and targetCoords.z = currentCoordsCenter.z)
        {
            centered := 1
        }
    }
    
    ;OutputDebug "Arrived at block`n"
    
    ;centers the player on the block itself
    centered := 0
    roundedDown := Coordinates(Float(Integer(currentCoords.x)), Float(Integer(currentCoords.y)), Float(Integer(currentCoords.z)))
    
    ;OutputDebug "centering on block`nroundedDown: " roundedDown.ToString() "`n"
    
    while (centered = 0)
    {
        if(Abs(currentCoords.x - roundedDown.x) >= 0.3 and Abs(currentCoords.x - roundedDown.x) <= 0.7 and Abs(currentCoords.z - roundedDown.z) >= 0.3 and Abs(currentCoords.z - roundedDown.z) <= 0.7)
        {
            centered := 1
        }
    
        else if(currentCoords.x - roundedDown.x < 0.3 and currentCoords.x - 0.3 >= 0 or currentCoords.x - roundedDown.x < -0.7)
        {
            sneak(sneakTimer / 8, facingData.positiveX, 1)
            currentCoords := getCoords(xyzCoords)
        }
    
        else if(currentCoords.x - roundedDown.x > 0.7 or currentCoords.x - roundedDown.x > -0.3 and currentCoords.x - roundedDown.x <= 0)
        {
            sneak(sneakTimer / 8, facingData.negativeX, 1)
            currentCoords := getCoords(xyzCoords)
        }
    
        else if(currentCoords.z - roundedDown.z < 0.3 and currentCoords.z - 0.3 >= 0 or currentCoords.z - roundedDown.z < -0.7)
        {
            sneak(sneakTimer / 8, facingData.positiveZ, 1)
            currentCoords := getCoords(xyzCoords)
        }
    
        else if(currentCoords.z - roundedDown.z > 0.7 or currentCoords.z - roundedDown.z > -0.3 and currentCoords.z - roundedDown.z <= 0)
        {
            sneak(sneakTimer / 8, facingData.negativeZ, 1)
            currentCoords := getCoords(xyzCoords)
        }
    }
    ;OutputDebug "Centered on Block`n-----------------------`n"
}
    
    
/*********************************************************
* GET NEXT ROW
* returns the coordinates of the row directly to the right of the player
* currentRow: the coordinates of the current row
* facingData: info about which way the player is facing
**********************************************************/
getNextRow(currentRow, facingData)
{
    nextRow := Coordinates()
    
    ;OutputDebug "`n---------------`nGETNEXTROW`nCurrent Row: " currentRow.ToString() "`nFacing: " facingData.cardinalDir "`n"
     
    if(facingData.cardinalDir = "n")
    {
        nextRow := Coordinates(currentRow.x + 1, currentRow.y, currentRow.z)
    }
    
    if(facingData.cardinalDir = "s")
    {
        nextRow := Coordinates(currentRow.x - 1, currentRow.y, currentRow.z)
    }
    
    if(facingData.cardinalDir = "e")
    {
        nextRow := Coordinates(currentRow.x, currentRow.y, currentRow.z + 1)
    }
    
    if(facingData.cardinalDir = "w")
    {
        nextRow := Coordinates(currentRow.x, currentRow.y, currentRow.z - 1)
    }
    
    ;OutputDebug "nextRowCoords: " nextRow.ToString() "`n------------------`n"
    return centerCoordinates(nextRow)
}
 
/**********************************************************
 * Resizes the minecraft window, exits the menu if opened
 * and makes sure the debug screen is opened
 **********************************************************/
setUpWindow()
{
    ;searches for the Minecraft window and resizes it
    exitLoop := 0
    while(exitLoop = 0)
    {
        ;if the window saved in settings exist set it up normally
        if WinExist(FARMSETTINGS.windowName)
        {
            WinActivate
            WinMove 0, 0, 854, 560, FARMSETTINGS.windowName
            sleep 50
            exitLoop := 1
        }

        ;work with the user to find the minecraft window
        else
        {
            errorDecision := MsgBox(FARMSETTINGS.windowName " is not running or cannot be found. Run Minecraft and Try Again, or press Continue to do a manual search", "Error", "Iconx C/T/C")

            ;exits the script
            if (errorDecision = "Cancel")
            {
                MsgBox "Auto Farm Script Ended"
                ExitApp
            }

            ;tries to find the minecraft window againt
            else if (errorDecision = "Try Again")
            {
                if WinExist(FARMSETTINGS.windowName)
                {
                    WinActivate
                    WinMove 0, 0, 854, 560, FARMSETTINGS.windowName
                    sleep 50
                    exitLoop := 1
                }
            }

            ;promps the use with every open window to find which is minecraft
            else if (errorDecision = "Continue")
            {
                if (WinExist(FARMSETTINGS.windowName))
                {
                    WinActivate
                    WinMove 0, 0, 854, 560, FARMSETTINGS.windowName
                    sleep 50
                    exitLoop := 1
                }

                else
                {
                    openWindows := WinGetList()
                    count := 1
                    loop openWindows.Length
                    {
                        if (WinExist("ahk_id" openWindows[count]))
                        {
                            isMinecraft := MsgBox("Is this Minecraft? - " WinGetTitle("ahk_id" openWindows[count]), "Manual Search", "YesNo Icon?")

                            if(isMinecraft = "Yes")
                            {
                                if WinExist(WinGetTitle("ahk_id" openWindows[count]))
                                {
                                    WinActivate
                                    WinMove 0, 0, 854, 560, WinGetTitle("ahk_id" openWindows[count])
                                    sleep 50
                                    FARMSETTINGS.windowName := WinGetTitle("ahk_id" openWindows[count])
                                    exitLoop := 1
                                    break
                                }
                            }
                        }
                        count += 1
                    }
                }
            }
        }
    }

    ;checks to see if the menu needs to be closed or not
    backToGame := Coordinates(355, 159, 0)
    if(readScreen(backToGame) = "B")
    {
        click backToGame.x, backToGame.y
        sleep 50
    }

    ;opens the debug screen
    debugMenu := Coordinates(5, 5, 0)
    if(readScreen(debugMenu) != "M")
    {
        send "{F3}"
        sleep 50
    }

    sleep 1000
    if(readScreen(debugMenu) != "M")
    {
        MsgBox "Unable to read the Minecraft Debug Screen!", "ERROR", "Iconx"
        ExitApp
    }
}
    
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

*p::
{
    OutputDebug "PAUSED`n"
    Pause -1
    result := MsgBox("Would you like to continue? If you cancel, you will have to start the script over.", "Paused", "YesNo")
    if (result = "Yes")
    {
        OutputDebug "UNPAUSED`n"
        setUpWindow()
        Pause -1
    }

    else
    {
        Send "{Shift up}"
        MsgBox "Script Cancelled"
        ExitApp
    }
}

result := MsgBox("Welcome to Keep Refrigerated's Automatic Minecraft Farm Bot!`n`nInstructions:`nPosition your player on the starting block then press OK. Make sure you are facing towards the end of the first row.`n`nPress P to pause the script at any time`nPress X to cancel the script`n`nFor more information, refer to the README", "Welcome!", "OKCancel")

if(result = "Cancel")
{
    ExitApp
}

setUpWindow()

xyzCoords := findXYZ() ;coordinates of XYZ: the top left of the second paragraph of the minecraft debug menu
initialCoords := centerCoordinates(getCoords(xyzCoords)) ;coordinates where the player starts
;initialCoords := getCoords(xyzCoords)
OutputDebug "INITIAL COORDS: " initialCoords.ToString() "`n"

;sets up the facing data variable
facingData := Direction(,,,,)
coordsOnDebug := Coordinates(xyzCoords.x + 76, xyzCoords.y + 54, 0)
nseOrw := readScreen(coordsOnDebug)
OutputDebug ("Direction: " nseOrw)
facingData.setDirection(nseOrw)

OutputDebug "variables set`n"

/*completes the harvest, storage, and replanting process for all layers*/
loop FARMSETTINGS.layers
{
    ;center player on the initial coordinates
    centerPlayer(initialCoords, FARMSETTINGS.sneakTime, FARMSETTINGS.walkTime, facingData, xyzCoords)
    OutputDebug "Player centered on initial coordinates:" initialCoords.ToString() "`n"

    currentRowCoords := initialCoords ;coordinates of the row currently being harvested
    nextRowCoords := getNextRow(currentRowCoords, facingData)

    sectionsCount := 0
    rowCount := 0
    
    ;harvests and deposits an enire layer
    loop FARMSETTINGS.sectionsPerLayer {
        sectionsCount += 1
        rowCount := 0
        OutputDebug "starting section " sectionsCount "`n"
        
        ;harvests and deposits a single section
        loop FARMSETTINGS.rowsPerSection
        {
            rowCount += 1

            OutputDebug "harvesting row " rowCount "`n"
            ;harvests one row
            loop FARMSETTINGS.rowLength
            {
                sneak(FARMSETTINGS.sneakTime, "w", 1)
                click "Left"
                sleep 200
                click "Right"
                sleep 200
            }
            
            OutputDebug "row " rowCount " harvested`n"

            ;if on the last row of the section, deposit in the chest on the current row
            if(rowCount = FARMSETTINGS.rowsPerSection)
            {
                OutputDebug "going to current row`n"
                centerPlayer(currentRowCoords, FARMSETTINGS.sneakTime, FARMSETTINGS.walkTime, facingData, xyzCoords)
            }

            ;send to next row to deposit, don't need to get coordinates as often this way
            else
            {
                OutputDebug "going to next row: " nextRowCoords.ToString() "`n"
                centerPlayer(nextRowCoords, FARMSETTINGS.sneakTime, FARMSETTINGS.walkTime, facingData, xyzCoords)
            }
            
            ;deposits items into the chest
            OutputDebug "depositing items`n"
            click "Right"
            sleep 1000
            cursorCoords := Coordinates(FARMSETTINGS.topLeftInv.x, FARMSETTINGS.topLeftInv.y, FARMSETTINGS.topLeftInv.z)
            loop 3
            {
                loop 9
                {
                    Send "{Shift down}"
                    sleep 200
                    click cursorCoords.x, cursorCoords.y
                    sleep 200
                    Send "{Shift up}"
                    sleep 200
                    cursorCoords.x += FARMSETTINGS.boxSize
                }
                cursorCoords := Coordinates(FARMSETTINGS.topLeftInv.x, cursorCoords.y + FARMSETTINGS.boxSize, 0)
            }
            Send "{Escape}"
            sleep 1000
            OutputDebug "items deposited`n"
        
            ;moves the current row over one block to the right
            currentRowCoords := getNextRow(currentRowCoords, facingData)
            nextRowCoords := getNextRow(currentRowCoords, facingData)
        }
        ;moves the current row over one block to the right, moves player to next section
        currentRowCoords := getNextRow(currentRowCoords, facingData)
        nextRowCoords := getNextRow(currentRowCoords, facingData) 
        centerPlayer(currentRowCoords, FARMSETTINGS.sneakTime, FARMSETTINGS.walkTime, facingData, xyzCoords)
    }
    ;sets the current row to the stairwell and moves there
    currentRowCoords := getNextRow(currentRowCoords, facingData)
    nextRowCoords := getNextRow(currentRowCoords, facingData)
    centerPlayer(currentRowCoords, FARMSETTINGS.sneakTime, FARMSETTINGS.walkTime, facingData, xyzCoords)
    walk(FARMSETTINGS.walkTime, "w", 6)
    walk(FARMSETTINGS.walkTime, "d", 2)
    walk(FARMSETTINGS.walkTime, "s", 6)
}
MsgBox "Harvest Complete OwO"
ExitApp
