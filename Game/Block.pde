public class Block {

    private GridLocation loc;
    private PImage Pi;
    private String type;
    private boolean alive;
    private Player owner;
    public Block(PImage P){
        this(P,new GridLocation(0,0),"Wall",null);
    }
    public Block(PImage P, GridLocation l){
        this(P,l,"Wall", null);
    }
    public Block(PImage P, GridLocation l, String t){
        this(P,l,t,null);

    }
    public Block(PImage P, int x, int y){
        this(P,new GridLocation(x,y),"Wall",null);
    }
    public Block(PImage P, int x, int y, String t){
        this(P,new GridLocation(x,y),t,null);
    }
    public Block(PImage P, GridLocation l, String t, Player o){
        Pi = P;
        loc = l;
        type = t;
        owner = o;
        alive = true;
    }
    public int getX(){
        return loc.getRow();
    }
    public int getY(){
        return loc.getCol();
    }
    public Player getOwner(){
        return owner;
    }
    public GridLocation getLocation(){
        return loc;
    }
    public PImage getImage(){
        return Pi;
    }
    public String getType(){
        return type;
    }
    public void Kill(){
        alive = false;
    }
    public boolean isAlive(){
        return alive;
    }
    public boolean isDestructible(){
        if (type.equals("Wall")) return true;
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

    public void pause(final int milliseconds) {
        try {
            Thread.sleep(milliseconds);
            } catch (final Exception e) {
            // ignore
            }
    }
      public String toString(){
        if (owner != null){
            return "Game Object "+type+" with owner "+owner+" and a location of "+loc;
        }
        return "Game Object "+type+" with no owner and a location of "+loc;
    }
}