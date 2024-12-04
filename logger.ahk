/*********************************************
 * LOGGER
 * an object that collects debug data and saves
 * it to a text file
 * originFile - the name of the file in which
 *              the Logger object is being created
 *********************************************/

#Requires AutoHotkey v2.0

class Logger {
    
    ; this method is called when a new instance is created 
    __New(originFile := "") {
        ; assign the parameters to instance variables
        this.originFile := originFile 
        this.sendLog("logger.ahk\Logger\ New logger object created in " this.originFile)
    }

    sendLog(logText)
    {
        currentTime := FormatTime(, "M/d/yy H:mm:s")
        OutputDebug currentTime " " logText "`n"
        FileAppend currentTime " " logText "`n", "log.txt"
    }
}