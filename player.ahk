#Requires AutoHotkey v2.0
#Include minecraftWin.ahk
#Include coordinates.ahk
#Include facing.ahk
#Include logger.ahk
playerLogger := Logger("player.ahk")
CoordMode "Pixel", "Client"
/******************************************************
 * PLAYER
 * A class with data and methods related to the minecraft
 * player
 ******************************************************/

class Player
{
    settingsFile := "settings.txt"
    sneakTime := 772
    walkTime := 231
    minecraft := MinecraftWin()
    position := this.minecraft.getCoords() ;current coordinates
    direction := this.minecraft.getFacing() ;get current facing data

    __New()
    {
        this.loadFromFile() ;load vars from settings
        playerLogger.sendLog("player.ahk\Player\New\ New Player created")
    }

    /*****************************************
     * SET GET COORDS
     * gets the currents coordinates form the minecraft screen
     * assigns it to the variable "position" and returns it
     *****************************************/
    setGetPosition()
    {
        this.position := this.minecraft.getCoords()
        playerLogger.sendLog("player.ahk\Player\setGetPosition\ Position updated to: " this.position.ToString())
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
        playerLogger.sendLog("player.ahk\Player\setGetDirection\ Direction updated to: " this.direction.ToString())
        return this.direction
    }

    /*************************************************
    * sneak
    * moves player while sneaking aka crouching
    * timer: how many milliseconds the script will press
    * a certain key for
    * key: the key that will be pressed w, a, s or d
    * numSteps: the number of steps that will be taken
    **************************************************/
    sneak(timer, key, numSteps)
    {
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

        playerLogger.sendLog("player.ahk\Player\sneak\ Sneaked " numSteps " steps, pressing '" key "' at " timer " milliseconds each")

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

        playerLogger.sendLog("player.ahk\Player\walk\ Walked " numSteps " steps, pressing '" key "'")
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
        playerLogger.sendLog("player.ahk\Player\moveTo\ Moving player to " targetCoords.ToString())
        this.centerOn()
        currentCoordsCenter := this.position.centerCoordinates() ;the coordinates of the center of the target block, 0.5 mark
        targetCoordsCenter := targetCoords.centerCoordinates() ;center of the target coordinates block 0.5
        arrived := 0

        ;take the player to the correct coordinates
        if(targetCoordsCenter.x != currentCoordsCenter.x or targetCoordsCenter.z != currentCoordsCenter.z)
        { 
            while(arrived = 0)
            {
                if(targetCoords.x = currentCoordsCenter.x and targetCoords.z = currentCoordsCenter.z)
                {
                    this.centerOn()
                    arrived := 1
                }

                else if(targetCoords.x > currentCoordsCenter.x)
                {
                    this.walk(this.direction.positiveX, targetCoords.x - currentCoordsCenter.x)
                    this.centerOn()
                    currentCoordsCenter := this.position.centerCoordinates()
                }
            
                else if(targetCoords.x < currentCoordsCenter.x)
                {
                    this.walk(this.direction.negativeX, currentCoordsCenter.x - targetCoords.x)
                    this.centerOn()
                    currentCoordsCenter := this.position.centerCoordinates()
                }
            
                if(targetCoords.z > currentCoordsCenter.z)
                {
                    this.walk(this.direction.positiveZ, targetCoords.z - currentCoordsCenter.z)
                    this.centerOn()
                    currentCoordsCenter := this.position.centerCoordinates()
                }
                    
                else if(targetCoords.z < currentCoordsCenter.z)
                {
                    this.walk(this.direction.negativeZ, currentCoordsCenter.z - targetCoords.z)
                    this.centerOn()
                    currentCoordsCenter := this.position.centerCoordinates()
                }
            }
        }

        playerLogger.sendLog("player.ahk\Player\moveTo\ Moved player to " this.position.ToString())
    }

    /***********************************************
     * CENTER ON
     * Centers the player as close to the center of the block
     * they are standing on as possible
     ***********************************************/
    centerOn()
    {
        playerLogger.sendLog("player.ahk\Player\centerOn\ Centering player on coordinates " this.position.ToString())
         ;sets the current coordinates
         this.position := this.minecraft.getCoords()

        ;centers the player on the block itself
        centered := 0
        roundedDown := Coordinates(Float(Integer(this.position.x)), Float(Integer(this.position.y)), Float(Integer(this.position.z)))

        while (centered = 0)
        {
            if(Abs(this.position.x - roundedDown.x) >= 0.4 and Abs(this.position.x - roundedDown.x) <= 0.6 and Abs(this.position.z - roundedDown.z) >= 0.4 and Abs(this.position.z - roundedDown.z) <= 0.6)
            {
                centered := 1
            }

            else
            {
                ;move in a positive direction on the X axis
                if(this.position.x - roundedDown.x >= 0 and this.position.x - roundedDown.x < 0.1 or this.position.x - roundedDown.x < -0.9)
                {
                    this.sneak(this.sneakTime / 2, this.direction.positiveX, 1)
                    this.position := this.minecraft.getCoords()
                }
            
                else if(this.position.x - roundedDown.x >= 0.1 and this.position.x - roundedDown.x < 0.2 or this.position.x - roundedDown.x >= -0.9 and this.position.x - roundedDown.x < -0.8)
                {
                    this.sneak(this.sneakTime / 4, this.direction.positiveX, 1)
                    this.position := this.minecraft.getCoords()
                }

                else if(this.position.x - roundedDown.x >= 0.2 and this.position.x - roundedDown.x < 0.3 or this.position.x - roundedDown.x >= -0.8 and this.position.x - roundedDown.x < -0.7)
                {
                    this.sneak(this.sneakTime / 8, this.direction.positiveX, 1)
                    this.position := this.minecraft.getCoords()
                }

                else if(this.position.x - roundedDown.x >= 0.3 and this.position.x - roundedDown.x < 0.4 or this.position.x - roundedDown.x >= -0.7 and this.position.x - roundedDown.x < -0.6)
                {
                    this.sneak(this.sneakTime / 16, this.direction.positiveX, 1)
                    this.position := this.minecraft.getCoords()
                }

                ;move in a negative direction on the X axis
                else if(this.position.x - roundedDown.x > 0.9 or this.position.x - roundedDown.x <= 0 and this.position.x - roundedDown.x > -0.1 )
                {
                    this.sneak(this.sneakTime / 2, this.direction.negativeX, 1)
                    this.position := this.minecraft.getCoords()
                }
                
                else if(this.position.x - roundedDown.x > 0.8 and this.position.x - roundedDown.x <= 0.9 or this.position.x - roundedDown.x > -0.2 and this.position.x - roundedDown.x <= -0.1)
                {
                    this.sneak(this.sneakTime / 4, this.direction.negativeX, 1)
                    this.position := this.minecraft.getCoords()
                }

                else if(this.position.x - roundedDown.x > 0.7 and this.position.x - roundedDown.x <= 0.8 or this.position.x - roundedDown.x > -0.3 and this.position.x - roundedDown.x <= -0.2)
                {
                    this.sneak(this.sneakTime / 8, this.direction.negativeX, 1)
                    this.position := this.minecraft.getCoords()
                }
                
                else if(this.position.x - roundedDown.x > 0.6 and this.position.x - roundedDown.x <= 0.7 or this.position.x - roundedDown.x > -0.4 and this.position.x - roundedDown.x <= -0.3)
                {
                    this.sneak(this.sneakTime / 16, this.direction.negativeX, 1)
                    this.position := this.minecraft.getCoords()
                }

                ;move in a positive direction on the Z axis
                if(this.position.z - roundedDown.z >= 0 and this.position.z - roundedDown.z < 0.1 or this.position.z - roundedDown.z < -0.9)
                {
                    this.sneak(this.sneakTime / 2, this.direction.positiveZ, 1)
                    this.position := this.minecraft.getCoords()
                }
            
                else if(this.position.z - roundedDown.z >= 0.1 and this.position.z - roundedDown.z < 0.2 or this.position.z - roundedDown.z >= -0.9 and this.position.z - roundedDown.z < -0.8)
                {
                    this.sneak(this.sneakTime / 4, this.direction.positiveZ, 1)
                    this.position := this.minecraft.getCoords()
                }

                else if(this.position.z - roundedDown.z >= 0.2 and this.position.z - roundedDown.z < 0.3 or this.position.z - roundedDown.z >= -0.8 and this.position.z - roundedDown.z < -0.7)
                {
                    this.sneak(this.sneakTime / 8, this.direction.positiveZ, 1)
                    this.position := this.minecraft.getCoords()
                }

                else if(this.position.z - roundedDown.z >= 0.3 and this.position.z - roundedDown.z < 0.4 or this.position.z - roundedDown.z >= -0.7 and this.position.z - roundedDown.z < -0.6)
                {
                    this.sneak(this.sneakTime / 16, this.direction.positiveZ, 1)
                    this.position := this.minecraft.getCoords()
                }

                ;move in a negative direction on the Z axis
                else if(this.position.z - roundedDown.z > 0.9 or this.position.z - roundedDown.z <= 0 and this.position.z - roundedDown.z > -0.1 )
                {
                    this.sneak(this.sneakTime / 2, this.direction.negativeZ, 1)
                    this.position := this.minecraft.getCoords()
                }
                
                else if(this.position.z - roundedDown.z > 0.8 and this.position.z - roundedDown.z <= 0.9 or this.position.z - roundedDown.z > -0.2 and this.position.z - roundedDown.z <= -0.1)
                {
                    this.sneak(this.sneakTime / 4, this.direction.negativeZ, 1)
                    this.position := this.minecraft.getCoords()
                }

                else if(this.position.z - roundedDown.z > 0.7 and this.position.z - roundedDown.z <= 0.8 or this.position.z - roundedDown.z > -0.3 and this.position.z - roundedDown.z <= -0.2)
                {
                    this.sneak(this.sneakTime / 8, this.direction.negativeZ, 1)
                    this.position := this.minecraft.getCoords()
                }
                
                else if(this.position.z - roundedDown.z > 0.6 and this.position.z - roundedDown.z <= 0.7 or this.position.z - roundedDown.z > -0.4 and this.position.z - roundedDown.z <= -0.3)
                {
                    this.sneak(this.sneakTime / 16, this.direction.negativeZ, 1)
                    this.position := this.minecraft.getCoords()
                }
            }
        }
        playerLogger.sendLog("player.ahk\Player\centerOn\ Centered player on coordinates " this.position.ToString())
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
                Pause -1
                playerLogger.sendLog("player.ahk\Player\depositInv\ script paused, Failed to open deposit conainer")
                result := MsgBox("Failed to open deposit conainer. Open the container manually and press Retry or press Cancel to end the script.", "ERROR", "RetryCancel IconX")
                if (result = "Retry")
                {
                    playerLogger.sendLog("player.ahk\Player\depositInv\ script unpaused")
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
        playerLogger.sendLog("player.ahk\Player\depositInv\ deposited inventory")
    }

    /**********************************************
     * TURN
     * adjusts the players roational poisition
     * TARGETYAW: the yaw that the player to turn to
     * TARGETPITCH: the pitch the player will turn to
     **********************************************/
    turn(targetYaw, targetPitch)
    {
        playerLogger.sendLog("Turning player to (" targetYaw ", " targetPitch ")")
        ;yaw -180 to 180
        ;pitch -90 to 90

        ;does nothing
        ;MouseMove(0, -1, 100, "R")

        ;does nothing
        ;MouseMove(0, -10, 100, "R")

        ;does nothing
        ;MouseMove(0, -1, 50, "R")

        ;does nothing
        ;MouseMove(0, -1,, "R")

        ;moves camera up about 82 degrees
        ;loop 10
        ;    MouseMove(0, -1, 100, "R")
        
        ;moves camera up 37 degrees
        ;loop 5
            ;MouseMove(0, -1, 100, "R")

        ;moves camera up about 91 degrees 
        ;loop 11
            ;MouseMove(0, -1, 100, "R")

        ;moves camera up 27 degrees
        ;loop 3
            ;MouseMove(0, -1, 100, "R")

        ;moves camera up 19 degrees
        ;loop 3
            ;MouseMove(0, -1,, "R")

        ;moves camera up 9.2 degrees
        ;loop 2
            ;MouseMove(0, -1,, "R")

        ;moves camera up 81.9 degrees
        ;loop 10
        ;    MouseMove(0, -1,, "R")

        /*
        exitLoop := 0
        while(exitLoop = 0)
        {
            
            if(this.direction.pitch > 75)
            {
                loop 5
                    MouseMove(0, -1, 100, "R")
                this.direction := this.minecraft.getFacing()
            }
            */
           ;currently makes the player look up 90 degrees
           /*
            if(this.direction.pitch > 0)
            {
                loop 1
                    MouseMove(0, -1, 100, "R")
                this.direction := this.minecraft.getFacing()
            }

            if(this.direction.pitch < 5)
                exitLoop := 1
        }
        */

        ;set to targetYaw

        ;set to targetPitch

        
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
                    playerLogger.sendLog("player.ahk\Player\loadFromFile\sneakTime: " this.sneakTime)
                }
            }
        
            if InStr(A_LoopReadLine, "walkTime")
            {
                Loop parse, A_LoopReadLine, ":"
                {
                    this.walkTime := A_LoopField
                    playerLogger.sendLog("player.ahk\Player\loadFromFile\walkTime: " this.walkTime)
                }
            }
        }

        if(this.sneakTime = "")
        {
            this.sneakTime := 772
            playerLogger.sendLog("player.ahk\Player\loadFromFile\sneakTime: set to default")
        }

        if(this.walkTime = "")
        {
            this.sneakTime := 231
            playerLogger.sendLog("player.ahk\Player\loadFromFile\walkTime: set to default")
        }
    }
}
