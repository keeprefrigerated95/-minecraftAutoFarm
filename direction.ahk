/******************************************************
 * DIRECTION
 * A class that holds the cardinal direction the player
 * is facing and the keys that need to be pressed to move
 * in a positive or negative direction in the x and z planes
 ******************************************************/

class Direction {
    
    ; this method is called when a new instance is created 
    __New(cardinalDir:="", positiveX:="", negativeX:="", positiveZ:="", negativeZ:="") {
        ; assign the parameters to instance variables 
        this.cardinalDir := cardinalDir
        this.positiveX := positiveX
        this.negativeX := negativeX
        this.positiveZ := positiveZ
        this.negativeZ := negativeZ
    }
    
    ; this method is used by the String class and is useful for printing/msg boxes
    ToString() {
        Return Format('({1}, {2}, {3})', this.direction, this.positiveX, this.negativeX, this.positiveZ, this.negativeZ)
    }
}
