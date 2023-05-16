public class Grid{
  
  private int rows;
  private int cols;
  private GridTile[][] board;
  

  //Grid constructor that will create a Grid with the specified number of rows and cols
  public Grid(int rows, int cols){
    this.rows = rows;
    this.cols = cols;
    board = new GridTile[rows][cols];
    
    for(int r=0; r<rows; r++){
      for(int c=0; c<cols; c++){
         board[r][c] = new GridTile();
      }
    }
  }

  // Default Grid constructor that creates a 3x3 Grid  
  public Grid(){
     this(3,3);
  }

  // Method that Assigns a String mark to a location in the Grid.  
  // This mark is not necessarily visible, but can help in tracking
  // what you want recorded at each GridLocation.
  public void setMark(String mark, GridLocation loc){
    board[loc.getR()][loc.getC()].setNewMark(mark);
    printGrid();
  } 

  // Method that Assigns a String mark to a location in the Grid.  
  // This mark is not necessarily visible, but can help in tracking
  // what you want recorded at each GridLocation.  
  // Returns true if mark is correctly set (no previous mark) or false if not
  public boolean setNewMark(String mark, GridLocation loc){
    int row = loc.getR();
    int col = loc.getC();
    boolean isGoodClick = board[row][col].setNewMark(mark);
    printGrid();
    return isGoodClick;
  } 
  
  //Method that prints out the marks in the Grid to the console
  public void printGrid(){
   
    for(int r = 0; r<rows; r++){
      for(int c = 0; c<cols; c++){
         System.out.print(board[r][c]);
      }
      System.out.println();
    } 
  }
  
  //Method that returns the GridLocation of where the mouse is currently hovering over
  public GridLocation getGridLocation(){
      
    int row = mouseY/(pixelHeight/this.rows);
    int col = mouseX/(pixelWidth/this.cols);

    return new GridLocation(row, col);
  } 

  //Accessor method that provide the x-pixel value given a GridLocation loc
  public int getX(GridLocation loc){
    
    int widthOfOneTile = pixelWidth/this.cols;
 
    //calculate the center of the grid GridLocation
    int pixelX = (widthOfOneTile/2) + (widthOfOneTile * loc.getC()); 
    
    return pixelX;
  } 
  
  //Accessor method that provide the y-pixel value given a GridLocation loc
  public int getY(GridLocation loc){
    
    int heightOfOneTile = pixelHeight/this.rows;
 
    //calculate the center of the grid GridLocation
    int pixelY = (heightOfOneTile/2) + (heightOfOneTile * loc.getR()); 
    
    return pixelY;
  } 
  
  //Accessor method that returns the number of rows in the Grid
  public int getRows(){
    return rows;
  }
  
  //Accessor method that returns the number of cols in the Grid
  public int getCols(){
    return cols;
  }

  //Returns the GridTile object stored at a specified GridLocation
  public GridTile getTile(GridLocation loc){
    return board[loc.getR()][loc.getC()];
  }

  //Returns the GridTile object stored at a specified row and column
  public GridTile getTile(int r, int c){
    return board[r][c];
  }
  
}
