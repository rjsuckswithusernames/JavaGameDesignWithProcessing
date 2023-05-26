public class Block {

    private GridLocation loc;
    private PImage Pi;

    public Block(PImage P){
        this(P,0,0);
    }
    public Block(PImage P, GridLocation l){
        Pi = P;
        loc = l;
    }
    public Block(PImage P, int x, int y){
        Pi = P;
        loc = new GridLocation(x,y);
    }
    public GridLocation getLocation(){
        return loc;
    }
    public PImage getImage(){
        return Pi;
    }
    public void updateLocation(GridLocation l){
        loc = l;
    }
    public void updateLocation(int x,int y){
        loc = new GridLocation(x,y);
    }
    public void updateImage(PImage P){
        Pi = P;
    }
}