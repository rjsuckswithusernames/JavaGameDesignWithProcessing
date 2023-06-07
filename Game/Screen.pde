/* Screen class - a high level class that handles background screens & millisecond timing
 * Has a World Subclass
 * Author: Joel Bianchi
 * Last Edit: 6/6/23
 */

public class Screen {

    //Screen fields
    private String screenName;
    private PImage bg;
    private float x;
    private float y;

    private long startTime;
    private long lastTime = 0;

    //Screen Constructor #1
    public Screen(String screenName, PImage bg, float x, float y) {
        this.setName(screenName);
        if(bg != null) {
            this.setBg(bg);
        }
        this.x = x;
        this.y = y;
        startTime = getTotalTime();
    }

    //Screen Constructor #2
    public Screen(String screenName, PImage bg) {
        this(screenName, bg, 0.0, 0.0);
    }

    //Screen Accessors + Mutators
    public void setName(String screenName){
        this.screenName = screenName;
    }
    public String getName(){
        return screenName;
    }

    public void setBg(PImage bg){
        this.bg = bg;
        //background(bg);
    }
    public PImage getBg(){
        return bg;
    }
    
    public void setX(float x) {
        this.x = x;
    }
    public float getX() {
        return x;
    }

    public void setY(float y) {
        this.y = y;
    }
    public float getY() {
        return y;
    }

    //???
    public void setScreenSize(int w, int h){

    }

    public String toString(){
        return "Screen: " + screenName + " at " + x + "," + y;
    }

    public void pause(final int milliseconds) {
        try {
            Thread.sleep(milliseconds);
        } catch (final Exception e) {
            System.out.println(e);
        }
    }

    //SCREEN TIME METHODS
    public long getTotalTime(){
        return millis();  //milliseconds world
    }
    public long getScreenTime(){
        return millis() - startTime;  //milliseconds world
    }
    public long getTimeSince(long lastCheck){
        return getScreenTime() - lastCheck;
    }
    public float getScreenTimeSeconds(){
        return getScreenTime() / 1000.0f;
    }

}
