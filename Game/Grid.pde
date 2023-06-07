/* Grid Class - Used for rectangular-tiled games
 * A 2D array of GridTiles which can be marked
 * Author: Joel Bianchi
 * Last Edit: 6/6/2023
 * Edited to show all Images & Sprites
 * Made a subclass of World
 */
import java.util.List;
import java.util.ArrayList;

public class Grid extends World{
  private int rows;
  private int cols;
  private GridTile[][] board;
  private int lootTimer = 120000;
  private String[][] template = {
    {"x","x","","","","","","","","","","x","x"},
    {"x","▉","","▉","","▉","","▉","","▉","","▉","x"},
    {"","","","","","","","","","","","",""},
    {"","▉","","▉","","▉","","▉","","▉","","▉",""},
    {"","","","","","","","","","","","",""},
    {"","▉","","▉","","▉","","▉","","▉","","▉",""},
    {"","","","","","","","","","","","",""},
    {"","▉","","▉","","▉","","▉","","▉","","▉",""},
    {"","","","","","","","","","","","",""},
    {"x","▉","","▉","","▉","","▉","","▉","","▉","x"},
    {"x","x","","","","","","","","","","x","x"}
  };
  //Formula for map generation, with x giving an empty space and squares creating indestructible walls.
  private Block[][] blocklist;
  

  //Grid constructor #1
  public Grid(String screenName, PImage bg, int rows, int cols){
    super(screenName, bg);

    this.rows = rows;
    this.cols = cols;
    board = new GridTile[rows][cols];
    blocklist = new Block[rows][cols];
    
    for(int r=0; r<rows; r++){
      for(int c=0; c<cols; c++){
        board[r][c] = new GridTile(new GridLocation(r,c));
      }
    }
  }

  //Grid Construtor #2: Only accepts the number of rows & columns (Default for 2023)
  public Grid(int rows, int cols){
    this("grid",null, rows, cols);
  }

  // Grid Constructor #3: Default constructor that creates a 3x3 Grid  
  public Grid(){
     this(3,3);
  }

  public void generateLevel()
  {
    PImage wall = loadImage("images/bricks.jpg");
    wall.resize(grid.getTileWidthPixels(),grid.getTileHeightPixels());
    PImage fire = loadImage("images/Fire.png");
    fire.resize(grid.getTileWidthPixels(),grid.getTileHeightPixels());
    for (int x = 0; x < rows; x++){
      for (int y = 0; y < cols; y++){
        if (template[x][y].equals("") && Math.random() < .9){

          blocklist[x][y] = new Block(fire,x,y,"Fire");
        }
        else if (template[x][y].equals("▉")){
          blocklist[x][y] = new Block(wall,x,y,"Wall");
        }
      }
    }
  }
  public void populateItems(){
    String[] items = new String[3];
    spawnSound.stop();
    spawnSound.play();
    for (int i = 0; i < 3; i++){
      if (this.allFilled()){
        break;
      }
      int rndx = new Random().nextInt(rows);
      int rndy = new Random().nextInt(cols);
      String pow = this.getRandomPower();
      if (blocklist[rndx][rndy] != null || this.hasItem(items,pow)){
        i--;
        continue;
      }
      PImage powimage = loadImage("images/"+pow+".png");
      powimage.resize(this.getTileWidthPixels(),this.getTileHeightPixels()); 
      blocklist[rndx][rndy] = new Block(powimage,new GridLocation(rndx,rndy),pow);
      items[i] = pow;
    }
  }
  public String getRandomPower(){
    int rnd = new Random().nextInt(rarepowers.length);
    return rarepowers[rnd];
}

public boolean hasItem(String[] haystack, String needle){
  for (int i = 0; i < haystack.length; i++){
    if (haystack[i] != null && haystack[i].equals(needle)){
      return true;
    }
  }
  return false;
}
public boolean allFilled(){
  for (int r = 0; r < rows; r++){
    for (int c = 0; c < cols; c++){
      if (blocklist[r][c] == null){
        return false;
      }
    }
  }
  return true;
}

  public void addBlock(Block b){
    GridLocation loc = b.getLocation();
    int x = loc.getRow();
    int y = loc.getCol();
    blocklist[x][y] = b;
    //System.out.println(b);
    //System.out.println(blocklist[x][y]);
  }

  public void update(int dt){
    lootTimer-=dt;
    if (lootTimer <= 0){
      lootTimer = 60000;
      populateItems();
    }
    
  }

 
  public Block[][] getBList(){
    return blocklist;
  }
  public void updateBList(GridLocation oldL, GridLocation newL){
    int oldx = oldL.getRow();
    int oldy = oldL.getCol();
    int newx = newL.getRow();
    int newy = newL.getCol();
    blocklist[newx][newy] = blocklist[oldx][oldy];
    blocklist[oldx][oldy] = null;
  }
  public void resetBList(){
    for (int r = 0; r < rows; r++){
      for (int c = 0; c < cols; c++){
        blocklist[r][c] = null;
      }
    }
  }
  // Method that Assigns a String mark to a location in the Grid.  
  // This mark is not necessarily visible, but can help in tracking
  // what you want recorded at each GridLocation.
  public void setMark(String mark, GridLocation loc){
    board[loc.getRow()][loc.getCol()].setNewMark(mark);
    //printGrid();
  } 
  public void resetLootTimer(){
    lootTimer = 60000;
  }
  // Method that Assigns a String mark to a location in the Grid.  
  // This mark is not necessarily visible, but can help in tracking
  // what you want recorded at each GridLocation.  
  // Returns true if mark is correctly set (no previous mark) or false if not
  public boolean setNewMark(String mark, GridLocation loc){
    int row = loc.getRow();
    int col = loc.getCol();
    boolean isGoodClick = board[row][col].setNewMark(mark);
    printGrid();
    return isGoodClick;
  } 
  public String getMark(GridLocation loc){
    return board[loc.getRow()][loc.getCol()].getMark();
  }
  public boolean removeMark(GridLocation loc){
    boolean isGoodClick = board[loc.getRow()][loc.getCol()].removeMark();
    return isGoodClick;
  }
  public boolean hasMark(GridLocation loc){
    boolean isGoodClick = board[loc.getRow()][loc.getCol()].getMark() != " ";
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
    //calculate the left of the grid GridLocation
    int pixelX = (widthOfOneTile * loc.getCol()); 
    return pixelX;
  }
  public int getX(int row, int col){
    return getX(new GridLocation(row, col));
  }
  
  //Accessor method that provide the y-pixel value given a GridLocation loc
  public int getY(GridLocation loc){
    int heightOfOneTile = pixelHeight/this.rows;
    //calculate the top of the grid GridLocation
    int pixelY = (heightOfOneTile * loc.getRow()); 
    return pixelY;
  }
  public int getY(int row, int col){
    return getY(new GridLocation(row,col));
  }

  
  //Accessor method that returns the number of rows in the Grid
  public int getNumRows(){
    return rows;
  }
  
  //Accessor method that returns the number of cols in the Grid
  public int getNumCols(){
    return cols;
  }

  //Accessor method that returns the width of 1 Tile in the Grid
  public int getTileWidthPixels(){
    return pixelWidth/this.cols;
  }
  //Accessor method that returns the height of 1 Tile in the Grid
  public int getTileHeightPixels(){
    return pixelHeight/this.rows;
  }


  //Returns the GridTile object stored at a specified GridLocation
  public GridTile getTile(GridLocation loc){
    return board[loc.getRow()][loc.getCol()];
  }

  //Returns the GridTile object stored at a specified row and column
  public GridTile getTile(int r, int c){
    return board[r][c];
  }

  //------------------PImage Methods ---------------//
  //Method that sets the image at a particular tile in the grid & displays it
  public void setTileImage(GridLocation loc, PImage pi){
    GridTile tile = getTile(loc);
    tile.setImage(pi);
    showTileImage(loc);
  }

  //Method that returns the PImage associated with a particular Tile
  public PImage getTileImage(GridLocation loc){
    GridTile tile = getTile(loc);
    return tile.getImage();
  }


  //Method that returns if a Tile has a PImage
  public boolean hasTileImage(GridLocation loc){
    GridTile tile = getTile(loc);
    return tile.hasImage();
  }

  //Method that clears the tile image
  public void clearTileImage(GridLocation loc){
    setTileImage(loc,null);
  }

  public void showTileImage(GridLocation loc){
    GridTile tile = getTile(loc);
    if(tile.hasImage()){
      image(tile.getImage(),getX(loc),getY(loc));
    }
  }

  //Method to show all the PImages stored in each GridTile
  public void showImages(){

    //Loop through all the Tiles and display its images/sprites
      for(int r=0; r<getNumRows(); r++){
        for(int c=0; c<getNumCols(); c++){

          //Store temporary GridLocation
          GridLocation tempLoc = new GridLocation(r,c);
          
          //Check if the tile has an image
          if(hasTileImage(tempLoc)){
            showTileImage(tempLoc);
          }
        }
      }
  }

  //------------------AnimatedSprite Methods ---------------//
  //Method that sets the Sprite at a particular tile in the grid & displays it
  public void setTileSprite(GridLocation loc, AnimatedSprite sprite){
    GridTile tile = getTile(loc);
    if(sprite == null){
      tile.setSprite(null);
      //System.out.println("Cleared tile @ " + loc);
      return;
    }
    sprite.setLeft(getX(loc));
    sprite.setTop(getY(loc));
    tile.setSprite(sprite);
    showTileSprite(loc);
    //System.out.println("Succcessfully set tile @ " + loc);
  }
  
  //Method that returns the PImage associated with a particular Tile
  public AnimatedSprite getTileSprite(GridLocation loc){
    GridTile tile = getTile(loc);
    //System.out.println("Grid.getTileSprite() " + tile.getSprite());
    return tile.getSprite();
  }
  
  //Method that returns if a Tile has a PImage
  public boolean hasTileSprite(GridLocation loc){
    GridTile tile = getTile(loc);
    return tile.hasSprite();
  }

  //Method that clears the tile image
  public void clearTileSprite(GridLocation loc){
    setTileSprite(loc,null);
  }

  public void showTileSprite(GridLocation loc){
    GridTile tile = getTile(loc);
    if(tile.hasSprite()){
      tile.getSprite().animate();
    }
  }

  
  //Method to show all the PImages stored in each GridTile
  public void showGridSprites(){

    //Loop through all the Tiles and display its images/sprites
      for(int r=0; r<getNumRows(); r++){
        for(int c=0; c<getNumCols(); c++){

          //Store temporary GridLocation
          GridLocation tempLoc = new GridLocation(r,c);
          
          //Check if the tile has an image
          if(hasTileSprite(tempLoc)){
            setTileSprite(tempLoc, getTileSprite(tempLoc));
            //showTileSprite(tempLoc);
          }
        }
      }
  }

  //Method to clear the screen from all Images & Sprites
    public void clearGrid(){

      //Loop through all the Tiles and display its images/sprites
        for(int r=0; r<getNumRows(); r++){
          for(int c=0; c<getNumCols(); c++){

            //Store temporary GridLocation
            GridLocation tempLoc = new GridLocation(r,c);
            
            //Check if the tile has an image
            if(hasTileSprite(tempLoc)){
              setTileSprite(tempLoc, getTileSprite(tempLoc));
              //showTileSprite(tempLoc);
            }
          }
        }
    }




}
