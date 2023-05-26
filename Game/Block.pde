public class Block {

    private GridLocation loc;
    private PImage Pi;
    private String type;
    public Block(PImage P){
        this(P,0,0,"Indestructible");
    }
    public Block(PImage P, GridLocation l){
        Pi = P;
        loc = l;
    }
    public Block(PImage P, GridLocation l, String t){
        Pi = P;
        loc = l;
        type = t;
    }
    public Block(PImage P, int x, int y){
        Pi = P;
        loc = new GridLocation(x,y);
    }
    public Block(PImage P, int x, int y, String t){
        Pi = P;
        loc = new GridLocation(x,y);
        type = t;
    }
    public GridLocation getLocation(){
        return loc;
    }
    public PImage getImage(){
        return Pi;
    }
    public boolean isDestructible(){
        if (type.equals("Indestructible")) return true;
        return false;
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