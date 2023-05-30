import java.util.Random;

public class Block {

    private GridLocation loc;
    private PImage Pi;
    private String type;
    private boolean alive;
    private Player owner;
    private int timer;
    private int pushTimer;
    private int dirx;
    private int diry;
    private boolean isPushed = false;
    private boolean canUpdate = true;
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
    public Block(PImage P, int x, int y, String t, Player o){
      this(P,new GridLocation(x,y),t,o);
    }
    public Block(PImage P, GridLocation l, String t, Player o){
        Pi = P;
        loc = l;
        type = t;
        owner = o;
        alive = true;
        if (type.equals("Balloon")){
           timer = 2000;
        } else if (type.equals("Explosion")) {
           timer = 300;
        }
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
    public int getPushTimer(){
      return pushTimer;
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
      grid.updateBList(loc, l);
        loc = l;
        
    }
    public void updateLocation(int x,int y){
        grid.updateBList(loc, new GridLocation(x,y));
        loc = new GridLocation(x,y);
    }
    public void updateImage(PImage P){
        Pi = P;
    }
    public void resetPushTimer(){
      pushTimer = 150;
    }
    public boolean isAbleToUpdate(){
      return canUpdate;
    }
public void update(double dt){
  if (canUpdate == true){
    if (this == null || this.alive == false){
      Block[][] blocklist = grid.getBList();
      blocklist[this.getX()][this.getY()] = null;
      grid.removeMark(loc);
      canUpdate = false;
      return;
    }
    if (type.equals("Balloon")){
      timer-=dt;
        if (timer <= 0){
          this.Explode();
        }
            if (pushTimer > 0){
      pushTimer-=dt;
    }
    if (pushTimer <= 0){
      if (isPushed == true){
        pushBomb(dirx,diry);
      }
    }
    } else if (type.equals("Explosion")){
      timer-=dt;
      if (timer <= 0){
        Block[][] blocklist = grid.getBList();
        
        if (this.owner != null && Math.random() < .3){
          String pow = this.getRandomPower();
          PImage powimage = loadImage("images/"+pow+".png");
          powimage.resize(grid.getTileWidthPixels(),grid.getTileHeightPixels());
          if (pow.equals("balloon")){
            blocklist[this.getX()][this.getY()] = new Block(powimage,this.getLocation(),"Balloon");
          }
          else{
            blocklist[this.getX()][this.getY()] = new Block(powimage,this.getLocation(),pow);
          }
        } else {
          blocklist[this.getX()][this.getY()] = null;
        }
      }
    }
  }
}

public String getRandomPower(){
    int rnd = new Random().nextInt(powers.length);
    return powers[rnd];
}
  public void Explode(){
    this.Explode(false,false);
  }
    public void Explode(boolean p1cd, boolean p2cd){
              isPushed = false;
    PImage exp = loadImage("images/splash.png");
    exp.resize(grid.getTileWidthPixels(),grid.getTileHeightPixels());
    Block[][] blocklist = grid.getBList();
    GridLocation loc = this.getLocation();
    boolean p1hit = false;
    boolean p2hit = false;
    if (this.isAlive() == false){
      return;
    }
    this.Kill();
    int radius;
    if (owner == null){
      radius = 1;
    } else {
      radius = owner.getExplosionRadius();
    }
    for (int[] dir : dirs){
      for(int i = 0; i <= radius; i++){
        int x = this.getX() + dir[0] * i;
        int y = this.getY() + dir[1] * i;
        if (x < 0 || x >= grid.getNumRows() || y < 0 || y >= grid.getNumCols()){
          continue;
        }
        Block cell = blocklist[x][y];
        //System.out.println(cell);
        if (cell == null)
        {
          blocklist[x][y] = new Block(exp,x,y,"Explosion");
                    GridLocation eloc = new GridLocation(x,y);
          if (eloc.equals(player1.getLocation()) && !(player1 == owner && player1.selfHarm() != true)){
            p1hit = true;
          }
          if (eloc.equals(player2.getLocation()) && !(player2 == owner && player2.selfHarm() != true)){
            p2hit = true;
          }
          continue;
          
        }
        
          if (cell.getType().equals("Fire")){
            blocklist[x][y] = new Block(exp,x,y,"Explosion", owner);
            if (owner != null && owner.canPierce() == true){
              continue;
            }
            break;
          }
          if (cell.getType().equals("Wall")){
            if (owner != null && owner.canPierce() == true){
              continue;
            }
            break;
          }

          GridLocation eloc = new GridLocation(x,y);
          if (eloc.equals(player1.getLocation()) && !(player1 == owner && player1.selfHarm() != true)){
            p1hit = true;
          }
          if (eloc.equals(player2.getLocation())  && !(player2 == owner && player2.selfHarm() != true)){
            p2hit = true;
          }
          if (p1hit == true && p1cd == false){
            player1.hurtPlayer();
            p1cd = true;
          }
          if (p2hit == true && p2cd == false){
            player2.hurtPlayer();
            p1cd = true;
          }
          if (cell.getType().equals("Balloon")){
            //System.out.println(cell.isAlive());
            if (cell.isAlive() == true){
              blocklist[x][y].Explode(p1hit,p2hit);
            }
          }

        
      }
    }
    boomSound.play();
    if (p1hit == true && p1cd == false){
      if (owner != null && owner.areBombsStrong() == true && owner != player1){
        player1.hurtPlayer(2);
      }
      else{
        player1.hurtPlayer();
      }
      p1cd = true;
    }
    if (p2hit == true && p2cd == false){
      if (owner != null && owner.areBombsStrong() == true && owner != player2){
        player2.hurtPlayer(2);
      }
      else{
        player2.hurtPlayer();
      }
      p2cd = true;
    }
    if (owner != null){
      owner.removeBomb();
    }
    blocklist[this.getX()][this.getY()] = new Block(exp,this.getX(),this.getY(),"Explosion");
    grid.removeMark(loc);
  }
  public void pushBomb(int dirx, int diry){
    Block[][] blocklist = grid.getBList();
    if (this == null || this.alive == false){
      blocklist[this.getX()][this.getY()] = null;
      grid.removeMark(loc);

      return;
    }
    this.resetPushTimer();
    this.dirx = dirx;
    this.diry = diry;
    int thisx = this.getX();
    int thisy = this.getY();

      int x = this.getX() + dirx;
      int y = this.getY() + diry;
      if (x < 0 || x >= grid.getNumRows() || y < 0 || y >= grid.getNumCols()){
        isPushed = false;
        return;
      }
      Block thisblock = blocklist[thisx][thisy];
      Block cell = blocklist[x][y];
      GridLocation eloc = new GridLocation(x,y);
        if (eloc.equals(player1.getLocation()) || eloc.equals(player2.getLocation())){
          this.Explode();
          isPushed = false;
          return;
        }
      if (cell != null && cell.getType().equals("Balloon")){
        this.Explode();
        isPushed = false;
        return;
      }
      if (cell != null && !cell.getType().equals("Explosion")){
        isPushed = false;
        return;
      }
      else {
        isPushed = true;
        this.updateLocation(x,y);
        if (cell != null && cell.getType().equals("Explosion")){
          this.Explode();
          isPushed = false;
          return;
        }
      }
      println("Running!");


  }
      public String toString(){
        if (owner != null){
            return "Game Object "+type+" with owner "+owner+" and a location of "+loc;
        }
        return "Game Object "+type+" with no owner and a location of "+loc;
    }
}