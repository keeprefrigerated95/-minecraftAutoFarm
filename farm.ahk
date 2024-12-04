#Requires AutoHotkey v2.0
#Include logger.ahk
farmLogger := Logger("farm.ahk")
/******************************************************
 * FARM
 * A class with information and methods relating to the farm
 * test
 ******************************************************/

class Farm {
    
    settingsFile := "settings.txt"

    ; this method is called when a new instance is created 
    __New(layers := 0, sectionsPerLayer := 0, rowsPerSection := 0, rowLength := 0) {
        this.layers := layers ;the number of layers on the farm
        this.sectionsPerLayer := sectionsPerLayer ;the number of sections in each layer
        this.rowsPerSection := rowsPerSection ;the numbers of rows in each section
        this.rowLength := rowLength ;the length of the rows
        this.loadFromFile()
        farmLogger.sendLog("farm.ahk\Farm\New\ Farm object created")
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
                    farmLogger.sendLog("farm.ahk\Farm\loadFromFile\ layers: " this.layers)
                }
            }
            
            if InStr(A_LoopReadLine, "sectionsPerLayer")
            {
                Loop parse, A_LoopReadLine, ":"
                {
                    this.sectionsPerLayer := A_LoopField
                    farmLogger.sendLog("farm.ahk\Farm\loadFromFile\ sectionsPerLayer: " this.sectionsPerLayer)
                }
            }
        
            if InStr(A_LoopReadLine, "rowsPerSection")
            {
                Loop parse, A_LoopReadLine, ":"
                {
                    this.rowsPerSection := A_LoopField
                    farmLogger.sendLog("farm.ahk\Farm\loadFromFile\ rowsPerSection: " this.rowsPerSection)
                }
            }
        
            if InStr(A_LoopReadLine, "rowLength")
            {
                Loop parse, A_LoopReadLine, ":"
                {
                    this.rowLength := A_LoopField
                    farmLogger.sendLog("farm.ahk\Farm\loadFromFile\ rowLength: " this.rowLength)
                }
            }
        }
        farmLogger.sendLog("farm.ahk\Farm\loadFromFile\ farm settings loaded")
    }
}

