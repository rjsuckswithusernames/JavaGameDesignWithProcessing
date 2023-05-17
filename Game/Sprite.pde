/* Sprite class - to create objects that move around with their own properties
 * Inspired by Daniel Shiffman's p5js Animated Sprite tutorial
 * Author: Joel Bianchi
 * Last Edit: 12/20/2022
 */

public class Sprite {
  
    PImage spriteImg;
    private float center_x;
    private float center_y;
    private float speed_x;
    private float speed_y;
    private float w;
    private float h;
    private boolean isAnimated;


  // Main Constructor
  public Sprite(String spriteImgPath, float scale, float x, float y, boolean isAnimated) {
    this.center_x = x;
    this.center_y = y;
    this.speed_x = 0;
    this.speed_y = 0;
    this.isAnimated = isAnimated;
    if(!isAnimated){
      this.spriteImg = loadImage(spriteImgPath);
      w = spriteImg.width * scale;
      h = spriteImg.height * scale;
    }
  }

  // Simpler Constructor for Non-Animated Sprite
  public Sprite(String spriteImg, float x, float y) {
    this(spriteImg, 1.0, x, y, false);
  }


  // method to display the Sprite image on the screen
  public void show() {
      image(spriteImg, this.center_x, this.center_y, w, h);
  }

  // method to move Sprite image on the screen to a specific coordinate
  public void moveTo(float x, float y){
    this.center_x = x;
    this.center_y = y;
  }

  // method to move Sprite image on the screen relative to current position
  public void move(float change_x, float change_y){
    this.center_x += change_x;
    this.center_y += change_y;
  }

  // method that automatically moves the Sprite based on its velocity
  public void update(){
    move(speed_x, speed_y);
  }


  // method to rotate Sprite image on the screen
  public void rotate(float degrees){

  }


  /*-- ACCESSOR METHODS --*/
  public float getX(){
    return center_x;
  }
  public float getY(){
    return center_y;
  }
  public PImage getImg(){
    return spriteImg;
  }
  public boolean getIsAnimated(){
    return isAnimated;
  }
  
  
  /*-- MUTATOR METHODS --*/
  public void setX(float x){
    this.center_x = x;
  }
  public void setY(float y){
    this.center_y=y;
  }
  public void setImg(PImage img){
    this.spriteImg = img;
  }
  public void setIsAnimated(boolean a){
    isAnimated = a;
  }


  /*-- SPRITE BOUNDARY METHODS --
    -- Used from Long Bao Nguyen
    -- https://longbaonguyen.github.io/courses/platformer/platformer.html
  */
  void setLeft(float left){
    center_x = left + w/2;
  }
  float getLeft(){
    return center_x - w/2;
  }
  void setRight(float right){
    center_x = right - w/2;
  }
  float getRight(){
    return center_x + w/2;
  }
  void setTop(float top){
    center_y = top + h/2;
  }
  float getTop(){
    return center_y - h/2;
  }
  void setBottom(float bottom){
    center_y = bottom - h/2;
  }
  float getBottom(){
    return center_y + h/2;
  }
  

}