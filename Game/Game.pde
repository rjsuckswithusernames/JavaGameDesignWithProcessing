/* Game Class Starter File
 * Last Edit: 12/13/2022
 * Authors: Raymond Morel, Muhammad Zahid
 */
import java.util.concurrent.*;
import java.util.ArrayList;
import processing.sound.*;
//UI Variables
int playX,playY;
int playSizeX = 400;
int playSizeY = 150;
int instructX, instructY;
int instructSizeX = 300;
int instructSizeY = 100;
color playColor, instructColor;
color playShade, instructShade;
boolean playOver = false;
boolean instructOver = false;
boolean backOver = false;
PImage controls;
//GAME VARIABLES
private int msElapsed = 0;
boolean canpause = true;
protected int gamestate = 0; // 0: Main Menu, 1: Game, 2: Paused, 3: Game-Over
protected int submenu = 0; // 0: Title, 1: Instructions

int maximumx = 12;
int maximumy = 13;
int lastTime = 0;
int delta = 0;
protected Grid grid = new Grid(maximumx,maximumy);
PImage bg;

Player player1;
Player player2;
PImage p1image;
PImage p2image;
int p1score = 0;
int p2score = 0;
PImage endScreen;
String titleText = "Fire Fighters";
String extraText = "by Raymond Morel & Muhammad Zahid";
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
protected int[][] extradirs = 
{
  {-1,-1}, // up-left
  {-1,1}, // up-right
  {1,-1}, // down-left
  {1,1} // down-right
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
protected ArrayList<PImage> p1Powers;
protected ArrayList<PImage> p2Powers;
protected String[] rarepowers = {
  "PiercingBalloon",
  "RollerBlades",
  "PackOfBalloons",
  "WaterTank",
  "Sponge"
};

//SOUNDS

//SoundFile splash;
SoundFile pausesound;
SoundFile kicksound;
SoundFile placeSound;
SoundFile boomSound;
SoundFile itemSound;
SoundFile moveSound;
SoundFile goSound;
SoundFile spawnSound;
SoundFile music;
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

//Instruct Images
PImage skat;
PImage spare;
PImage hos;
PImage coat;
PImage hat;
PImage hydro;
PImage blades;
PImage pack;
PImage tank;
PImage spon;
PImage glove;
PImage pier;
//Item Images
PImage skates;
PImage spareBalloon;
PImage hose;
PImage raincoat;
PImage hardHat;
PImage hydrogen;
PImage rollerblades;
PImage packOfBalloons;
PImage waterTank;
PImage sponge;
PImage boxingGlove;
PImage piercingBalloon;
PImage wall;
PImage fire;
PImage bl;
PImage kaboom;




//Required Processing method that gets run once
void setup() {
  frameRate(60);
  //Match the screen size to the background image size
  size(800, 600);
  //Set the title on the title bar
  surface.setTitle(titleText);
  //Load images used
  //bg = loadImage("images/chess.jpg");
  bg = loadImage("images/background.jpeg");
  bg.resize(800,600);
  endScreen = loadImage("images/youwin.png");
  setupButtons();
  setupImgs();
  reset();
  pausesound = new SoundFile(this, "sounds/Pause.wav");
  kicksound = new SoundFile(this, "sounds/Kick.wav");
  placeSound = new SoundFile(this, "sounds/Place.wav");
  boomSound = new SoundFile(this, "sounds/Boom.wav");
  itemSound = new SoundFile(this, "sounds/Collect.wav");
  moveSound = new SoundFile(this, "sounds/Move.wav");
  goSound = new SoundFile(this, "sounds/gameover.wav");
  spawnSound = new SoundFile(this, "sounds/Spawn.wav");
  music = new SoundFile(this, "sounds/MusicLoop.wav");
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
      music.amp(.5);
      canpause = false;
      gamestate = 2;
      Runnable pause = () -> resetPause();
      executorService.schedule(pause, 500, TimeUnit.MILLISECONDS);
      pausesound.stop();
      pausesound.play();
    }

    
  }
  }
  if (gamestate != 1 && gamestate != 0){
    if (keyCode == esc){
      key = 0;
      if (canpause == true){
      canpause = false;
      if (gamestate != 2){
        reset();
        music.amp(1);
      }
      else{
        music.amp(1);
        pausesound.stop();
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
        if (gamestate == 0){
          if (playOver){
            reset();
            gamestate = 1;
            music.amp(1);
            music.loop();
          }
          if (backOver){
            submenu = 0;
          }
          if (instructOver){
            submenu = 1;
          }
        }
        else{
          reset();
          music.amp(1);
          gamestate = 1;
        }
      }
      else  {
        
        pausesound.stop();
        pausesound.play();
        if (playOver) {
          music.amp(1);
          gamestate = 1;
        } else if (instructOver) {
          p1score = 0;
          p2score = 0;
          gamestate = 0;
          music.stop();
        }

      }
    }

    //Toggle the animation on & off
    //doAnimation = !doAnimation;
    //System.out.println("doAnimation: " + doAnimation);
    //grid.setMark("X",grid.getGridLocation());
    
  }

  boolean overRect(int x, int y, int width, int height)  {
    if (mouseX >= x && mouseX <= x+width && 
        mouseY >= y && mouseY <= y+height) {
      return true;
    } else {
      return false;
    }
  }

  void initgame(){
    if (submenu == 0){
      background(bg);
      textSize(64);
      textAlign(CENTER);
      fill(255);
      text(titleText, 800/2, 600/5);
      textSize(20);
      text(extraText, 800/2, 600/4);
      textSize(64);
      if (overRect(playX,playY, playSizeX, playSizeY)){
        playOver = true;
        instructOver = false;
        backOver = false;
      } else if (overRect(instructX,instructY, instructSizeX, instructSizeY)){
        playOver = false;
        instructOver = true;
        backOver = false;
      } else {
        playOver = instructOver = backOver = false;
      }
      if (playOver){
        fill(playShade);
      } else {
        fill(playColor);
      }
      rect(playX, playY, playSizeX, playSizeY,5);
      fill(0);
      text("Play",800/2,600/2);
      if (instructOver){
        fill(instructShade);
      } else {
        fill(instructColor);
      }
      rect(instructX, instructY, instructSizeX, instructSizeY,5);
      fill(0);
      textSize(48);
      text("Rules",800/2,600/1.25);
    } else if (submenu == 1) {
      background(255);
      textSize(64);
      textAlign(RIGHT);
      //fill(255);
      //text("Fire Fighters", 800/2, 600/5);
     if (overRect(0, 0, 200, 50)) {
        playOver = false;
        instructOver = false;
        backOver = true;
      } else {
        playOver = false;
        instructOver = false;
        backOver = false;
      }
      if (backOver){
        fill(200,110,0);
      } else {
        fill(255,165,0);
      }
      rect(0,0,200,50,5);
      fill(0);
      textSize(32);
      text("Back",100,30);
      textAlign(LEFT);
      textSize(16);
      text("Move with WASD (p1) and Arrow Keys (p2), and place balloons with E (p1) and Spacebar (p2).",0,55,220,80);
      textSize(11);
      text("Your goal is to splash up the opponent with balloons. Balloons explode after 2 seconds, or when caught in another balloon's explosion. Just hope that you aren't in the recieving end! Balloon explosions extinguishes fire walls. There are powerups to collect throughout the game. Their effects are listed below. Have Fun!",575,0,225,130);
      textSize(16);
      image(controls,800/2-controls.width/2,0);
      image(skat, 50-skat.width/2, 140);
      text("Increases your speed slightly.",80,140+25);
      image(spare, 50-spare.width/2, 220);
      text("Can place one more balloon at a time.",80,220+25);
      image(hos, 50-hos.width/2, 300);
      text("Larger splash radius.",80,300+25);
      image(coat, 50-coat.width/2, 380);
      text("Allows you to take one more hit.",80,380+25);
      image(hat, 50-hat.width/2, 460);
      text("You are no longer able to hurt yourself.",80,460+25);
      image(hydro, 50-hydro.width/2, 540);
      text("Your balloons hurt more. Doesn't stack.",80,540+25);
      text("Increases your speed to the maximum.",430,140+25);
      image(blades,800/2-blades.width/2, 140);
      image(pack,800/2-pack.width/2, 220);
      text("Gives you the maximum of 5 balloons to use at once.",430,220+25);
      image(tank,800/2-tank.width/2, 300);
      text("Increases your splash radius to the maximum.",430,300+25);
      image(spon,800/2-spon.width/2, 380);
      text("Allows the explosions to go diagonally.",430,380+25);
      image(glove,800/2-glove.width/2, 460);
      text("You can push balloons by running into them!",430,460+25);
      image(pier,800/2-pier.width/2, 540);
      text("Allows balloon explosions to pierce through walls.",430,540+25);
    }

  }
  void setupImgs(){
      skat = loadImage("images/Skates.png");
      skat.resize(50,50);
      spare = loadImage("images/SpareBalloon.png");
      spare.resize(50,50);
      hos = loadImage("images/Hose.png");
      hos.resize(50,50);
      coat = loadImage("images/Raincoat.png");
      coat.resize(50,50);
      hat = loadImage("images/HardHat.png");
      hat.resize(50,50);
      hydro = loadImage("images/Hydrogen.png");
      hydro.resize(50,50);
      blades = loadImage("images/RollerBlades.png");
      blades.resize(50,50);
      pack = loadImage("images/PackOfBalloons.png");
      pack.resize(50,50);
      tank = loadImage("images/WaterTank.png");
      tank.resize(50,50);
      spon = loadImage("images/Sponge.png");
      spon.resize(50,50);
      glove = loadImage("images/BoxingGlove.png");
      glove.resize(50,50);
      pier = loadImage("images/PiercingBalloon.png");
      pier.resize(50,50);
      skates = loadImage("images/Skates.png");
      spareBalloon = loadImage("images/SpareBalloon.png");
      hose = loadImage("images/Hose.png");
      raincoat = loadImage("images/Raincoat.png");
      hardHat = loadImage("images/HardHat.png");
      hydrogen = loadImage("images/Hydrogen.png");
      rollerblades = loadImage("images/RollerBlades.png");
      packOfBalloons = loadImage("images/PackOfBalloons.png");
      waterTank = loadImage("images/WaterTank.png");
      sponge = loadImage("images/Sponge.png");
      boxingGlove = loadImage("images/BoxingGlove.png");
      piercingBalloon = loadImage("images/PiercingBalloon.png");
      kaboom = loadImage("images/splash.png");
      kaboom.resize(grid.getTileWidthPixels(),grid.getTileHeightPixels());
      fire = loadImage("images/Fire.png");
      fire.resize(grid.getTileWidthPixels(),grid.getTileHeightPixels());
      wall = loadImage("images/bricks.jpg");
      wall.resize(grid.getTileWidthPixels(),grid.getTileHeightPixels());
      bl = loadImage("images/balloon.png");
      bl.resize(grid.getTileWidthPixels(),grid.getTileHeightPixels());
      //PImage Skates
      //PImage
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
    goSound.stop();
    goSound.play();
    if (player2.isLiving() && !(player1.isLiving())){
      p2score++;
    } else if (!(player2.isLiving()) && player1.isLiving()) {
      p1score++;
    }
    gamestate = 3;
    music.amp(.5);
    
  }
  if (gamestate == 2){
    textSize(64);
    textAlign(CENTER);
    fill(255);
    textSize(64);
    textAlign(CENTER);
    fill(255);
    text("Paused.", 800/2, 600/5);
    if (overRect(playX,playY, playSizeX, playSizeY)){
      playOver = true;
      instructOver = false;
    } else if (overRect(instructX,instructY, instructSizeX, instructSizeY)){
      playOver = false;
      instructOver = true;
    } else {
      playOver = instructOver = false;
    }
    if (playOver){
      fill(playShade);
    } else {
      fill(playColor);
    }
    rect(playX, playY, playSizeX, playSizeY,5);
    fill(0);
    text("Continue",800/2,600/2);
    if (instructOver){
      fill(instructShade);
    } else {
      fill(instructColor);
    }
    rect(instructX, instructY, instructSizeX, instructSizeY,5);
    fill(0);
    textSize(48);
    text("Quit",800/2,600/1.25);
  }
  if (gamestate == 3){
    textSize(64);
    textAlign(CENTER);
    fill(255);
    if (player2.isLiving() && !(player1.isLiving())){
      text("Player 2 Wins!", 800/2, 600/2);
    } else if (!(player2.isLiving()) && player1.isLiving()) {
      text("Player 1 Wins!", 800/2, 600/2);
    } else {
      text("Tie!", 800/2, 600/2);
    }
    text("Player 1: "+p1score,200,450);
    text("Player 2: "+p2score,600,450);
  }
  }

  void reset(){
    grid.resetBList();
    grid.resetLootTimer();
    grid.generateLevel();
    PImage p1image = loadImage("images/player1.png");
    p1image.resize(grid.getTileWidthPixels(),grid.getTileHeightPixels());
    PImage p2image = loadImage("images/player2.png");
    p2image.resize(grid.getTileWidthPixels(),grid.getTileHeightPixels());
    player1 = new Player(p1image);
    player2 = new Player(p2image,maximumx-2,maximumy-1);
    p1Powers = new ArrayList<PImage>();
    p2Powers = new ArrayList<PImage>();
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

void setupButtons(){
  controls = loadImage("images/controls.png");
  controls.resize(350,0);
  instructColor = color(255,0,0);
  playColor = color(0,255,0);
  instructShade = color(200,0,0);
  playShade = color(0,200,0);
  playX = 800/2-playSizeX/2;
  playY = 600/2-playSizeY/2;
  instructX = 800/2-instructSizeX/2;
  instructY = 480-playSizeY/2;
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
    for (int x = 0; x < grid.getNumRows()-1; x++){
      for (int y = 0; y < grid.getNumCols(); y++){
        Block b = blocklist[x][y];
        if (b != null){
        GridLocation bloc = b.getLocation();
        grid.setTileImage(bloc,b.getImage());
        }
      }
    }
    
    for (int p = 0; p < p1Powers.size(); p++){
      PImage powimage = p1Powers.get(p);
      powimage.resize(Math.min(grid.getTileWidthPixels(),400/p1Powers.size()),grid.getTileHeightPixels()); 
      image(powimage,0+powimage.width*p, 550);
    }
      for (int p = 0; p < p2Powers.size(); p++){
      PImage powimage = p2Powers.get(p);
      powimage.resize(Math.min(grid.getTileWidthPixels(),400/p2Powers.size()),grid.getTileHeightPixels()); 
      image(powimage,800-powimage.width*(p+1), 550);
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
  if (gamestate != 1){
    return;
  }
    blocklist = grid.getBList();
    //check case where out of bounds
    //change the field for player1Row
    int x = moving.getX();
    int y = moving.getY();
   if (keyCode == keys[0]){
    x--;
   }
   if (keyCode == keys[1]) {
    y--;
   }
   if (keyCode == keys[2]) {
    x++;
   }
   if (keyCode == keys[3]) {
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
    if (x < 0 || x >= grid.getNumRows()-1 || y < 0 || y >= grid.getNumCols()){
      return;
    }
    if (loc.equals(opponent.getLocation())) {
      move = false;
    }
    ArrayList<PImage> powlist;
    if (moving == player2){
      powlist = p2Powers;
    } else {
      powlist = p1Powers;
    }
    Block b = blocklist[x][y];
      if (b != null && b.getType().equals("Raincoat")){
        moving.addLife();
        itemSound.stop();
        itemSound.play();
        blocklist[x][y] = null;
        powlist.add(raincoat.copy());
      }
      else if (b != null && b.getType().equals("Hose")){
        itemSound.stop();
        itemSound.play();
        moving.raiseExplosionRadius();
        blocklist[x][y] = null;
        powlist.add(hose.copy());
      }
      else if (b != null && b.getType().equals("SpareBalloon")){
        itemSound.stop();
        itemSound.play();
        moving.raiseMaxBombs();
        blocklist[x][y] = null;
        powlist.add(spareBalloon.copy());

      }
      else if (b != null && b.getType().equals("PiercingBalloon")){
        itemSound.stop();
        itemSound.play();
        moving.piercePowerup();
        blocklist[x][y] = null;
        if (!hasItem(powlist, piercingBalloon)){
          powlist.add(piercingBalloon.copy());
        }
      }
      else if (b != null && b.getType().equals("HardHat")){
        itemSound.stop();
        itemSound.play();
        moving.sdImmunePowerup();
        blocklist[x][y] = null;
        if (!hasItem(powlist, hardHat)){
          powlist.add(hardHat.copy());
        }
      }
      else if (b != null && b.getType().equals("BoxingGlove")){
        itemSound.stop();
        itemSound.play();
        moving.glovePowerup();
        blocklist[x][y] = null;
        if (!hasItem(powlist, boxingGlove)){
          powlist.add(boxingGlove.copy());
        }
      }
      else if (b != null && b.getType().equals("Skates")){
        itemSound.stop();
        itemSound.play();
        moving.skatePowerup();
        blocklist[x][y] = null;
        powlist.add(skates.copy());
      }
      else if (b != null && b.getType().equals("RollerBlades")){
        itemSound.stop();
        itemSound.play();
        moving.maxMoveSpeed();
        blocklist[x][y] = null;
        powlist.add(rollerblades.copy());
      }
      else if (b != null && b.getType().equals("Sponge")){
        itemSound.stop();
        itemSound.play();
        moving.setDiagonal();
        blocklist[x][y] = null;
        if (!hasItem(powlist, sponge)){
          powlist.add(sponge.copy());
        }
      }
      else if (b != null && b.getType().equals("WaterTank")){
        itemSound.stop();
        itemSound.play();
        moving.setExplosionRadius(10);
        blocklist[x][y] = null;
        powlist.add(waterTank.copy());
      }
      else if (b != null && b.getType().equals("Hydrogen")){
        itemSound.stop();
        itemSound.play();
        moving.strongerBombs();
        blocklist[x][y] = null;
        powlist.add(hydrogen.copy());
      }
      else if (b != null && b.getType().equals("PackOfBalloons")){
        itemSound.stop();
        itemSound.play();
        moving.setMaxBombs(5);
        blocklist[x][y] = null;
        powlist.add(packOfBalloons.copy());
      }
      else if ((b != null && b.getLocation().equals(loc)) || (blocklist[moving.getX()][moving.getY()] != null && blocklist[moving.getX()][moving.getY()].getType().equals("Explosion"))){
        move = false;
        if (moving.canPush() == true && b != null && b.getLocation().equals(loc) && b.getType().equals("Balloon")){
          Block movable = blocklist[x][y];
          int dirx = x - moving.getX();
          int diry = y - moving.getY();
          movable.pushBomb(dirx,diry);
          kicksound.stop();
          kicksound.play();
        }
      }
    //shift the player1 picture up in the 2D array
    if (move == true) {
      moveSound.stop();
      moveSound.play();
      moving.resetMoveTimer();
      moving.setX(x);
      moving.setY(y);
      grid.setTileImage(loc,moving.getImage());
    }

}
public boolean hasItem(ArrayList<PImage> haystack, PImage needle){
  for(int i = 0; i < haystack.size(); i++){
    if (haystack.get(i) == needle){
      return true;
    }
  }
  return false;
}
public void placeBomb(Player placer){
    placeSound.stop();
    placeSound.play();
    placer.addBomb();
    PImage wall = bl;
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