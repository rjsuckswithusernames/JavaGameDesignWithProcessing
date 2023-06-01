/* World Class - Used to describe the screen of a pixel-based game
 * Authors: Joel Bianchi, Nathan Santos, Clive Sherwood
 * Last Edit: 5/31/2023
 * Modified for Processing
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


    //WORLD METHODS
    public void setBackgroundImage(PImage bg){
        background(bg);
    }

    public void setScreenSize(int w, int h){

    }

    public ArrayList<AnimatedSprite> getSprites(){
        return sprites;
    }

    //WORLD SPRITE METHODS

    //method to add a sprite to the world
	public void addSprite(AnimatedSprite sprite) {
		if (!sprites.contains(sprite)) {
			sprites.add(sprite);
		}
	}

	//method to remove a sprite from the world
	public void removeSprite(AnimatedSprite sprite) {
		if (sprites.contains(sprite)) {
			sprites.remove(sprite);
		}
	}

    //WORLD TIME METHODS
    public long getWorldTime(){
        return millis();	//milliseconds world
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
