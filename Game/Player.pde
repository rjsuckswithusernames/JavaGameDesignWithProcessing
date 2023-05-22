public class Player{

    private int posx;
    private int posy;
    private PImage Pi;

    public Player(PImage P){
        this(P,0,0);
    }
    public Player(PImage P, int x, int y){
        this.Pi = P;
        this.posx = x;
        this.posy = y;
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
    public boolean collisionCheck(int newx, int newy, Player p2){
        if (newx == p2.getX() && newy == p2.getY())
        {
            return true;
        }
        return false;
    }
}