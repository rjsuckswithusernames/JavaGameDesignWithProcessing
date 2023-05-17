/* GridLocation class - helper class to store coordinates more easily
 * Author: Joel Bianchi
 * Last Edit: 5/17/2023
 */

public class GridLocation{
 
  int row;
  int col;
  
  public GridLocation(int row, int col){
    this.row = row;
    this.col = col;
  }
  
  public int getR(){
    return row;
  }
  
  public int getC(){
    return col;
  }
  
  public String toString(){
    return row + "," + col;
  }
  
  public int getYCoord() {
    return -1;
  }
  
  public int getXCoord() {
    return -1;
  }
 
}
