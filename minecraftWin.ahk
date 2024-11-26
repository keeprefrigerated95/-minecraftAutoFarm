#Requires AutoHotkey v2.0
#Include coordinates.ahk
#Include facing.ahk
CoordMode "Pixel", "Client"

/******************************************************
 * MINECRAFTWIN
 * A class which has data and methods in relation to the
 * window running Minecraft
 ******************************************************/

class MinecraftWin {
    
    xyz := Coordinates(5, 113, 0)
    facingCoords := Coordinates()
    crosshair := Coordinates(419, 260, 0)
    debugTextColor := "0xdddddd"
    menuTextColor := "0xfcfcfc"
    invTextColor := "0x3f3f3f"

    ; this method is called when a new instance is created 
    __New(windowName := "Minecraft") {
        this.windowName := windowName
        this.setUpWindow()

        ;finds the coordinates of "xyz:" on the debug screen
        endSearch := 0
        while (endSearch = 0)
        {
            if(this.readChar(this.xyz, this.debugTextColor) = "X")
            {
                endSearch := 1
            }
    
            else
            {
                this.xyz := Coordinates(this.xyz.x, this.xyz.y + 18, 0)
                this.facingCoords := Coordinates(this.xyz.x + 76, this.xyz.y + 54, 0)
            }
        } 
    }
    
    readChar(coordsToRead, textColor)
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
        upperCpixels := [0, 1, 1, 1, 0, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 1, 1, 0]
        upperEpixels := [1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1]
        upperIpixels := [1, 1, 1, 0, 2, 0, 1, 0, 0, 2, 0, 1, 0, 0, 2, 0, 1, 0, 0, 2, 0, 1, 0, 0, 2, 0, 1, 0, 0, 2, 1, 1, 1, 0, 2]
        upperLpixels := [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1]
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
                if (pixelColor = textColor)
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
        isUpperC := 1
        isUpperE := 1
        isUpperI := 1
        isUpperL := 1
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

            if(upperLPixels[arrayIndex] != pixelsRead[arrayIndex])
                isUpperL := 0

            if(upperMPixels[arrayIndex] != pixelsRead[arrayIndex])
                isUpperM := 0

            if(upperBpixels[arrayIndex] != pixelsRead[arrayIndex])
                isUpperB := 0

            if(upperCpixels[arrayIndex] != pixelsRead[arrayIndex])
                isUpperC := 0

            if(upperEpixels[arrayIndex] != pixelsRead[arrayIndex])
                isUpperE := 0

            if(upperIpixels[arrayIndex] != pixelsRead[arrayIndex] and upperIpixels[arrayIndex] != 2)
                isUpperI := 0

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

        if(isUpperC)
            output := "C"

        if(isUpperE)
            output := "E"

        if(isUpperI)
            output := "I"

        if(isUpperL)
            output := "L"

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
            if WinExist(this.windowName)
            {
                WinActivate
                WinMove 0, 0, 854, 560, this.windowName
                sleep 50
                exitLoop := 1
            }

            ;work with the user to find the minecraft window
            else
            {
                errorDecision := MsgBox(this.windowName " is not running or cannot be found. Run Minecraft and Try Again, or press Continue to do a manual search", "Error", "Iconx C/T/C")

                ;exits the script
                if (errorDecision = "Cancel")
                {
                    MsgBox "Auto Farm Script Ended"
                    ExitApp
                }

                ;tries to find the minecraft window againt
                else if (errorDecision = "Try Again")
                {
                    if WinExist(this.windowName)
                    {
                        WinActivate
                        WinMove 0, 0, 854, 560, this.windowName
                        sleep 50
                        exitLoop := 1
                    }
                }

                ;promps the use with every open window to find which is minecraft
                else if (errorDecision = "Continue")
                {
                    if (WinExist(this.windowName))
                    {
                        WinActivate
                        WinMove 0, 0, 854, 560, this.windowName
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
                                        this.windowName := WinGetTitle("ahk_id" openWindows[count])
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
        backToGameMods := Coordinates(355, 147)
        if(this.readChar(backToGame, this.menuTextColor) = "B" or this.readChar(backToGameMods, this.menuTextColor) = "B")
        {
            click backToGame.x, backToGame.y
            sleep 50
        }

        ;opens the debug screen
        debugMenu := Coordinates(5, 5, 0)
        if(this.readChar(debugMenu, this.debugTextColor) != "M")
        {
            send "{F3}"
            sleep 50
        }

        sleep 1000
        if(this.readChar(debugMenu, this.debugTextColor) != "M")
        {
            MsgBox "Unable to read the Minecraft Debug Screen!", "ERROR", "Iconx"
            ExitApp
        }
        OutputDebug "Window has been set up`n"
    }

    /****************************************************
    * GET COORDS 
    * A function that gets the coordinates from the minecraft
    * debug screen and saves them to global variables
    * XYZcoords: the coordinates of "XYZ:" on the minecraft debug screen
    *****************************************************/
    getCoords()
    { 
        topLeftCoords := Coordinates(this.xyz.x + 48, this.xyz.y, 0)
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

            ;the number that is to be added to the coordinates
            numToPush := this.readChar(topLeftCoords, this.debugTextColor)

            ;check to see if there is a decimal and adjst x coordinate to read the
            ;number, not the decimal
            goToNextCoord := 0 ;tells the loop to read the next coordinate, y or z, or leave the loop
            if (numToPush = ".")
            {
                topLeftCoords.x += 4
                numToPush := this.readChar(topLeftCoords, this.debugTextColor)
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

        OutputDebug "`n----------------`nGETCOORDS END`n"
        OutputDebug "output coordinates: " output.ToString() "`n----------------`n"
        return output
    }

    /*****************************************************
     * GET FACING
     * gets the data from the "Facing:" row
     *****************************************************/
    getFacing()
    {
        OutputDebug "`n---------------`nGET FACING`n"
        textWidth := 5
        textHeight := 7
        yawIsNegative := 1.0
        pitchIsNegative := 1.0
        yawValues := Array()
        pitchValues := Array()
        
        direction := Facing(this.readChar(this.facingCoords, this.debugTextColor))
        topLeftCoords := Coordinates()

        if(direction.cardinalDir = "n")
            topLeftCoords := Coordinates(this.facingCoords.x + 292, this.facingCoords.y, 0)
        
        else if(direction.cardinalDir = "s")
            topLeftCoords := Coordinates(this.facingCoords.x + 284, this.facingCoords.y, 0)

        else if(direction.cardinalDir = "e")
            topLeftCoords := Coordinates(this.facingCoords.x + 272, this.facingCoords.y, 0)

        else if(direction.cardinalDir = "w")
            topLeftCoords := Coordinates(this.facingCoords.x + 280, this.facingCoords.y, 0)
 
        else
        {
            MsgBox("Unable to read direction", "ERROR", "Iconx")
            ExitApp
        }

        OutputDebug "Facing: " direction.cardinalDir "`n"

        ;N 373  S 365  E 353  W 361

        /*quit loop 0 assigns the yaw
        1 assigns pitch, 2 quits the loop */
        quitLoop := 0
        while (quitLoop < 2)
        {

            ;the number that is to be added
            numToPush := this.readChar(topLeftCoords, this.debugTextColor)
            OutputDebug "numToPush: " numToPush "`n"
            ;check to see if there is a decimal and adjst x coordinate to read the
            ;number, not the decimal
            goToNextCoord := 0 ;tells the loop to 
            if (numToPush = ".")
            {
                topLeftCoords.x += 4
                numToPush := this.readChar(topLeftCoords, this.debugTextColor)
                goToNextCoord := 1
            }

            ;check if the coordinate is a negative symbol
            if (numToPush = "-")
            {
                if(quitLoop = 0)
                {
                    yawIsNegative := -1.0
                }
                
                if(quitLoop = 1)
                {
                    pitchIsNegative := -1.0
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
                        yawValues.Push(numToPush)
                    }

                    if(quitLoop = 1)
                    {
                        pitchValues.Push(numToPush)
                    }
                }
            }
            ;moves to the next number in the row
            if(goToNextCoord = 0)
            {
                topLeftCoords.x += 12
            }

            ;ends the loop
            if(goToNextCoord = 1 and quitLoop = 1)
            {
                quitLoop := quitLoop + 1
            }

            ;moves to the Pitch
            if(goToNextCoord = 1 and quitLoop = 0)
            {
                quitLoop := quitLoop + 1
                topLeftCoords.x += 40
            }
        }
        
        ;converts the arrays to floats and returns the coordinates
        yawIn := 0.0
        pitchIn := 0.0

        multiplier := 0.1
        xArrayLength := pitchValues.Length
        loop xArrayLength
        {
            yawIn := yawIn + (yawValues.Pop() * multiplier)
            multiplier := multiplier * 10.0
        }
        yawIn := yawIn * yawIsNegative

        multiplier := 0.1
        yArrayLength := pitchValues.Length
        loop yArrayLength
        {
            pitchIn := pitchIn + (pitchValues.Pop() * multiplier)
            multiplier := multiplier * 10.0
        }
        pitchIn := pitchIn * pitchIsNegative

        

        ;OutputDebug "`n----------------`nGETCOORDS END`n"
        OutputDebug "output facing`n" direction.ToString() "`n----------------`n"
       
        direction.yaw := yawIn
        direction.pitch := pitchIn

        return direction
    }
}
