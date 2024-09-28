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
    }
    
    ; this method is used by the String class and is useful for printing/msg boxes
    ToString() {
        Return Format('({1}, {2}, {3})', this.x, this.y, this.z)
    }
}