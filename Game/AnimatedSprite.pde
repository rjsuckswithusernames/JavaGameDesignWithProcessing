/* Animated Sprite class - useful to have Sprites move around
 * Designed to be used with Spritesheets & JSON files from TexturePack software
 * Revised from Daniel Shiffman's p5js Animated Sprite tutorial
 * Author: Joel Bianchi
 * Last Edit: 5/17/2023

 * https://editor.p5js.org/codingtrain/sketches/vhnFx1mml
 * http://youtube.com/thecodingtrain
 * https://thecodingtrain.com/CodingChallenges/111-animated-sprite.html

 * Example Horse Spritesheet from
 * https://opengameart.org/content/2d-platformer-art-assets-from-horse-of-spring

 * Example Animated Sprite
 * https://youtu.be/3noMeuufLZY
 */
 
public class AnimatedSprite extends Sprite{
  
    private ArrayList<PImage> animation;
    private int w;
    private int h;
    private int len;
    private int index;

    JSONObject spriteData;
    PImage spriteSheet;

  // Constructor for AnimatedSprite with Spritesheet (Must use the TexturePacker to make the JSON)
  // https://www.codeandweb.com/texturepacker
  public AnimatedSprite(String png, float x, float y, String json) {
    super("none", x, y, 1.0, true);

    this.animation = new ArrayList<PImage>();
 
    spriteData = loadJSONObject(json);
    spriteSheet = loadImage(png);
    JSONArray frames = spriteData.getJSONArray("frames");
    
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

      this.w = this.animation.get(0).width;
      this.h = this.animation.get(0).height;
      this.len = this.animation.size();
      this.index = 0;
    }
  }

  //Overriden method: Displays the correct frame of the Sprite image on the screen
  public void show() {
    int index = (int) Math.floor(Math.abs(this.index)) % this.len;
    image(animation.get(index), super.getX(), super.getY());
    //System.out.println("Pos: "+ super.getX() +"," + super.getY());
  } 

  //Method to cycle through the images of the animated sprite
  public void animate(float animationSpeed){
    index += (int) (animationSpeed * 10);
    show();
  }

  //animated method that makes the Sprite move to the right-left
  public void animateHorizontal(float horizontalSpeed, float animationSpeed, boolean wraparound) {

    //adjust speed & frames
    animate(animationSpeed);
    super.move( (int) (horizontalSpeed * 10), 0 );
  
    //wraparound sprite if goes off the right or left
    if(wraparound){
      wraparoundHorizontal();
    }

  }

  //animated method that makes the Sprite move down-up
  public void animateVertical(float verticalSpeed, float animationSpeed, boolean wraparound) {

    //adjust speed & frames
    animate(animationSpeed);
    super.move( 0, (int) (verticalSpeed * 10));
  
    //wraparound sprite if goes off the bottom or top
    if(wraparound){
      wraparoundVertical();
    }
  }

  //wraparound sprite if goes off the right-left
  private void wraparoundHorizontal(){
    if ( super.getX() > width ) {
      super.setX( -this.w );
    } else if ( super.getX() < -width ){
      super.setX( width );
    }
  }

  //wraparound sprite if goes off the top-bottom
  private void wraparoundVertical(){
    if ( super.getY() > height ) {
      super.setY( -this.h );
    } else if ( super.getY() < -height ){
      super.setY( height );
    }
  }


}