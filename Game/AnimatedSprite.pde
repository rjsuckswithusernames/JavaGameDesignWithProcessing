/* Animated Sprite class - useful to have Sprites move around
 * Designed to be used with Spritesheets & JSON Array files from TexturePacker software: 
 * https://free-tex-packer.com/app/
 * Inspired by Daniel Shiffman's p5js Animated Sprite tutorial: https://youtu.be/3noMeuufLZY
 * Author: Joel Bianchi
 * Last Edit: 5/22/2023
 */
 
public class AnimatedSprite extends Sprite{
  
    private String jsonPath;
    private ArrayList<PImage> animation;
    private int len;
    private float i_bucket;

    JSONObject spriteData;
    PImage spriteSheet;

  // Constructor for AnimatedSprite with Spritesheet (Must use the TexturePacker to make the JSON)
  // https://www.codeandweb.com/texturepacker
  public AnimatedSprite(String png, float x, float y, String json) {
    super(png, x, y, 1.0, true);

    this.jsonPath = json;
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

      this.len = this.animation.size();
      this.i_bucket = 0;
    }
    
    super.setW(this.animation.get(0).width);
    super.setH(this.animation.get(0).height);
    super.setLeft(x);
    super.setTop(y);
    //System.out.println("AS w: " + super.getW() + ",h: " + super.getH());
  }

  
  //Overriden method: Displays the correct frame of the Sprite image on the screen
  public void show() {
    int index = (int) Math.floor(Math.abs(this.i_bucket)) % this.len;
    image(animation.get(index), super.getLeft(), super.getTop());
    //System.out.println("Pos: "+ super.getX() +"," + super.getY());
  } 

  //Method to cycle through the images of the animated sprite
  public void animate(float animationSpeed){
    i_bucket +=  animationSpeed * 1;
    show();
  }

  //Method that makes animated sprite move in any straight line
  public void animateMove(float hSpeed, float vSpeed, float animationSpeed, boolean wraparound){
    
    //adjust speed & frames
    animate(animationSpeed);
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
  public String getJsonPath(){
    return this.jsonPath;
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