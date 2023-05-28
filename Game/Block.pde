public class Block {

    private GridLocation loc;
    private PImage Pi;
    private String type;
    private boolean alive;
    private Player owner;
    private int timer = 2000;
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
public void update(double dt){
    timer-=dt;
    if (timer <= 0){
        this.Explode();
    }
}
  public void Explode(){
    Block[][] blocklist = grid.getBList();
    GridLocation loc = this.getLocation();
    if (this.isAlive() == false){
      return;
    }
    this.Kill();
    Player owner = this.getOwner();
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
          continue;
        }
          if (cell.getType().equals("Fire")){
            blocklist[x][y] = null;
            break;
          }
          if (cell.getType().equals("Wall")){
            break;
          }
          if (cell.getType().equals("Balloon")){
            //System.out.println(cell.isAlive());
            if (cell.isAlive() == true){
              blocklist[x][y].Explode();
            }
          }
          /*
          GridLocation ploc = new GridLocation(x,y);
          if (ploc = owner.getLocation()){
            hurtPlayer();
          }
          */
        
      }
    }
    owner.removeBomb();
    blocklist[this.getX()][this.getY()] = null;
    grid.removeMark(loc);
    balloonlist.remove(this);
  }
      public String toString(){
        if (owner != null){
            return "Game Object "+type+" with owner "+owner+" and a location of "+loc;
        }
        return "Game Object "+type+" with no owner and a location of "+loc;
    }
}