/* Game Class Starter File
 * Last Edit: 12/13/2022
 * Authors: Raymond Morel, Muhammad Zahid
 */


//import processing.sound.*;

//GAME VARIABLES
private int msElapsed = 0;

int maximumx = 11;
int maximumy = 13;
public Grid grid = new Grid(maximumx,maximumy);
PImage bg;

boolean secret = false;
boolean debounce = false;
Player player1;
Player player2;
PImage endScreen;
String titleText = "Fire Fighters";
String extraText = "real";
AnimatedSprite exampleSprite;
boolean doAnimation;
Block[][] blist;
ArrayList<Block> blocklist = new ArrayList<Block>();
ArrayList<Block> blocklist2 = new ArrayList<Block>();
//INPUTS

//P1
int wkey = 87;
int akey = 65;
int skey = 83;
int dkey = 68;
int ekey = 69;

//P2
int up = 38;
int left = 37;
int down = 40;
int right = 39;
int space = 32;

//SoundFile song;



//Required Processing method that gets run once
void setup() {

  //Match the screen size to the background image size
  size(800, 600);
  //Set the title on the title bar
  surface.setTitle(titleText);
  grid.generateLevel();
  //Load images used
  //bg = loadImage("images/chess.jpg");
  bg = loadImage("images/werksugvfuywegg.jpg");
  bg.resize(800,600);
  PImage p1image = loadImage("images/x_wood.png");
  p1image.resize(grid.getTileWidthPixels(),grid.getTileHeightPixels());
  PImage p2image = loadImage("images/spook.png");
  p2image.resize(grid.getTileWidthPixels(),grid.getTileHeightPixels());
  player1 = new Player(p1image);
  player2 = new Player(p2image,maximumx-1,maximumy-1);
  endScreen = loadImage("images/youwin.png");
  Block[][] blist = grid.getBList();
  // Load a soundfile from the /data folder of the sketch and play it back
  // song = new SoundFile(this, "sounds/Lenny_Kravitz_Fly_Away.mp3");
  // song.play();

  
  //Animation & Sprite setup
  exampleAnimationSetup();

  imageMode(CORNER);    //Set Images to read coordinates at corners
  //fullScreen();   //only use if not using a specfic bg image
  
  println("Game started...");

}

//Required Processing method that automatically loops
//(Anything drawn on the screen should be called from here)
void draw() {


  updateTitleBar();

  if (msElapsed % 300 == 0) {
    populateSprites();
    moveSprites();
  }

  updateScreen();
  
  if(isGameOver()){
    endGame();
  }

  checkExampleAnimation();
  
  msElapsed +=(1/60);
  grid.pause(1/60);
  
}

//Known Processing method that automatically will run whenever a key is pressed
void keyPressed(){

  //check what key was pressed
  System.out.println("Key pressed: " + keyCode); //keyCode gives you an integer for the key

  //What to do when a key is pressed?
  
  //player 1 movement
  if(keyCode == wkey || keyCode == akey || keyCode == skey || keyCode == dkey){
    //check case where out of bounds
    //change the field for player1Row
    int x = player1.getX();
    int y = player1.getY();
   if (keyCode == wkey && player1.getX() > 0 && !(player1.getX()-1 == player2.getX() && player1.getY()  == player2.getY()) ){
    x--;
   }
   if (keyCode == akey && player1.getY()  > 0 && !(player1.getY()-1 == player2.getY() && player1.getX() == player2.getX())) {
    y--;
   }
   if (keyCode == skey && player1.getX() < grid.getNumRows()-1 && !(player1.getX()+1 == player2.getX() && player1.getY()  == player2.getY())) {
    x++;
   }
   if (keyCode == dkey && player1.getY() < grid.getNumCols()-1 && !(player1.getY()+1 == player2.getY() && player1.getX() == player2.getX())) {
    y++;
   }
    System.out.println(x);
    System.out.println(y);
    boolean move = true;
    GridLocation loc = new GridLocation(x, y);
    if (player2.collisionCheck(loc) == true) {
      move = false;
    }
    for (int i = 0; i < blocklist.size(); i++){
      Block b = blocklist.get(i);
      System.out.println(b.getLocation());
      if (b.getLocation().equals(loc)){
        move = false;
      }
    }
    for (int i = 0; i < blocklist2.size(); i++){
      Block b = blocklist2.get(i);
      System.out.println(b.getLocation());
      if (b.getLocation().equals(loc)){
        move = false;
      }
    }
    Block b = blist[x][y];
    if (b != null){
      if (b.getLocation().equals(loc)){
        move = false;
      }
    }
    //shift the player1 picture up in the 2D array
    if (move == true) {
      player1.setX(x);
      player1.setY(y);
      grid.setTileImage(loc,player1.getImage());
    }
    

    
    //eliminate the picture from the old location

  } //end player1movement
  if (keyCode == ekey && !(grid.hasMark(player1.getLocation()) == true)) {
    PImage wall = loadImage("images/balloon.png");
    wall.resize(grid.getTileWidthPixels(),grid.getTileHeightPixels());
    GridLocation loc = player1.getLocation();
    grid.setMark("B", loc);
    grid.setTileImage(loc, wall);
    Block b = new Block(wall,loc,"Balloon",player1);
    grid.addBlock(b);
    System.out.println(blist);
    blocklist.add(b);
    grid.Explode(b);
    grid.removeMark(loc);
    blocklist.remove(b);
    

    System.out.println("Mark Placed");
  }
  //Player2 movement

  if(keyCode == up || keyCode == left || keyCode == down || keyCode == right){
    int x = player2.getX();
    int y = player2.getY();
   if (keyCode == up && player2.getX() > 0 && !(player2.getX()-1 == player1.getX() && player1.getY()  == player2.getY()) ){
    x--;
   }
   if (keyCode == left && player2.getY()  > 0 && !(player2.getY()-1 == player1.getY() && player1.getX() == player2.getX())) {
    y--;
   }
   if (keyCode == down && player2.getX() < grid.getNumRows()-1 && !(player2.getX()+1 == player1.getX() && player1.getY()  == player2.getY())) {
    x++;
   }
   if (keyCode == right && player2.getY() < grid.getNumCols()-1 && !(player2.getY()+1 == player1.getY() && player1.getX() == player2.getX())) {
    y++;
   }
    System.out.println(x);
    System.out.println(y);
    boolean move = true;
    GridLocation loc = new GridLocation(x, y);
    if (player1.collisionCheck(loc) == true) {
      move = false;
    }
    for (int i = 0; i < blocklist.size(); i++){
      Block b = blocklist.get(i);
      System.out.println(b.getLocation());
      if (b.getLocation().equals(loc)){
        move = false;
      }
    }
    for (int i = 0; i < blocklist2.size(); i++){
      Block b = blocklist2.get(i);
      System.out.println(b.getLocation());
      if (b.getLocation().equals(loc)){
        move = false;
      }
    }
    Block b = blist[x][y];
    if (b != null){
      if (b.getLocation().equals(loc)){
        move = false;
      }
    }
      if (move == true) {
      player2.setX(x);
      player2.setY(y);
      grid.setTileImage(loc,player2.getImage());
    }
  } //end Player2movement
     if (keyCode == space && !(grid.hasMark(player2.getLocation()) == true)) {
    PImage wall = loadImage("images/balloon.png");
    wall.resize(grid.getTileWidthPixels(),grid.getTileHeightPixels());
    GridLocation loc = player2.getLocation();
    grid.setMark("B", loc);
    grid.setTileImage(loc, wall);
    Block b = new Block(wall,loc,"Balloon",player1);
    grid.addBlock(b);
    blocklist2.add(b);
    if (blocklist2.size() > 3){
      Block h = blocklist2.get(0);
      grid.removeMark(h.getLocation());
      blocklist2.remove(h);
    }
    System.out.println("Mark Placed");
  } 

  }


  //Known Processing method that automatically will run when a mouse click triggers it
  void mouseClicked(){
  
    //check if click was successful
    System.out.println("Mouse was clicked at (" + mouseX + "," + mouseY + ")");
    System.out.println("Grid location: " + grid.getGridLocation());

    //what to do if clicked? (Make player1 disappear?)


    //Toggle the animation on & off
    doAnimation = !doAnimation;
    System.out.println("doAnimation: " + doAnimation);
    //grid.setMark("X",grid.getGridLocation());
    
  }





//------------------ CUSTOM  METHODS --------------------//

//method to update the Title Bar of the Game
public void updateTitleBar(){

  if(!isGameOver()) {
    //set the title each loop
    surface.setTitle(titleText + "    " + extraText);

    //adjust the extra text as desired
  
  }

}

//method to update what is drawn on the screen each frame
public void updateScreen(){

  //update the background
  background(bg);

  //Display the Player1 image
  GridLocation player1Loc = new GridLocation(player1.getX(), player1.getY());
  grid.setTileImage(player1Loc, player1.getImage());
    GridLocation player2loc = new GridLocation(player2.getX(), player2.getY());
    grid.setTileImage(player2loc,player2.getImage());
    blist = grid.getBList();
    for (int x = 0; x < grid.getNumRows(); x++){
      for (int y = 0; y < grid.getNumCols(); y++){
        Block b = blist[x][y];
        if (b != null){
        GridLocation bloc = b.getLocation();
        grid.setTileImage(bloc,b.getImage());
        }
      }
    }
  for (int i = 0; i < blocklist.size(); i++){
    Block b = blocklist.get(i);
    grid.setTileImage(b.getLocation(),b.getImage());
  }
    for (int i = 0; i < blocklist2.size(); i++){
    Block b = blocklist2.get(i);
    grid.setTileImage(b.getLocation(),b.getImage());
  }
  //Loop through all the Tiles and display its images/sprites
  

      //Store temporary GridLocation
      
      //Check if the tile has an image/sprite 
      //--> Display the tile's image/sprite



  //update other screen elements

}

//Method to populate enemies or other sprites on the screen
public void populateSprites(){
  
  //What is the index for the last column?
  

  //Loop through all the rows in the last column
  
    //Generate a random number
    

    //10% of the time, decide to add an enemy image to a Tile
    

}

//Method to move around the enemies/sprites on the screen
public void moveSprites(){
  //Loop through all of the rows & cols in the grid
  
    //Store the 2 tile locations to move

    //Check if the current tile has an image that is not player1      


      //Get image/sprite from current location


      //CASE 1: Collision with player1


      //CASE 2: Move enemy over to new location

      
      //Erase image/sprite from old location
      
      //System.out.println(loc + " " + grid.hasTileImage(loc));


    //CASE 3: Enemy leaves screen at first column


}

//Method to handle the collisions between Sprites on the Screen
public void handleCollisions(){


}

//method to indicate when the main game is over
public boolean isGameOver(){
  return false; //by default, the game is never over
}

//method to describe what happens after the game is over
public void endGame(){
    System.out.println("Game Over!");

    //Update the title bar

    //Show any end imagery
    image(endScreen, 100,100);

}

//example method that creates 5 horses along the screen
public void exampleAnimationSetup(){  
  int i = 2;
  exampleSprite = new AnimatedSprite("sprites/horse_run.png", 50.0, i*75.0, "sprites/horse_run.json");
}

//example method that animates the horse Sprites
public void checkExampleAnimation(){
  if(doAnimation){
    exampleSprite.animateVertical(5.0, 0.1, true);
  }
}