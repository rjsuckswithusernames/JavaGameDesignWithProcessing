/* Animated Sprite class - useful to have Sprites move around
 * Designed to be used with Spritesheets & JSON Array files from TexturePacker software: 
 * https://free-tex-packer.com/app/
 * Inspired by Daniel Shiffman's p5js Animated Sprite tutorial: https://youtu.be/3noMeuufLZY
 * Authors: Joel Bianchi, Aiden Sing, Tahlei Richardson
 * Last Edit: 5/31/2023
 * Edited jsonFile renamed to jsonFile
 * Revised Variable to track animation speed
 */
 
public class AnimatedSprite extends Sprite{
  
    private String jsonFile;
    private ArrayList<PImage> animation;
    // private int w;
    // private int h;
    private int len;
    private float iBucket;
    private float aSpeed; //variable to track how quickly the animation images cycle

    JSONObject spriteData;
    PImage spriteSheet;

  // Constructor #1 for AnimatedSprite with Spritesheet (Must use the TexturePacker to make the JSON)
  public AnimatedSprite(String png, String json, float x, float y, float aSpeed) {
    super(png, x, y, 1.0, true);
    
    this.jsonFile = json;
    this.animation = new ArrayList<PImage>();
 
    spriteData = loadJSONObject(json);
    spriteSheet = loadImage(png);
    JSONArray frames = spriteData.getJSONArray("frames");
    
    System.out.println("Loading Animated Sprite...");
    for(int i=0; i<frames.size(); i++){

      JSONObject frame = frames.getJSONObject(i);
      //System.out.println(i + ": " + frame + "\n");
      JSONObject fr = frame.getJSONObject("frame");
      //System.out.println("ss: " + fr + "\n");

      int sX = fr.getInt("x");
      int sY = fr.getInt("y");
      int sW = fr.getInt("w");
      int sH = fr.getInt("h");
      System.out.println(i + ":\t sX:" + sX + ":\t sY:" + sY + ":\t sW:" + sW + ":\t sH:" + sH);
      PImage img = spriteSheet.get(sX, sY, sW, sH);
      animation.add(img);

      // this.w = this.animation.get(0).width;
      // this.h = this.animation.get(0).height;
      this.len = this.animation.size();
      this.iBucket = 0.0;
      this.aSpeed = aSpeed;
    }
    super.setW(this.animation.get(0).width);
    super.setH(this.animation.get(0).height);
    super.setLeft(x);
    super.setTop(y);
    //System.out.println("AS w: " + super.getW() + ",h: " + super.getH());

  }

  //Constructor #2: animations + starting coordinates
  public AnimatedSprite(String png, String json, float x, float y ) {
    this(png, json, x, y, 1.0);
  }

  // Constructor #3 taking in images and json only
  public AnimatedSprite(String png, String json) {
    this(png, 0.0, 0.0, json);
  }

  // Legacy Constructor for 2022 version
  public AnimatedSprite(String png, float x, float y, String json) {
    this(png, json, x, y);
  }


  //Overriden method: Displays the correct frame of the Sprite image on the screen
  public void show() {
    int index = (int) Math.floor(Math.abs(this.iBucket)) % this.len;
    image(animation.get(index), super.getLeft(), super.getTop());
    //System.out.println("aSpeed: "+ aSpeed+"\tib: "+iBucket+"\t ind: "+ index);
    //System.out.println("Pos: "+ super.getX() +"," + super.getY());
  } 

  //Method to cycle through the images of the animated sprite & reset a new animation speed
  public void animate(float animationSpeed){
    this.aSpeed = animationSpeed;
    animate();
  }

  //Method to cycle through the images of the animated sprite
  public void animate(){
    iBucket += aSpeed/this.len;
    show();
  }

  //Method that makes animated sprite move in any straight line + sets animation speed
  public void animateMove(float hSpeed, float vSpeed, float animationSpeed, boolean wraparound){
    this.aSpeed = animationSpeed;
    animateMove(hSpeed, vSpeed, wraparound);
  }
  
  //Method that makes animated sprite move in any straight line
  public void animateMove(float hSpeed, float vSpeed, boolean wraparound){
    
    //adjust speed & frames
    animate();
    super.move( (int) (hSpeed * 10), (int) (vSpeed * 10) );
  
    //wraparound sprite if goes off the right or left
    if(wraparound){
      wraparoundHorizontal();
      wraparoundVertical();
    }
  }

  //animated method that makes the Sprite move to the right-left
  public void animateHorizontal(float horizontalSpeed, float animationSpeed, boolean wraparound) {
    animateMove(horizontalSpeed, 0, animationSpeed, wraparound);
  }

  //animated method that makes the Sprite move down-up
  public void animateVertical(float verticalSpeed, float animationSpeed, boolean wraparound) {
    animateMove(0, verticalSpeed, animationSpeed, wraparound);
  }

  //Accessor method for the JSON path
  public String getJsonFile(){
    return this.jsonFile;
  }
  
  //Mutator method for the speed of the animation -Aiden Sing & Tahlei Richardson, 2023
  public void setAnimationSpeed(float aSpeed) {
    this.aSpeed = aSpeed;
  }

  //Method to resize the animated sprite images to different dimensions
  public void resize(int x, int y){
    for(int i=0; i<animation.size(); i++){
      PImage pi = animation.get(i);
      pi.resize(x,y);
    }
  }
  
  

  //---------------------PRIVATE HELPER METHODS--------------------------//

  //wraparound sprite if goes off the right-left
  private void wraparoundHorizontal(){
    if ( super.getLeft() > width ) {
      super.setLeft( -super.getW() );
    } else if ( super.getRight() < -width ){
      super.setRight( width );
    }
  }

  //wraparound sprite if goes off the top-bottom
  private void wraparoundVertical(){
    if ( super.getTop() > height ) {
      super.setTop( -super.getH() );
    } else if ( super.getBottom() < -height ){
      super.setBottom( height );
    }
  }


}
