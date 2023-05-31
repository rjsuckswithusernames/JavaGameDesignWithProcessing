/* Sprite class - to create objects that move around with their own properties
 * Inspired by Daniel Shiffman's p5js Animated Sprite tutorial
 * Author: Joel Bianchi
 * Last Edit: 5/31/22
 * Modified to account for picture coordinates at Top, Left corner
 * Added Constructor #3
 * spriteImgPath renamed to spriteImgFile
 */

public class Sprite {
  
    PImage spriteImg;
    private String spriteImgFile;
    private float center_x;
    private float center_y;
    private float speed_x;
    private float speed_y;
    private float w;
    private float h;
    private boolean isAnimated;


  // Main Constructor
  public Sprite(String spriteImgFile, float scale, float x, float y, boolean isAnimated) {
    this.spriteImgFile = spriteImgFile;
    setLeft(x);
    setTop(y);
    this.speed_x = 0;
    this.speed_y = 0;
    this.isAnimated = isAnimated;
    if(!isAnimated){
      this.spriteImg = loadImage(spriteImgFile);
      w = spriteImg.width * scale;
      h = spriteImg.height * scale;
    }

  }

  // Simpler Constructor for Non-Animated Sprite
  public Sprite(String spriteImgFile, float x, float y) {
    this(spriteImgFile, 1.0, x, y, false);
  }

  //Constructor #3: Only pass in the image
  public Sprite(String spriteImgFile){
    this(spriteImgFile, 0.0, 0.0);
  }


  // method to display the Sprite image on the screen
  public void show() {
      image(spriteImg, getLeft(), getTop(), w, h);
  }

  // method to move Sprite image on the screen to a specific coordinate
  public void moveTo(float x, float y){
    setLeft(x);
    setTop(y);
  }

  // method to move Sprite image on the screen relative to current position
  public void move(float change_x, float change_y){
    this.center_x += change_x;
    this.center_y += change_y;
    //System.out.println(getLeft() + "," + getTop());
  }

  // method that automatically moves the Sprite based on its velocity
  public void update(){
    move(speed_x, speed_y);
  }


  // method to rotate Sprite image on the screen
  public void rotate(float degrees){

  }


  /*-- ACCESSOR METHODS --*/

  public float getW(){
    return w;
  }
  public float getH(){
    return h;
  }
  public float getCenterX(){
    return center_x;
  }
  public float getCenterY(){
    return center_y;
  }
  public PImage getImg(){
    return spriteImg;
  }
  public boolean getIsAnimated(){
    return isAnimated;
  }
  
  
  /*-- MUTATOR METHODS --*/
  public void setW(float w){
    this.w = w;
  }
  public void setH(float h){
    this.h=h;
  }
  public void setCenterX(float center_x){
    this.center_x = center_x;
  }
  public void setCenterY(float center_y){
    this.center_y=center_y;
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
  

  //Accessor method to the image path of the Sprite
  public String getImagePath(){
    return this.spriteImgFile;
  }
  
  //Accessor method to the image path of the Sprite
  public PImage getImage(){
    return this.spriteImg;
  }


  // //Method to check if 2 Sprites are the same (based on String)
  // public boolean equals(Sprite otherSprite){
  //   if(this.spriteImgFile.equals(otherSprite.getImagePath())){
  //     return true;
  //   }
  //   return false;
  // }

  //Method to check if 2 Sprites are the same (based on PImage)
  public boolean equals(Sprite otherSprite){
    if(this.spriteImgFile != null && otherSprite != null && this.spriteImgFile.equals(otherSprite.getImagePath())){
      return true;
    }
    return false;
  }

  public String toString(){
    return spriteImgFile + "\t" + getLeft() + "\t" + getTop() + "\t" + speed_x + "\t" + speed_y + "\t" + w + "\t" + h + "\t" + isAnimated;
  }

}