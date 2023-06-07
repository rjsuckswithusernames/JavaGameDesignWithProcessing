/* World Class - Used to describe the screen of a pixel-based game
 * Subclass of a Screen, but now includes an ArrayList of AnimatedSprite objects
 * Authors: Joel Bianchi, Nathan Santos, Clive Sherwood
 * Last Edit: 6/6/2023
 * Modified for Processing
 * Can add copied sprites
 * Made a subclass of Screen
 */

import java.util.ArrayList;

public class World extends Screen{

  //World Fields
  //private static World currentWorld = null;
  private ArrayList<AnimatedSprite> sprites = new ArrayList<AnimatedSprite>();
  long lastTime = 0;

  //WORLD CONSTRUCTORS
  //World Constructor #1
  public World(String name, PImage bgImg) {
    super(name, bgImg);
  }
  //World Constructor #2
  public World(String name) {
    this(name, null);
  }
    //World Constructor #3
  public World() {
    this("default world", null);
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


  //WORLD MUTATOR METHODS
  
  //method to update all sprites in the world each cycle
  public void update() {
    long deltaTime = getTimeSince(lastTime);
    for (AnimatedSprite sprite : sprites) {
      sprite.update(deltaTime);
    }
    lastTime = getScreenTime();
  }

}
