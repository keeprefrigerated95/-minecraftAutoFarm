#Requires AutoHotkey v2.0
#Include minecraftWin.ahk
#Include coordinates.ahk
#Include facing.ahk

/******************************************************
 * PLAYER
 * A class with data and methods related to the minecraft
 * player
 ******************************************************/

class Player {
    
    settingsFile := "playerSettings.txt"

    __New(position := Coordinates(), direction := Facing(), minecraft := MinecraftWin(), sneakTime := 772, walkTime := 231) {
        
        this.position := position
        this.direction := direction
        this.minecraft := minecraft
        this.sneakTime := sneakTime ;time in milliseconds to walk one block while sneaking
        this.walkTime := walkTime ;time in milliseconds to walk one block
    }

    /*****************************************
     * SET GET COORDS
     * gets the currents coordinates form the minecraft screen
     * assigns it to the variable "position" and returns it
     *****************************************/
    setGetPosition()
    {
        this.position := this.minecraft.getCoords()
        return this.position
    }

    /******************************************
     * SET GET FACING
     * gets the current facing data and saves it 
     * to the "direction" variable and returns it
     *****************************************/
    setGetDirection()
    {
        this.direction := this.minecraft.getFacing()
        return this.direction
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

        Send "{Shift down}"
        sleep 100
        Send "{" key " down}"
        sleep timer * numSteps
        Send "{" key " up}"
        sleep 100
        Send "{Shift up}"
        sleep 100

        return
    }

    /*******************************************************
     * WALK
     * walks the player
     * timer: how long each step takes
     * key: the key that will be pressed, w, a, s, or d
     * numSteps: the number of steps that will be taken
     *******************************************************/
    walk(key, numSteps)
    {
        Send "{" key " down}"
        sleep this.walkTime * numSteps
        Send "{" key " up}"
        sleep 100
    }

    /**************************************************
    * MOVE TO
    * moves the player to the target coordinates
    * targetCoords: the target coordinates
    * this.sneakTime: time in miliseconds it takes to walk one block while sneaking
    * walkTimer: time in milliseconds it takes to walk one block
    * this.facing: info about which way the player is facing
    * xyzCoords: the coordinates of "XYZ: " on the minecraft debug screen
    **************************************************/
    moveTo(targetCoords)
    {
        ;sets the current coordinates
        this.position := this.minecraft.getCoords()
        currentCoordsCenter := this.position.centerCoordinates()
        arrived := 0

        OutputDebug "`n----------------`nCENTER PLAYER`nINPUT`n"
        OutputDebug "targetCoords: " targetCoords.ToString() "`ncurrentCoordinates: " this.position.ToString() "`n"
        OutputDebug "Direction: " this.direction.cardinalDir "`npositiveX: " this.direction.positiveX "`nnegativeX: " this.direction.negativeX "`npositiveZ: " this.direction.positiveZ "`nnegativeZ: " this.direction.negativeZ "`n"

        ;take the player to the correct coordinates
        while(arrived = 0)
        {
            this.centerOn()

            if(targetCoords.x > currentCoordsCenter.x)
            {
                this.walk(this.direction.positiveX, targetCoords.x - currentCoordsCenter.x)
                this.position := this.minecraft.getCoords()
                currentCoordsCenter := this.position.centerCoordinates()
            }
        
            else if(targetCoords.x < currentCoordsCenter.x)
            {
                this.walk(this.direction.negativeX, currentCoordsCenter.x - targetCoords.x)
                this.position := this.minecraft.getCoords()
                currentCoordsCenter := this.position.centerCoordinates()
            }
        
            if(targetCoords.z > currentCoordsCenter.z)
            {
                this.walk(this.direction.positiveZ, targetCoords.z - currentCoordsCenter.z)
                this.position := this.minecraft.getCoords()
                currentCoordsCenter := this.position.centerCoordinates()
            }
                
            else if(targetCoords.z < currentCoordsCenter.z)
            {
                this.walk(this.direction.negativeZ, currentCoordsCenter.z - targetCoords.z)
                this.position := this.minecraft.getCoords()
                currentCoordsCenter := this.position.centerCoordinates()
            }

            if(targetCoords.x = currentCoordsCenter.x and targetCoords.z = currentCoordsCenter.z)
            {
                arrived := 1
            }
        }

        this.centerOn()
        OutputDebug "Moved to coordinates`n-----------------------`n"
    }

    /***********************************************
     * CENTER ON
     * Centers the player as close to the center of the block
     * they are standing on as possible
     ***********************************************/
    centerOn()
    {
         ;sets the current coordinates
         this.position := this.minecraft.getCoords()

        ;centers the player on the block itself
        centered := 0
        roundedDown := Coordinates(Float(Integer(this.position.x)), Float(Integer(this.position.y)), Float(Integer(this.position.z)))
        
        while (centered = 0)
        {
            if(Abs(this.position.x - roundedDown.x) >= 0.3 and Abs(this.position.x - roundedDown.x) <= 0.7 and Abs(this.position.z - roundedDown.z) >= 0.3 and Abs(this.position.z - roundedDown.z) <= 0.7)
            {
                centered := 1
            }
        
            else if(this.position.x - roundedDown.x < 0.3 and this.position.x - 0.3 >= 0 or this.position.x - roundedDown.x < -0.7)
            {
                this.sneak(this.sneakTime / 8, this.direction.positiveX, 1)
                this.position := this.minecraft.getCoords()
            }
        
            else if(this.position.x - roundedDown.x > 0.7 or this.position.x - roundedDown.x > -0.3 and this.position.x - roundedDown.x <= 0)
            {
                this.sneak(this.sneakTime / 8, this.direction.negativeX, 1)
                this.position := this.minecraft.getCoords()
            }
        
            else if(this.position.z - roundedDown.z < 0.3 and this.position.z - 0.3 >= 0 or this.position.z - roundedDown.z < -0.7)
            {
                this.sneak(this.sneakTime / 8, this.direction.positiveZ, 1)
                this.position := this.minecraft.getCoords()
            }
        
            else if(this.position.z - roundedDown.z > 0.7 or this.position.z - roundedDown.z > -0.3 and this.position.z - roundedDown.z <= 0)
            {
                this.sneak(this.sneakTime / 8, this.direction.negativeZ, 1)
                this.position := this.minecraft.getCoords()
            }
        }
    }

    /***************************************************
     * DEPOSIT INV
     * Attemps to open a storage container and deposit
     * the entire inventory (excluding the hotbar)
     ***************************************************/
    depositInv()
    {
        ;the coordinates on the screen of the upper left inventory tile
        topLeftInv := Coordinates()

        ;attempt to open deposit container
        click "Right"
        sleep 1000

        containerOpened := 0
        while (containerOpened = 0)
        {
            ;find the correct coordinates depending on type of deposit container, if any
            charToRead := Coordinates(259, 105, 0)
            containerType := this.minecraft.readChar(charToRead, this.minecraft.invTextColor)
            if(containerType = "C" or containerType = "B" or containerType = "E")
            {
                ;set coords if a chest, barrel or ender chest
                topLeftInv := Coordinates(276, 270, 0)
                containerOpened := 1
            }

            charToRead := Coordinates(259, 51, 0)
            containerType := this.minecraft.readChar(charToRead, this.minecraft.invTextColor)
            if(containerType = "L")
            {
                ;set if it is a Large Chest
                topLeftInv := Coordinates(276, 323, 0)
                containerOpened := 1
            }

            charToRead := Coordinates(259, 141, 0)
            containerType := this.minecraft.readChar(charToRead, this.minecraft.invTextColor)
            if(containerType = "I")
            {
                ;set if it is a hopper
                topLeftInv := Coordinates(276, 237, 0)
                containerOpened := 1
            }

            if(containerOpened = 0)
            {
                OutputDebug "PAUSED`n"
                Pause -1
                result := MsgBox("Failed to open deposit conainer. Open the container manually and press Retry or press Cancel to end the script.", "ERROR", "RetryCancel IconX")
                if (result = "Retry")
                {
                    OutputDebug "UNPAUSED`n"
                    Pause -1
                }
            
                else
                {
                    Send "{Shift up}"
                    MsgBox "Script Cancelled"
                    ExitApp
                }
            }
        }

        ;deposits items into the chest
        cursorCoords := Coordinates(topLeftInv.x, topLeftInv.y, 0)
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
                cursorCoords.x += 35
            }
            cursorCoords := Coordinates(topLeftInv.x, cursorCoords.y + 35, 0)
        }
        Send "{Escape}"
        sleep 1000
    }

    /*********************************************
     * LOAD FROM FILE
     *  loads custom settings from the playerSettings.txt
     ********************************************/
    loadFromFile()
    {
        Loop read, this.settingsFile
        {
            if InStr(A_LoopReadLine, "sneakTime")
            {
                Loop parse, A_LoopReadLine, ":"
                {
                    this.sneakTime := A_LoopField
                }
            }
        
            if InStr(A_LoopReadLine, "walkTime")
            {
                Loop parse, A_LoopReadLine, ":"
                {
                    this.walkTime := A_LoopField
                }
            }
        }
    }

}