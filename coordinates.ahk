#Include logger.ahk
coordLogger := Logger("coordinates.ahk")
/******************************************************
 * COORDINATES
 * A class which can save an x, y, z coordinate
 ******************************************************/

class Coordinates {
    
    ; this method is called when a new instance is created 
    __New(x := 0.0, y:=0.0, z:=0.0) {
        ; assign the parameters to instance variables 
        this.x := x
        this.y := y
        this.z := z
        coordLogger.sendLog("coordinates.ahk\Coordinates\New: (" this.x ", " this.y ", " this.z ")")
    }
    
    ; this method is used by the String class and is useful for printing/msg boxes
    ToString() {
        Return Format('({1}, {2}, {3})', this.x, this.y, this.z)
    }

    /***************************************************
     * CENTER COORDINATES
     * gives the exact center coordinates of the block that
     * is given, rounds to 0.5
     ****************************************************/
    centerCoordinates()
    {
        coordLogger.sendLog("coordinates.ahk\Coordinates\centerCoordinates: centering " this.ToString())

        outputCoords := Coordinates()
        roundedX := 0.0
        roundedY := 0.0
        roundedZ := 0.0

        
        if(this.x < 0)
        {
            roundedX := Float(Integer(this.x))
            centeredX := roundedX - 0.5
        }
        
    
        if(this.x >= 0.0)
        {
            roundedX := Float(Integer(this.x))
            centeredX := roundedX + 0.5
        }

        if(this.y < 0.0)
        {
            roundedY := Float(Integer(this.y))
            centeredY := roundedY - 0.5
        }
        
        if(this.y >= 0.0)
        {
            roundedY := Float(Integer(this.y))
            centeredY := roundedY + 0.5
        }

        if(this.z < 0.0)
        {
            roundedZ := Float(Integer(this.z))
            centeredZ := roundedZ - 0.5
        }
            
        if(this.z >= 0.0)
        {
            roundedZ := Float(Integer(this.z))
            centeredZ := roundedZ + 0.5
        }

        outputCoords := Coordinates(centeredX, centeredY, centeredZ)

        coordLogger.sendLog("coordinates.ahk\Coordinates\centerCoordinates: centered to " outputCoords.ToString())

        return outputCoords
    }
}
