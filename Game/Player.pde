public class Player{    //Consider having Player extend from AnimatedSprite

    //position on x and y axis
    private int posx;
    private int posy;

    //Image of player
    private PImage Pi;

    //Player Stats from Powerups
    private int currentbombs;
    private int maxbombs;
    private int explosionradius;
    private int lives;

    //Player Status
    private boolean isAlive;

    public Player(PImage P){
        this(P,0,0);
    }
    public Player(PImage P, int x, int y){
        this.Pi = P;
        this.posx = x;
        this.posy = y;
        this.isAlive = true;
        maxbombs = 1;
        currentbombs = 0;
        explosionradius = 1;
        lives = 1;
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
    public int getMaxBombs(){
        return maxbombs;
    }
    public int getExplosionRadius(){
        return explosionradius;
    }
    public int getBombs(){
        return currentbombs;
    }
    public GridLocation getLocation(){
        return new GridLocation(posx,posy);
    }

    public void hurtPlayer(){
        lives--;
        if (lives <= 0){
            isAlive = false;
        }
    }
    public void updateLocation(GridLocation l){
        posx = l.getRow();
        posy = l.getCol();
    }
    public void setImage(PImage P){
        Pi = P;
    }
    public void setBombs(int b){
        currentbombs = b;
    }
    public void addBomb(){
        currentbombs++;
    }
    public void removeBomb(){
        currentbombs--;
    }
    public void setMaxBombs(int b){
        maxbombs = b;
    }
    public void raiseMaxBombs(){
        maxbombs++;
    }
    public void lowerMaxBombs(){
        maxbombs--;
    }
    public void setExplosionRadius(int v){
        explosionradius = v;
    }
    public void raiseExplosionRadius(){
        explosionradius++;
    }
    public void lowerExplosionRadius(){
        explosionradius--;
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