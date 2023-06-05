/* Game Class Starter File
 * Last Edit: 12/13/2022
 * Authors: Raymond Morel, Muhammad Zahid
 */

import java.util.concurrent.*;
import processing.sound.*;

//GAME VARIABLES
private int msElapsed = 0;
boolean canpause = true;
protected int gamestate = 0; // 0: Main Menu, 1: Game, 2: Paused, 3: Game-Over

int maximumx = 11;
int maximumy = 13;
int lastTime = 0;
int delta = 0;
protected Grid grid = new Grid(maximumx,maximumy);
PImage bg;

Player player1;
Player player2;
PImage endScreen;
String titleText = "Fire Fighters";
String extraText = "real";
AnimatedSprite exampleSprite;
boolean doAnimation;
Block[][] blocklist;
protected int[][] dirs = 
{
  {-1,0}, //up
  {1,0}, //down
  {0,-1}, //left
  {0,1} //right
};
ScheduledExecutorService executorService = Executors.newSingleThreadScheduledExecutor();
protected String[] powers = {
  //COMMON ITEMS
  "Skates", // Move Faster. 
  "Hose", // +1 to Explosion Radius.
  "SpareBalloon", //+1 to MaxBalloons.
  "Skates",
  "Hose",
  "SpareBalloon",
  "Skates",
  "Hose",
  "SpareBalloon",
  "Skates",
  "Hose",
  "SpareBalloon",
  "Skates",
  "Hose",
  "SpareBalloon",
  "Skates",
  "Hose",
  "SpareBalloon",
  "Skates",
  "Hose",
  "SpareBalloon",
  //UNCOMMON ITEMS
  "HardHat", // Makes you immune to your own balloon explosions.
  "BoxingGlove", // Allows you to push your own bombs.
  "Raincoat", // +1 Life. 
  "Hydrogen", // Balloons are stronger.
  "HardHat", 
  "BoxingGlove", 
  "Raincoat",
  "Hydrogen", 
  "HardHat", 
  "BoxingGlove", 
  "Raincoat",
  "Hydrogen", 
  //RARE ITEMS
  "PiercingBalloon", // Allows Balloon explosions to pierce through walls.
  "RollerBlades", // Max Speed.
  "PackOfBalloons", // Max Amount of Balloons.
  "Sponge", // +3 Lives.
  "WaterTank", // Max Explosion Radius.
  //Uh Oh!
  "balloon", // because im evil :)
  "balloon",
  "balloon"

};
protected String[] rarepowers = {
  "PiercingBalloon",
  "RollerBlades",
  "PackOfBalloons",
  "Sponge",
  "WaterTank"
};

//SOUNDS

//SoundFile splash;
SoundFile pausesound;
SoundFile kicksound;
SoundFile placeSound;
SoundFile boomSound;
SoundFile lifeSound;
//INPUTS



//P1
int[] p1movekeys = {
  87, //up
  65, //left
  83, //down
  68 //right
};
int ekey = 69;
boolean p1movedebounce = false;
//P2
int[] p2movekeys = {
  38, //up
  37, //left
  40, //down
  39 //right
};
int space = 32;
boolean p2movedebounce = false;

int esc = 27;
//SoundFile song;



//Required Processing method that gets run once
void setup() {
  frameRate(60);
  //Match the screen size to the background image size
  size(800, 600);
  //Set the title on the title bar
  surface.setTitle(titleText);
  //Load images used
  //bg = loadImage("images/chess.jpg");
  bg = loadImage("images/werksugvfuywegg.jpg");
  bg.resize(800,600);
  endScreen = loadImage("images/youwin.png");
  reset();
  pausesound = new SoundFile(this, "sounds/Pause.wav");
  kicksound = new SoundFile(this, "sounds/Kick.wav");
  placeSound = new SoundFile(this, "sounds/place.wav");
  boomSound = new SoundFile(this, "sounds/Boom.wav");
  lifeSound = new SoundFile(this, "sounds/1up.wav");
  // Load a soundfile from the /data folder of the sketch and play it back
  // song = new SoundFile(this, "sounds/Lenny_Kravitz_Fly_Away.mp3");
  // song.play();
  //splash = new SoundFile(this,"sounds/splash.wav");

  //splash.play();

  
  //Animation & Sprite setup
  exampleAnimationSetup();

  imageMode(CORNER);    //Set Images to read coordinates at corners
  //fullScreen();   //only use if not using a specfic bg image
  
  println("Game started...");

}

//Required Processing method that automatically loops
//(Anything drawn on the screen should be called from here)
void draw() {
  delta = millis() - lastTime;
  updateTitleBar();
  if (gamestate == 0){
    initgame();
  } else{
    playinggame(delta);
  }
  lastTime = millis();
  msElapsed+=(1/60);
}

//Known Processing method that automatically will run whenever a key is pressed
void keyPressed(){

  //check what key was pressed
  System.out.println("Key pressed: " + keyCode); //keyCode gives you an integer for the key

  //What to do when a key is pressed?
  
  //player 1 movement
  if (gamestate == 1){
  if(keyCode == p1movekeys[0] || keyCode == p1movekeys[1] || keyCode == p1movekeys[2] || keyCode == p1movekeys[3]){
    if (player1.getMoveTimer() <= 0){
      movePlayer(player1,player2,p1movekeys,keyCode);
    }
    else if (player1.getMoveTimer() <= player1.getMaxMoveTimer()/1.25 && p1movedebounce == false){
      p1movedebounce = true;
      int key = keyCode;
      Runnable movement = () -> movePlayer(player1,player2,p1movekeys,key);
      executorService.schedule(movement, player1.getMoveTimer(), TimeUnit.MILLISECONDS);
    }
  }
  if (keyCode == ekey && !(blocklist[player1.getX()][player1.getY()] != null && blocklist[player1.getX()][player1.getY()].getLocation().equals(player1.getLocation())) && player1.getBombs() < player1.getMaxBombs()) {
    placeBomb(player1);
  }
  //Player2 movement

  if(keyCode == p2movekeys[0] || keyCode == p2movekeys[1] || keyCode == p2movekeys[2] || keyCode == p2movekeys[3]){
    if (player2.getMoveTimer() <= 0){
      movePlayer(player2,player1,p2movekeys,keyCode);
    }
    else if (player2.getMoveTimer() <= player2.getMaxMoveTimer()/1.25 && p2movedebounce == false){
      p2movedebounce = true;
      int key = keyCode;
      Runnable movement = () -> movePlayer(player2,player1,p2movekeys,key);
      executorService.schedule(movement, player2.getMoveTimer(), TimeUnit.MILLISECONDS);
    }
  } //end Player2movement
  if (keyCode == space && !(blocklist[player2.getX()][player2.getY()] != null && blocklist[player2.getX()][player2.getY()].getLocation().equals(player2.getLocation())) && player2.getBombs() < player2.getMaxBombs()) {
    placeBomb(player2);
  }
  if (keyCode == esc){
    key = 0;
    if (canpause == true){
      canpause = false;
      gamestate = 2;
      Runnable pause = () -> resetPause();
      executorService.schedule(pause, 500, TimeUnit.MILLISECONDS);
      pausesound.play();
    }

    
  }
  }
  if (gamestate != 1 ){
    if (keyCode == esc){
      key = 0;
      if (canpause == true){
      canpause = false;
      if (gamestate != 2){
        reset();
      }
      else{
        pausesound.play();
      }
      gamestate = 1;
      Runnable pause = () -> resetPause();
      executorService.schedule(pause, 500, TimeUnit.MILLISECONDS);
      }
    }
  }
}
  
  //Known Processing method that automatically will run when a mouse click triggers it
  void mouseClicked(){
  
    //check if click was successful
    System.out.println("Mouse was clicked at (" + mouseX + "," + mouseY + ")");
    System.out.println("Grid location: " + grid.getGridLocation());

    //what to do if clicked? (Make player1 disappear?)
    if (gamestate != 1){
      if (gamestate != 2){
        reset();
      }
      else  {
          pausesound.play();
      }
      gamestate = 1;
    }

    //Toggle the animation on & off
    //doAnimation = !doAnimation;
    //System.out.println("doAnimation: " + doAnimation);
    //grid.setMark("X",grid.getGridLocation());
    
  }
  void initgame(){
    background(bg);
    textSize(64);
    textAlign(CENTER);
    text("Click to start", 800/2, 600/2);
  }
void playinggame(int dt){

  if (msElapsed % 300 == 0) {
    populateSprites();
    moveSprites();
  }

  updateScreen();
  

  checkExampleAnimation();
  //println(dt);
  if (gamestate == 1){
    update(dt);
  }
  msElapsed +=(1/60);
  //grid.pause(1/30);
  if (isGameOver() && gamestate != 3){
    gamestate = 3;
  }
  if (gamestate == 2){
    textSize(64);
    textAlign(CENTER);
    text("Paused", 800/2, 600/2);
  }
  if (gamestate == 3){
    textSize(64);
    textAlign(CENTER);
    if (player2.isLiving() && !(player1.isLiving())){
      text("Player 2 Wins!", 800/2, 600/2);
    } else if (!(player2.isLiving()) && player1.isLiving()) {
      text("Player 1 Wins!", 800/2, 600/2);
    } else {
      text("Tie!", 800/2, 600/2);
    }
  }
  }

  void reset(){
    grid.resetBList();
    grid.resetLootTimer();
    grid.generateLevel();
    PImage p1image = loadImage("images/x_wood.png");
    p1image.resize(grid.getTileWidthPixels(),grid.getTileHeightPixels());
    PImage p2image = loadImage("images/spook.png");
    p2image.resize(grid.getTileWidthPixels(),grid.getTileHeightPixels());
    player1 = new Player(p1image);
    player2 = new Player(p2image,maximumx-1,maximumy-1);
    Block[][] blocklist = grid.getBList();
  }

  public void update(int dt){
    grid.update(dt);
    for (int r = 0; r < blocklist.length; r++){
      for (int c = 0; c < blocklist[r].length; c++){
          if (blocklist[r][c] != null && blocklist[r][c].isAbleToUpdate() == true){
          Block b = blocklist[r][c];
          b.update(dt);
        }
      }
    }
    player1.update(dt);
    player2.update(dt);
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
    blocklist = grid.getBList();
    for (int x = 0; x < grid.getNumRows(); x++){
      for (int y = 0; y < grid.getNumCols(); y++){
        Block b = blocklist[x][y];
        if (b != null){
        GridLocation bloc = b.getLocation();
        grid.setTileImage(bloc,b.getImage());
        }
      }
    }

  //Loop through all the Tiles and display its images/sprites
  

      //Store temporary GridLocation
      
      //Check if the tile has an image/sprite 
      //--> Display the tile's image/sprite



  //update other screen elements

}
  void resetPause(){
    canpause = true;
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
public void movePlayer(Player moving, Player opponent, int[] keys, int keyCode){
    blocklist = grid.getBList();
    //check case where out of bounds
    //change the field for player1Row
    int x = moving.getX();
    int y = moving.getY();
   if (keyCode == keys[0] && moving.getX() > 0 && !(moving.getX()-1 == opponent.getX() && moving.getY()  == opponent.getY()) ){
    x--;
   }
   if (keyCode == keys[1] && moving.getY()  > 0 && !(moving.getY()-1 == opponent.getY() && moving.getX() == opponent.getX())) {
    y--;
   }
   if (keyCode == keys[2] && moving.getX() < grid.getNumRows()-1 && !(moving.getX()+1 == opponent.getX() && moving.getY()  == opponent.getY())) {
    x++;
   }
   if (keyCode == keys[3] && moving.getY() < grid.getNumCols()-1 && !(moving.getY()+1 == opponent.getY() && moving.getX() == opponent.getX())) {
    y++;
   }
    handleCollisions(x,y,moving,opponent,keyCode);
    if (moving == player1){
      p1movedebounce = false;
    }
    if (moving == player2){
      p2movedebounce = false;
    }
}
//Method to handle the collisions between Sprites on the Screen
public void handleCollisions(int x, int y, Player moving, Player opponent, int direction){
    blocklist = grid.getBList();
    boolean move = true;
    GridLocation loc = new GridLocation(x, y);
    if (opponent.collisionCheck(loc) == true) {
      move = false;
    }

    Block b = blocklist[x][y];
      if (b != null && b.getType().equals("Raincoat")){
        moving.addLife();
        lifeSound.play();
        blocklist[x][y] = null;
      }
      else if (b != null && b.getType().equals("Hose")){
        moving.raiseExplosionRadius();
        blocklist[x][y] = null;
      }
      else if (b != null && b.getType().equals("SpareBalloon")){
        moving.raiseMaxBombs();
        blocklist[x][y] = null;
      }
      else if (b != null && b.getType().equals("PiercingBalloon")){
        moving.piercePowerup();
        blocklist[x][y] = null;
      }
      else if (b != null && b.getType().equals("HardHat")){
        moving.sdImmunePowerup();
        blocklist[x][y] = null;
      }
      else if (b != null && b.getType().equals("BoxingGlove")){
        moving.glovePowerup();
        blocklist[x][y] = null;
      }
      else if (b != null && b.getType().equals("Skates")){
        moving.skatePowerup();
        blocklist[x][y] = null;
      }
      else if (b != null && b.getType().equals("RollerBlades")){
        moving.maxMoveSpeed();
        blocklist[x][y] = null;
      }
      else if (b != null && b.getType().equals("Sponge")){
        moving.addLife();
        moving.addLife();
        moving.addLife();
        lifeSound.play();
        blocklist[x][y] = null;
      }
      else if (b != null && b.getType().equals("WaterTank")){
        moving.setExplosionRadius(10);
        blocklist[x][y] = null;
      }
      else if (b != null && b.getType().equals("Hydrogen")){
        moving.strongerBombs();
        blocklist[x][y] = null;
      }
      else if (b != null && b.getType().equals("PackOfBalloons")){
        moving.setMaxBombs(5);
        blocklist[x][y] = null;
      }
      else if ((b != null && b.getLocation().equals(loc)) || (blocklist[moving.getX()][moving.getY()] != null && blocklist[moving.getX()][moving.getY()].getType().equals("Explosion"))){
        move = false;
        if (moving.canPush() == true && b != null && b.getLocation().equals(loc) && b.getType().equals("Balloon")){
          Block movable = blocklist[x][y];
          int dirx = x - moving.getX();
          int diry = y - moving.getY();
          movable.pushBomb(dirx,diry);
          kicksound.play();
        }
      }
    //shift the player1 picture up in the 2D array
    if (move == true) {
      placeSound.stop();
      placeSound.play();
      moving.resetMoveTimer();
      moving.setX(x);
      moving.setY(y);
      grid.setTileImage(loc,moving.getImage());
    }

}
public void placeBomb(Player placer){
    placeSound.stop();
    placeSound.play();
    placer.addBomb();
    PImage wall = loadImage("images/balloon.png");
    wall.resize(grid.getTileWidthPixels(),grid.getTileHeightPixels());
    GridLocation loc = placer.getLocation();
    grid.setMark("B", loc);
    grid.setTileImage(loc, wall);
    Block b = new Block(wall,loc,"Balloon",placer);
    grid.addBlock(b);
    System.out.println(blocklist);
}
//method to indicate when the main game is over
public boolean isGameOver(){
  return !(player1.isLiving() && player2.isLiving()); //game ends when one player dies.
}

//method to describe what happens after the game is over
public void endGame(){
    //System.out.println("Game Over!");

    //Update the title bar

    //Show any end imagery
    //background(bg);


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