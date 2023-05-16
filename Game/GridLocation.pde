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
  
}
