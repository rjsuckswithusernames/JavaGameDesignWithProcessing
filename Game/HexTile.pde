/* HexTile Class
 * Based off code from Naomi Gaylor & Ezzeldin Moussa, June 2022
 * Last edit: 5/16/2023
 * Edited to be a subclass of GridTile pde file
 */

import java.awt.Polygon;
import java.awt.Point;

public class HexTile extends GridTile{
  
  private Polygon hexPoly;
  private float radius;
  private Point centerPixels;
  //private HexLocation hexLoc;

  //HexTile Constructor #1: GridLocation
  public HexTile(HexLocation loc, float rad){
    super(loc);
    //this.hexLoc = loc;
    this.radius = rad;
    this.centerPixels = new Point(0,0);
    this.hexPoly = null;
  }

  //HexTile Constructor #2: X,Y coordinates
  public HexTile(int xCord, int yCord, float rad){
    this(new HexLocation(xCord,yCord), rad);
  }

  //method to access the location of the GridTile
  // public HexLocation getLocation(){
  //     return location;
  // }

  //mutator method to define the center point of the Tile
  public void setHexCenterPixels(Point centerPixels){
    this.centerPixels = centerPixels;
  }
  //accessor method to the center point of the Tile
  public Point getCenterPixels(){
    return centerPixels;
  }

  //mutator method to change the Java Polygon object that defines the shape of the HexTile
  public void setHexPoly(Polygon hexPoly){
    this.hexPoly = hexPoly;
  }
  //accessor method to return the Java Polygon object
  public Polygon getPoly(){
    return hexPoly;
  }

  //accessor method to return the hexagon's radius
  public float getRadius(){
    return radius;
  }

    
}  