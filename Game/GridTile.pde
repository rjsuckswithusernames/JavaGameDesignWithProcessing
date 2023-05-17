/* GridTile class - Designed to be used within the Grid class
 * GridTiles have distinguishable marks that will be printed out to the console for easy visualization of a 2D array
 * GridTiles can indicate if they have been "captured", colored, or are displaying an image
 * Authors: Joel Bianchi, Naomi Gaylor, Ezzeldin Moussa
 * Last Edit: 5/17/2023
 * Edited to be superclass of HexTile
 */

import java.awt.Color;

public class GridTile{
  
  private GridLocation location;
  private PImage pi;
  private boolean coveredPic;
  private color fillColor;
  final color defaultFillColor = #FFFFFF; //WHITE
  private color outlineColor;
  final color defaultOutlineColor = #000000; //BLACK
  private String mark;
  final private static String noMark = " ";
  private boolean isCaptured;

  //GridTile constructor #1: Adds the specified String mark
  public GridTile(String mark, GridLocation loc){
    this.mark = mark;
    location = loc;
    fillColor = defaultFillColor;
    outlineColor = defaultOutlineColor;
    coveredPic = false; 
  }
  
  //GridTile constructor #2 which adds a mark, but no Location
  public GridTile(String mark){
    this(mark, null);
  }

  //GridTile constructor #3 which adds a GridLocation, but no mark  
  public GridTile(GridLocation loc){
    this(noMark, loc);
  }

  //Default GridTile constructor which puts an empty String mark in the GridTile
  public GridTile(){
    this(noMark, null);
  }

  // Accessor method that gets the mark in the GridTile
  public String getMark(){
    return mark;
  }
  
  // Mutator method that automatically changes the mark
  public void setMark(String mark){
    this.mark = mark;
  }

  // Mutator method sets a new mark in the GridTile 
  // if it does not already have a mark, 
  // returns true or false if successful
  public boolean setNewMark(String mark){
    if(this.mark.equals(noMark)){
      this.mark = mark;
      System.out.println("Successfully changed mark");
      return true;
    } else {
      System.out.println("That GridTile is already taken!");
      return false;
    }
  }
  
  // Mutator method that sets an new PImage in the GridTile
  public void setImage(PImage pi){
    this.pi = pi;
  }

  //Accessor method that returns the PImage stored in the GridTile
  public PImage getImage(){
    return pi;
  }

  //method to "capture" a tile by changing its color
  public void captureTile(color clr){
    this.isCaptured = false;
    this.fillColor = clr;
  }

  //method to "release" a tile by changing its color
  public void releaseTile(){
    this.isCaptured = false;
    this.fillColor = defaultFillColor;
  }

  //accessor method to check if tile is captured
  public boolean checkIsCaptured(){
    return isCaptured;
  }

  //method to access the location of the GridTile
  public GridLocation getLocation(){
      return location;
  }

  //method to change the color of the tile
  public void setColor(color clr) {
    this.fillColor = clr;
  }

  //method to access the color of the tile
  public color getColor() {
    return fillColor;
  }

  public void setOutlineColor(color oclr){
    this.outlineColor = oclr;
  }

  public color getOutlineColor(){
    return this.outlineColor;
  }

  public void setCoveredWithPic(boolean isCoveredWithPic) {
    this.coveredPic = isCoveredWithPic;
  }

  public boolean isCoveredWithPic() {
    return this.coveredPic;
  }

  //ToString simply retuns the mark on the Tile, useful for printing out 2D grids
  public String toString(){
    return mark;
  }


}
