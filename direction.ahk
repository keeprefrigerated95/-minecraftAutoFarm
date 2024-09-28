/******************************************************
 * COORDINATES
 * A class which can save an x, y, z coordinate
 ******************************************************/

class Direction {
    
    ; this method is called when a new instance is created 
    __New(direction:="", positiveX:="", negativeX:="", positiveZ:="", negativeZ:="") {
        ; assign the parameters to instance variables 
        this.direction := direction

        if(direction = "n")
        {
            this.positiveX := "d"
            this.negativeX := "a"
            this.positiveZ := "s"
            this.negativeZ := "w"
        }
        
        if(direction = "s")
        {
            this.positiveX := "a"
            this.negativeX := "d"
            this.positiveZ := "w"
            this.negativeZ := "s"
        }
        
        if(DIRECTION = "e")
        {
            this.positiveX := "w"
            this.negativeX := "s"
            this.positiveZ := "d"
            this.negativeZ := "a"
        }
        
        if(DIRECTION = "w")
        {
            this.positiveX := "s"
            this.negativeX := "w"
            this.positiveZ := "a"
            this.negativeZ := "d"
        }
    }
    
    ; this method is used by the String class and is useful for printing/msg boxes
    ToString() {
        Return Format('({1}, {2}, {3})', this.direction, this.positiveX, this.negativeX, this.positiveZ, this.negativeZ)
    }
}