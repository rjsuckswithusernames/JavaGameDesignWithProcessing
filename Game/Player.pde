public class Player{    //Consider having Player extend from AnimatedSprite

    //position on x and y axis
    private int posx;
    private int posy;

    //Image of player
    private PImage Pi;

    //Player Stats from Powerups
    private int currentbombs = 0;
    private int maxbombs = 1;
    private int explosionradius = 1;
    private int lives = 1;
    private boolean bombpierce = false;
    private boolean selfdamage = true;
    private boolean bombpush = false;


    //Player Status
    private boolean isAlive;
    private int iframetimer = 0;
    private int movetimer = 0;

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
    public int getMaxBombs(){
        return maxbombs;
    }
    public int getExplosionRadius(){
        return explosionradius;
    }
    public int getBombs(){
        return currentbombs;
    }
    public int getMoveTimer(){
        return movetimer;
    }
    public boolean canPierce(){
        return bombpierce;
    }
    public boolean selfHarm(){
        return selfdamage;
    }
    public boolean canPush(){
        return bombpush;
    }
    public GridLocation getLocation(){
        return new GridLocation(posx,posy);
    }

    public void hurtPlayer(){
        if (iframetimer <= 0){
            iframetimer = 200;
            lives--;
            System.out.println("Ouch!");
            if (lives <= 0){
                isAlive = false;
            }
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
    public void piercePowerup(){
        bombpierce = true;
    }
    public void sdImmunePowerup(){
        selfdamage = false;
    }
    public void glovePowerup(){
        bombpush = true;
    }
    public void addBomb(){
        currentbombs++;
    }
    public void removeBomb(){
        currentbombs--;
    }
    public void addLife(){
        lives = Math.min(lives+1, 9);
    }
    public void setMaxBombs(int b){
        maxbombs = Math.min(b,5);
    }
    public void raiseMaxBombs(){
        maxbombs = Math.min(maxbombs+1,5);
    }
    public void resetMoveTimer(){
        movetimer = 100;
    }
    public void lowerMaxBombs(){
        maxbombs--;
    }
    public void setExplosionRadius(int v){
        explosionradius = Math.min(v,10);
    }
    public void raiseExplosionRadius(){
        explosionradius = Math.min(explosionradius+1,10);
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
    public void update(int dt){
        if (iframetimer > 0){
            iframetimer-=dt;
        }
        if (movetimer > 0){
            movetimer-=dt;
        }
    }
    public boolean collisionCheck(GridLocation loc){
        if (new GridLocation(posx,posy) == loc)
        {
            return true;
        }
        return false;
    }
}