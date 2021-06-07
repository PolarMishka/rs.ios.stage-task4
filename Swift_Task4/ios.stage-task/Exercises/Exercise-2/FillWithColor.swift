import Foundation

final class FillWithColor {
    
    func fillWithColor(_ image: [[Int]], _ row: Int, _ column: Int, _ newColor: Int) -> [[Int]] {
        
        if (row < 0 || column < 0 || row >= image.count || column >= image[0].count || image[row][column] == newColor) {
            return image
        }
        
        var finalImage = image
        
        func paintImage(_ r: Int, _ c: Int, _ newColor: Int){
          
           while r >= 0 && r < finalImage.count && c >= 0 && c < finalImage[r].count &&
                   finalImage[r][c] == image[row][column] &&
                   finalImage[r][c] != newColor
           {
               finalImage[r][c] = newColor
           
            for r in r-1 ... r+1 {
               paintImage(r, c, newColor)
            }
            for c in c-1 ... c+1 {
               paintImage(r, c, newColor)
            }
          }
       }
        
        paintImage(row, column, newColor)
        
        return finalImage
    }
}
