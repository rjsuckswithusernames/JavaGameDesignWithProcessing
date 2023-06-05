/* World Class - Used to describe the screen of a pixel-based game
 * Authors: Joel Bianchi, Nathan Santos, Clive Sherwood
 * Last Edit: 6/5/2023
 * Modified for Processing
 * Can add copied sprites
 */

import java.util.ArrayList;

public class World {

    //World Fields
  //private static World currentWorld = null;
    private ArrayList<AnimatedSprite> sprites = new ArrayList<AnimatedSprite>();
    private PImage bg;
    private String name = "";
    private long lastTime = 0;
  public final static float timeUnitsPerSecond = 1000.0f; //World time based on 1000 milliseconds /second

    //WORLD CONSTRUCTORS
    //World Constructor #1
    public World(String name, PImage bgImg) {
        this.name = name;
        bg = bgImg;
    }
    //World Constructor #2
  public World(String name) {
    this(name, null);
  }
    //World Constructor #3
  public World() {
    this("default world", null);
  }


    //WORLD METHODS
    public void setBackgroundImage(PImage bg){
        background(bg);
    }

    public void setScreenSize(int w, int h){

    }

    //WORLD SPRITE METHODS
    public ArrayList<AnimatedSprite> getSprites(){
        return sprites;
    }

    //method to add a sprite to the world
  public void addSprite(AnimatedSprite sprite) {
    if (!sprites.contains(sprite)) {
      sprites.add(sprite);
    }
  }

    //method to add a copy of a sprite to a specific coordinate in the world
  public void addSpriteCopyTo(AnimatedSprite sprite, float x, float y) {
    sprites.add(sprite.copyTo(x,y));
  }

    //method to add a copy of a sprite to the world
  public void addSpriteCopy(AnimatedSprite sprite) {
    sprites.add(sprite.copy());
  }


  //method to remove a sprite from the world
  public void removeSprite(AnimatedSprite sprite) {
    if (sprites.contains(sprite)) {
      sprites.remove(sprite);
    }
  }

    //method to display all the sprites on the screen
    public void showSprites(){
        
        System.out.println("showing sprites...");
        //Loop through all the sprites
        for(AnimatedSprite sprite : sprites){
            sprite.show();        
        }

    }

    //method to print out list of sprites
    public void printSprites(){
        for(Sprite sprite: sprites){
            System.out.println(sprite);
        }
    }

    //WORLD TIME METHODS
    public long getWorldTime(){
        return millis();  //milliseconds world
    }


  //WORLD MUTATOR METHODS

  //method to update all sprites in the world
  public void update() {
    
    //update the World time (converted to seconds)
    float deltaTime = (getWorldTime() - lastTime) / timeUnitsPerSecond;
    lastTime = getWorldTime();

    //each cycle, make all sprites move
    for (AnimatedSprite sprite : sprites) {
      sprite.update(deltaTime);
    }
    }

}
