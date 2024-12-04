/**********************************************
 * ~~~ AUTO FARM ~~~
 * A script that harvests and replants fields in minecraft
 **********************************************/

#Include coordinates.ahk
#Include facing.ahk
#Include player.ahk
#Include farm.ahk
#Include logger.ahk
autoFarmLogger := Logger("autoFarm.ahk")

/*********************************************************
* GET NEXT ROW
* returns the coordinates of the row directly to the right of the player
* currentRow: the coordinates of the current row
* facingData: info about which way the player is facing
**********************************************************/
getNextRow(currentRow, facingData)
{
    autoFarmLogger.sendLog("autoFarm.ahk\getNextRow\ currentRow: " currentRow.ToString())
    nextRow := Coordinates()
     
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
    
    nextRow := nextRow.centerCoordinates()
    autoFarmLogger.sendLog("autoFarm.ahk\getNextRow\ nextRow: " nextRow.ToString())
    return nextRow
}

/**********************************************
* X HOTKEY
* Press 'x' to cancel the script at any time
***********************************************/
*x::
{
    autoFarmLogger.sendLog("autoFarm.ahk\*x\ Script Cancelled")
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
    autoFarmLogger.sendLog("autoFarm.ahk\*p\ Script Paused")
    Pause -1
    result := MsgBox("Would you like to continue? If you cancel, you will have to start the script over.", "Paused", "YesNo")
    if (result = "Yes")
    {
        autoFarmLogger.sendLog("autoFarm.ahk/*p: Script Resumed")
        ;setUpWindow()
        Pause -1
    }

    else
    {
        autoFarmLogger.sendLog("autoFarm.ahk\*p\ Script Cancelled")
        Send "{Shift up}"
        MsgBox "Script Cancelled"
        ExitApp
    }
}

;welcome menu
result := MsgBox("Welcome to Keep Refrigerated's Automatic Minecraft Farm Bot!`n`nInstructions:`nPosition your player on the starting block then press OK. Make sure you are facing towards the end of the first row.`n`nPress P to pause the script at any time`nPress X to cancel the script`n`nFor more information, refer to the README", "Welcome!", "OKCancel")
if(result = "Cancel")
{
    ExitApp
}

CoordMode "Pixel", "Client"
steve := Player() ;the player charachter
theFarm := Farm() ;all of the settings for the farm

initialCoords := steve.setGetPosition() ;coordinates where the player starts
;initialFacing := steve.setGetDirection() ;the players beginning facing data

;completes the harvest, storage, and replanting process for all layers
loop theFarm.layers
{
    currentRowCoords := initialCoords ;coordinates of the row currently being harvested
    nextRowCoords := getNextRow(currentRowCoords, steve.direction)
    steve.moveTo(currentRowCoords)
    sectionsCount := 0
    rowCount := 0
    
    ;harvests and deposits an enire layer
    loop theFarm.sectionsPerLayer {
        sectionsCount += 1
        rowCount := 0

        autoFarmLogger.sendLog("autoFarm.ahk\ starting section " sectionsCount)
        
        ;harvests and deposits a single section
        loop theFarm.rowsPerSection
        {
            rowCount += 1

            autoFarmLogger.sendLog("autoFarm.ahk\ harvesting row " rowCount)
            ;harvests one row
            loop theFarm.rowLength
            {
                steve.sneak(steve.sneakTime, "w", 1)
                click "Left"
                sleep 200
                click "Right"
                sleep 200
            }

            ;if on the last row of the section, deposit in the chest on the current row
            if(rowCount = theFarm.rowsPerSection)
            {
                steve.moveTo(currentRowCoords)
            }

            ;send to next row to deposit, don't need to get coordinates as often this way
            else
            {
                steve.moveTo(nextRowCoords)
            }
            
            ;deposits items into the chest
            steve.depositInv()

            ;moves the current row over one block to the right
            currentRowCoords := getNextRow(currentRowCoords, steve.direction)
            nextRowCoords := getNextRow(currentRowCoords, steve.direction)
        }
        ;moves the current row over one block to the right, the next section
        currentRowCoords := getNextRow(currentRowCoords, steve.direction)
        nextRowCoords := getNextRow(currentRowCoords, steve.direction)

        ;move to next section unless on the last section
        if(sectionsCount != theFarm.sectionsPerLayer)
        {
            steve.moveTo(currentRowCoords)
        }
        
    }
    ;sets the current row to the stairwell and moves there
    currentRowCoords := getNextRow(currentRowCoords, steve.direction)
    nextRowCoords := getNextRow(currentRowCoords, steve.direction)
    steve.moveTo(currentRowCoords)
    steve.walk("w", 6)
    steve.walk("d", 2)
    steve.walk("s", 6)
}
autoFarmLogger.sendLog("autoFarm.ahk\ Harvest Complete OwO")
MsgBox "Harvest Complete OwO"
ExitApp
