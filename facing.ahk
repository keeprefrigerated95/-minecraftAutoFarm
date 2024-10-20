/******************************************************
 * FACING
 * A class that holds the cardinal direction the player
 * is facing and the keys that need to be pressed to move
 * in a positive or negative direction in the x and z planes
 ******************************************************/

class Facing {
    
    ; this method is called when a new instance is created 
    __New(cardinalDir:="", positiveX:="", negativeX:="", positiveZ:="", negativeZ:="") {
        ; assign the parameters to instance variables 
        this.cardinalDir := cardinalDir
        ;which buttons need to be pressed to move the player in a positve or negative direction
        this.positiveX := positiveX
        this.negativeX := negativeX
        this.positiveZ := positiveZ
        this.negativeZ := negativeZ
    }
    
    ;sets the direction and the positive/negative x and y based on the direction facing
    setDirection(nseORw)
    {

        this.cardinalDir := nseORw

        if(nseORw = "n")
        {
            this.positiveX := "d"
            this.negativeX := "a"
            this.positiveZ := "s"
            this.negativeZ := "w"
        }
                
        else if(nseORw = "s")
        {
            this.positiveX := "a"
            this.negativeX := "d"
            this.positiveZ := "w"
            this.negativeZ := "s"
        }
                
        else if(nseORw = "e")
        {
            this.positiveX := "w"
            this.negativeX := "s"
            this.positiveZ := "d"
            this.negativeZ := "a"
        }
                
        else if(nseORw = "w")
        {
            this.positiveX := "s"
            this.negativeX := "w"
            this.positiveZ := "a"
            this.negativeZ := "d"
        }

        else
        {
            MsgBox("Unable to retrieve direction from degub screen", "ERROR", "Iconx")
            ExitApp
        }
    }

    ; this method is used by the String class and is useful for printing/msg boxes
    ToString() {
        ;Return Format('({1}, {2}, {3})', this.cardinalDir, this.positiveX, this.negativeX, this.positiveZ, this.negativeZ)
        output := "Direction: " this.cardinalDir
        return output
    }
}