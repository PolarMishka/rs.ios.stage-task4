import Foundation

public extension Int {
    
    var roman: String? {
        
        if self >= 1 && self <= 3999 {
            
        var intInput: Int = self
        var romanOutput = String()

        let arrayOfRoman = ["M","CM","D","CD","C","XC","L","XL","X","IX","V","IV","I"]
        let arrayOfInt = [1000,900,500,400,100,90,50,40,10,9,5,4,1]

        for value in arrayOfInt {
           
            while intInput >= value {
                
                romanOutput += arrayOfRoman[arrayOfInt.firstIndex(of: value)!]
                intInput -= value
            }
        }
        
        return romanOutput
            
        } else { return nil }
    }
       
}
