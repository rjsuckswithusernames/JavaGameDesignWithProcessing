/* Platform class
 * Stub constructors provided
 * Can be used with the following tutorials:
 * https://longbaonguyen.github.io/courses/platformer/platformer.html
 * Authors: __________________
 * Last Edit: 5/17/2023
 */

public class Platform {//extends Sprite {

	//Platform defined by it's center-x and top-Y positions
	public Platform(float posXCenter, float posYTop, float platWidth, float platHeight, color clr) {

		//pass along the center-x and center-y to Sprite super
		//super(posXCenter, posYTop + (platHeight/2), clr);
		//System.out.println("PlatTopY: " + posYTop + "\tPlatCenterY: " + (posYTop + (platHeight/2)));
		// setWidth(platWidth);
		// setHeight(platHeight);
		//setColor(Color.black);
	}

	public Platform(float posXCenter, float posYTop, float platWidth, float platHeight) {
		//pass along the center-x and center-y to Sprite super
		this(posXCenter, posYTop, platWidth, platHeight, color(0,0,0));
	}

}