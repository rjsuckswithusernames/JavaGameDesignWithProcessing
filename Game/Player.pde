public class Player{    //Consider having Player extend from AnimatedSprite

    private int posx;
    private int posy;
    private PImage Pi;
    private boolean isAlive;

    public Player(PImage P){
        this(P,0,0);
    }
    public Player(PImage P, int x, int y){
        this.Pi = P;
        this.posx = x;
        this.posy = y;
        this.isAlive = true;
    }
    public PImage getImage(){
        return Pi;
    }
    public int getX(){
        return posx;
    }
    public int getY(){
        return posy;
    }
    public GridLocation getLocation(){
        return new GridLocation(posx,posy);
    }
    public void updateLocation(GridLocation l){
        posx = l.getRow();
        posy = l.getCol();
    }
    public void setImage(PImage P){
        Pi = P;
    }
    public void setX(int x){
        posx = x;
    }
    public void setY(int y){
        posy = y;
    }
    public void lowerX(){
        posx--;
    }
    public void lowerY(){
        posy--;
    }
    public void raiseX(){
        posx++;
    }
    public void raiseY(){
        posy++;
    }
    public boolean collisionCheck(GridLocation loc){
        if (new GridLocation(posx,posy) == loc)
        {
            return true;
        }
        return false;
    }
}