#Requires AutoHotkey v2.0

/******************************************************
 * FARM
 * A class with information and methods relating to the farm
 ******************************************************/

class Farm {
    
    settingsFile := "settings.txt"

    ; this method is called when a new instance is created 
    __New(layers := 0, sectionsPerLayer := 0, rowsPerSection := 0, rowLength := 0, depositContainer := "Double") {
        this.layers := layers ;the number of layers on the farm
        this.sectionsPerLayer := sectionsPerLayer ;the number of sections in each layer
        this.rowsPerSection := rowsPerSection ;the numbers of rows in each section
        this.rowLength := rowLength ;the length of the rows
        this.loadFromFile()
    }

    /**************************************************
     * LOAD FROM FILE
     * Loads settings from the settingsFile
     *************************************************/
    loadFromFile()
    {
        /* reads and loads data from the autoFarmData.txt file */
        Loop read, this.settingsFile
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
        
            if InStr(A_LoopReadLine, "depositContainer")
            {
                Loop parse, A_LoopReadLine, ":"
                {
                    this.depositContainer := A_LoopField
                }
            }
        }
    }
}

