#Requires AutoHotkey v2.0
#Include coordinates.ahk

/******************************************************
 * SETTINGS
 * A class that saves all of the settings for autoFarm
 ******************************************************/

class Settings {
    
    ; this method is called when a new instance is created 
    __New(layers := 0, sectionsPerLayer := 0, rowsPerSection := 0, rowLength := 0, sneakTime := 772, walkTime := 231, depositContainer := "double", windowName := "Minecraft", boxSize := "35", topLeftInv := Coordinates()) {
        ; assign the parameters to instance variables 
        this.layers := layers ;the number of layers on the farm
        this.sectionsPerLayer := sectionsPerLayer ;the number of sections in each layer
        this.rowsPerSection := rowsPerSection ;the numbers of rows in each section
        this.rowLength := rowLength ;the length of the rows
        this.sneakTime := sneakTime ;time in milliseconds to walk one block while sneaking
        this.walkTime := walkTime ;time in milliseconds to walk one block
        this.depositContainer := depositContainer ;the type of container that will be deposited into, double, single, barrell, or hopper
        this.windowName := windowName ;the name of the minecaft window
        this.boxSize := boxSize ;the width of the inventory slots in pixels
        this.topLeftInv := topLeftInv ;coorinates of the upper left inventory slot while depositing
    }
    
    ;loads settings from the specified file
    loadFromFile(fileName)
    {
        /* reads and loads data from the autoFarmData.txt file */
        Loop read, fileName
        {
            if InStr(A_LoopReadLine, "layers")
            {
                Loop parse, A_LoopReadLine, ":"
                {
                    this.layers := A_LoopField
                }
            }
            
            if InStr(A_LoopReadLine, "sectionsPerLayer")
            {
                Loop parse, A_LoopReadLine, ":"
                {
                    this.sectionsPerLayer := A_LoopField
                }
            }
        
            if InStr(A_LoopReadLine, "rowsPerSection")
            {
                Loop parse, A_LoopReadLine, ":"
                {
                    this.rowsPerSection := A_LoopField
                }
            }
        
            if InStr(A_LoopReadLine, "rowLength")
            {
                Loop parse, A_LoopReadLine, ":"
                {
                    this.rowLength := A_LoopField
                }
            }
        
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
        
            if InStr(A_LoopReadLine, "depositContainer")
            {
                Loop parse, A_LoopReadLine, ":"
                {
                    this.depositContainer := A_LoopField
                }
            }
        
            if InStr(A_LoopReadLine, "windowName")
            {
                Loop parse, A_LoopReadLine, ":"
                {
                    this.windowName := A_LoopField
                }
            }
        }

        ;sets proper coordinates for target deposit container
        if(farmSettings.depositContainer = "single")
        {
            this.topLeftInv := Coordinates(276, 270, 0)
        }

        if(farmSettings.depositContainer = "barrel")
        {
            this.topLeftInv := Coordinates(276, 270, 0)
        }

        if(farmSettings.depositContainer = "double")
        {
            this.topLeftInv := Coordinates(276, 323, 0)
        }

        if(farmSettings.depositContainer = "hopper")
        {
            this.topLeftInv := Coordinates(276, 237, 0)
        }
    }

    toString()
    {
        data := "Layers: " this.layers "`nSections Per Layer: " this.sectionsPerLayer "`nRows Per Section: " this.rowsPerSection "`nRow Length: " this.rowLength "`nSneak Time: " this.sneakTime "`nWalk Time: " this.walkTime "`nDeposit Container: " this.depositContainer "`nWindow Name: " this.windowName "`n"
        return data
    }
}