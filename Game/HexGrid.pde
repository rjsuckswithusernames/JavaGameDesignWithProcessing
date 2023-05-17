/* HexGrid Class - useful for tile-based games with more flavor!
 * Inspired from CSRessel's Catan Game & Emmanuel Suriel's Grid class
 * https://github.com/CSRessel/catan/blob/master/src/gui/CatanBoard.java
 * Adapted for Processing
 * Authors: Joel Bianchi, Naomi Gaylor, Ezzeldin Moussa
 * Last Edit: 5/16/2023
 * NOT FULLY FUNCTIONAL YET
 */

import java.awt.Polygon;
import java.awt.Point;
import java.util.ArrayList;

public class HexGrid {

	ArrayList<HexLocation> allHexLocations;
	ArrayList<HexLocation> unclaimedLocations;
	
    private HexTile[][] map;
    private color defaultOutlineColor = #FFFFFF;	//WHITE
    private color defaultFillColor = #000000; 		//BLACK
	private color defaultBgColor = color(164,200,218);
	
	private boolean bgSet = false;

    //GUI fields
	private int hexGen;
	private int hexDiameter;
	private int boardHeight;
	private int hexagonSide;
	private int heightMargin = 100;
	private int widthMargin;
	private final double sqrt3div2 = 0.86602540378;

    //HexGrid Constructor
    public HexGrid(int hexGen){

		this.hexGen = hexGen;

		//Generate all the valid hexLocations
		allHexLocations = new ArrayList<HexLocation>();
        
		hexDiameter = hexGen *2 -1;	//originally 5
		int midHex = hexGen;	//originally 3
		System.out.println("mid:" + midHex);

		//Create top half of HexLocations
		for(int r=1; r <= midHex; r++){
			for(int c=1; c <= midHex + r - 1; c++){
				allHexLocations.add( new HexLocation(c,r) );
			}
		}
		//Create bottom half of HexLocations
		for(int r = midHex +1; r <= hexDiameter; r++){
			for(int c= r-midHex + 1; c <= hexDiameter; c++){
				allHexLocations.add( new HexLocation(c,r) );
			}
		}
		
		System.out.println("All generated HexLocations:");
		System.out.println(allHexLocations);

		//Construct 2D array of HexTiles
		int row = hexDiameter + 2;
		int col = row;
        map = new HexTile[row][col];

		//Initialize unclaimed HexLocations arrayList
		unclaimedLocations = new ArrayList<HexLocation>();

		for(HexLocation loc: allHexLocations){

			//Generate hexTiles for each HexLocation
			HexTile hTile = new HexTile(loc, this.hexDiameter);
			map[loc.getYCoord()][loc.getXCoord()] = hTile;
			hTile.setColor(defaultFillColor);
			hTile.setOutlineColor(defaultOutlineColor);
			setHexTileCenterPixels(hTile);
			setHexTilePoly(hTile);

			//Generate unclaimedTiles ArrayList
			unclaimedLocations.add(loc);
		}
    }

	public boolean isValidLocation(HexLocation testLoc){
		for(int i=0; i<unclaimedLocations.size(); i++){
			if(unclaimedLocations.get(i).equals(testLoc)){
				return true;
			}
		}
		return false;
	}

	public boolean isWithinOne(HexLocation start, HexLocation end){
		int startX = start.getXCoord();
		int startY = start.getYCoord();
		int endX = end.getXCoord();
		int endY = end.getYCoord();

		if(endX==startX+1 || endX==startX-1 || endX==startX){
			if(endY==startY+1 || endY==startY-1 || endY==startY){
				return true;
			}
		}
		return false;
	}

	public boolean isWithinTwo(HexLocation start, HexLocation end){
		int startX = start.getXCoord();
		int startY = start.getYCoord();
		int endX = end.getXCoord();
		int endY = end.getYCoord();

		if(endX==startX+2 || endX==startX+1 || endX==startX-2 || endX==startX-1 || endX==startX){
			if(endY==startY+2 || endY==startY+1 || endY==startY-2 || endY==startY-1 || endY==startY){
				return true;
			}
		}
		return false;
	}

	public void removeHexLocation(HexLocation loc){
		for(int i=0; i<unclaimedLocations.size(); i++){
      		if(unclaimedLocations.get(i).equals(loc)){
        		unclaimedLocations.remove(i);
				return;
			}
		}
		System.out.println("Error when trying to remove Location: " + loc);
	}


	public void displayHexGrid(){

        int mapHeight = map.length;
        //int hexagonSide = 50;
		//int hexagonSide = (mapHeight - 2 * heightMargin) / 8;
        int widthMargin = (width - (int) (10 * hexagonSide * sqrt3div2)) / 2;

        // Graphics2D g2 = (Graphics2D)g;
        // g2.setRenderingHint(RenderingHints.KEY_ANTIALIASING, RenderingHints.VALUE_ANTIALIAS_ON);
        // g.setFont(new Font("TimesRoman", Font.PLAIN, 20));
        // super.paintComponent(g2);

		//System.out.println("ahl size: " + allHexLocations.size());

		//Fill in each Hex
		for(HexLocation loc: allHexLocations){
			int x = loc.getXCoord();
			int y = loc.getYCoord();
			HexTile hTile = map[x][y];
			//System.out.println(hTile);
			fillOneHex(hTile);
		}

		//Outline each Hex
		for(HexLocation loc: allHexLocations){
			int x = loc.getXCoord();
			int y = loc.getYCoord();
			HexTile hTile = map[x][y];
			outlineOneHex(hTile);
		}

		//System.out.println("HexLocations: " + hexLocations);
    }

	private void setHexTileCenterPixels(HexTile hTile){
		int x = hTile.getLocation().getXCoord();
        int y = hTile.getLocation().getYCoord();
		Point centerPixels = findTileCenter(hTile);
		hTile.setHexCenterPixels(centerPixels);
	}

	private void setHexTilePoly(HexTile hTile){
        Polygon hexPoly = makeHex(hTile.getCenterPixels());
		hTile.setHexPoly(hexPoly);
	}

	//method to fill in 1 hex tile
    public void fillOneHex(HexTile hTile){

        boolean hasImage = hTile.isCoveredWithPic();
		//System.out.println("drawHex: x:"+tile.getLocation().getXCoord()+",y:"+tile.getLocation().getYCoord());
		
        //FILL IN SOLID COLOR - fill in hexTile with a solid color if no picture
        if(!hasImage){
			color fillClr = hTile.getColor();
			
			// ???

		}
    		
        //FILL IN PICTURE
        if(hasImage){    
			PImage photo = hTile.getImage();
			
			try{
				//resize the image to fit in the hex
				int iSize = (int) (hexagonSide * 1.25);
				photo.resize(iSize, iSize);

				//mask the image to the hex shape
				PGraphics maskImage;
				maskImage = createGraphics(iSize,iSize);
				maskImage.beginDraw();
				//maskImage.triangle(30, 480, 256, 30, 480, 480);
				//maskImage = drawOneHex(PGraphics maskImage);
				maskImage.endDraw();
				
				// apply mask
				photo.mask(maskImage);

				//display masked image
				image(photo, 0, 0);

				final int ix = getImageX(hTile, photo);
				final int iy = getImageY(hTile, photo);
				
				//System.out.println("Img: " + locImageName);
				//System.out.println("nPoints:" + poly.npoints);
				//System.out.println("ix:" + ix + "\tiy:"+iy);

				//System.out.println("Drew image for x:" + x + ",y:" + y);

			} catch(Exception e){

			} //end catch
		} //end image fill
	} //end drawing one hex

	//method to draw the outline around a hex tile
    public void outlineOneHex(HexTile hTile){
		color oClr = hTile.defaultOutlineColor;
		float stroke = 3.0;
		color tileOutlineColor = hTile.getOutlineColor();
		
		if(tileOutlineColor != oClr){
			PGraphics pg = getHexPGraphics(hTile);

			//DRAW THE OUTLINE!???

		}
	}


//---------------------- HELPER METHODS -------------------------------//
    private int getImageX(HexTile hTile, PImage image){
    	Point center = findTileCenter(hTile);
        int imageWidth =  image.width;
        return center.x - imageWidth/2; 
    }
    private int getImageY(HexTile hTile, PImage image){        
        Point center = findTileCenter(hTile);
        int imageHeight =  image.height;
        return center.y - imageHeight/2; 
    }

	//method finds the center pixels of a HexTile based on its grid coordinates
	private Point findTileCenter(HexTile hTile){
		return findTileCenter(hTile.getLocation().getXCoord(), hTile.getLocation().getYCoord());
	}
	private Point findTileCenter(int xcoord, int ycoord){
		int x = xcoord;
		int y = ycoord;
		//code for a bottom left origin with rows as x and cols as y
		// int xCenter = widthMargin + (int) (3 * hexagonSide * sqrt3div2)
		// 		+ (int) ((x - 1) * 2 * hexagonSide * sqrt3div2)
		// 		- (int) ((y - 1) * hexagonSide * sqrt3div2);
		// int yCenter = boardHeight - (heightMargin + hexagonSide
		// 		+ (int) ((y - 1) * hexagonSide * 1.5));

		//code for a top left origin (to mimic how Java 2D arrays are modeled) with rows as y and cols as x
		int xCenter = widthMargin + (int) (3 * hexagonSide * sqrt3div2)
		+ (int) ((x - 1) * 2 * hexagonSide * sqrt3div2)
		- (int) ((y - 1) * hexagonSide * sqrt3div2);
		
		int yCenter = (heightMargin + hexagonSide 
		+ (int) ((y - 1) * hexagonSide * 1.5));

		return new Point(xCenter,yCenter);
	}



    //MUTATOR METHODS
    public void setAllTileColors(color tileColor){
        this.defaultFillColor = tileColor;
          for (int r = 0; r < map.length; r++) {
            for (int c = 0; c < map[0].length; c++) {
                if (map[r][c] != null){
                    map[r][c].setColor(defaultFillColor);
                }
            }
        }
    }

	public void setAllTileOutlines(color outlineColor){
        this.defaultFillColor = outlineColor;
          for (int r = 0; r < map.length; r++) {
            for (int c = 0; c < map[0].length; c++) {
                if (map[r][c] != null){
                    map[r][c].setOutlineColor(defaultFillColor);
                }
            }
        }


    }


	//method to access any Hextile based on its location
    public HexTile getHexTile(HexLocation loc){
		int x = loc.getXCoord();
		int y = loc.getYCoord();
        return map[x][y];
    }

    public color setTileColor(HexLocation loc, color tileColor){
		HexTile hTile = getHexTile(loc);
        color oldColor = hTile.getColor();
        hTile.setColor(tileColor);
        return oldColor;
    }

	public void highlightTile(HexLocation loc) {
		HexTile hTile = getHexTile(loc);
		color highlightColor = #FFFFFF;

		Point p = hTile.getCenterPixels();

		//Shape shape = new Ellipse2D.Double((int)p.getX() - 25, (int)p.getY() - 25, 50, 50);

		// g2.setColor(Color.WHITE);
		// g2.fill(shape);
		// g2.draw(shape);
	}
    


    /* ---------------  HEX GRID ACCESSOR METHODS ------------------ */
	public HexTile[][] getMap(){
        return map;
    }
    
    public int getNumRows() {
		return map.length;
	}

	public int getNumCols() {
		return map[0].length;
	}

    //needs to be modified slightly because HexGrid doesn't include ALL tiles in the rectangle (like 0,0)
	public boolean isValid(final HexLocation loc) {
		final int row = loc.getYCoord();
		final int col = loc.getXCoord();
		return 0 <= row && row < getNumRows() && 0 <= col && col < getNumCols();
	}


    /* ---------------- BACKGROUND IMAGE METHODS ------------------------- */



	/**
	 * sets the background to imgName. The img is resized to fit in the grids
	 * dimensions. setColor() is disabled
	 * 
	 * @param imgName
	 */
	public void setBackground(PImage bgImage) {
		// this.xOffset = 0;
		// this.yOffset = 0;
		// this.xScale = 1.0;
		// this.yScale = 1.0;

		// backgroundImage = loadImage(imgName);
		// bgSet = true;

		//repaint();
	}

	/**
	 * Removes a regular background or moveable background, allowing setColor to
	 * work again.
	 */
	public void removeBackground() {
		bgSet = false;
	}



	public void setFillColor(final HexLocation loc, final color clr) {
		if (!isValid(loc))
			throw new RuntimeException("cannot set color of invalid location " + loc + " to color " + clr);
		map[loc.getXCoord()][loc.getYCoord()].setColor(clr);
		//repaint();
	}

	public color getFillColor(final HexLocation loc) {
		if (!isValid(loc))
			throw new RuntimeException("cannot get color from invalid location " + loc);
		return map[loc.getYCoord()][loc.getXCoord()].getColor();
	}

	// public void setImage(final HexLocation loc, final String imageFileName) {
	// 	if (!isValid(loc))
	// 		throw new RuntimeException(
	// 				"cannot set image for invalid location " + loc + " to \"" + imageFileName + "\"");
	// 	map[loc.getXCoord()][loc.getYCoord()].setImageFileName(imageFileName);
	// 	repaint();
	// }

	// public String getImage(final Location loc) {
	// 	if (!isValid(loc))
	// 		throw new RuntimeException("cannot get image for invalid location " + loc);
	// 	return map[loc.getYCoord()][loc.getXCoord()].getImageFileName();
	// }

	public void setTileOutlineColor(final HexLocation loc, final color oclr) {
		if (!isValid(loc))
			throw new RuntimeException("cannot set outline for invalid location " + loc);
            map[loc.getXCoord()][loc.getYCoord()].setOutlineColor(oclr);
		//repaint();
	}

	public color getTileOutlineColor(final HexLocation loc) {
		if (!isValid(loc))
			throw new RuntimeException("cannot get outline color for invalid location " + loc);
		return map[loc.getXCoord()][loc.getYCoord()].getOutlineColor();
	}

	public void setAllOutlinesColor(final color oclr) {
		for (int r = 0; r < getNumRows(); r++) {
			for (int c = 0; c < getNumCols(); c++) {
				map[r][c].setOutlineColor(oclr);
			}
		}
		//repaint();
	}



    /* ----- INPUT HANDLING -------------------------------------------------------------------- */
	// // returns -1 if no key pressed since last call.
	// // otherwise returns the code for the last key pressed.
	// public int checkLastKeyPressed() {
	// 	final int key = lastKeyPressed;
	// 	lastKeyPressed = -1;
	// 	return key;
	// }

	// // returns null if no location clicked since last call.
	// public HexLocation checkLastLocationClicked() {
	// 	final HexLocation loc = lastLocationClicked;
	// 	lastLocationClicked = null;
	// 	return loc;
	// }

	// public HexLocation waitForClick() {
	// 	while (true) {
	// 		final HexLocation clicked = this.checkLastLocationClicked();
	// 		if (clicked != null) {
	// 			//System.out.print("x:"+clicked.getXCoord()+ ",y:" + clicked.getYCoord());
	// 			return clicked;
	// 		} else {
	// 			//System.out.print("NOT CLICKED");
	// 			HexGrid.pause(100);
	// 		}
	// 	}
	// }

    // public static void pause(final int milliseconds) {
	// 	try {
	// 		Thread.sleep(milliseconds);
	// 	} catch (final Exception e) {
	// 		// ignore
	// 	}
	// }

    // public void keyPressed(final KeyEvent e) {
	// 	lastKeyPressed = e.getKeyCode();
	// }

	// public void mousePressed(final MouseEvent e) {

	// 	Point p = e.getPoint();
	// 	//System.out.println(p);
		
	// 	for(HexLocation loc : this.allHexLocations){
	// 		HexTile hTile = map[loc.getXCoord()][loc.getYCoord()];
	// 		Polygon hexPoly = hTile.getHexPoly();
	// 		if(hexPoly.contains(p)){
				
	// 			lastLocationClicked = loc;
				
	// 		}
	// 	}
	// }



    // ------------------ GUI HELPER METHODS --------------------------------------------------------------------------//

    // private void guiInit() {
    //     lastKeyPressed = -1;
    //     lastLocationClicked = null;

    //     frame = new JFrame("Grid");
    //     frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
	// 	fullscreen();	//makes the it stay on the left??
    //     frame.addKeyListener(this);

    //     int mapSize = Math.max(Math.min(500 / getNumRows(), 500 / getNumCols()), 1);
    //     setPreferredSize(new Dimension(mapSize * getNumCols(), mapSize * getNumRows()));
    //     addMouseListener(this);
    //     frame.getContentPane().add(this);

    //     frame.pack();
    //     frame.setVisible(true);

	// 	setBackground(defaultBgColor); //TODO add background

	// 	boardHeight = getHeight();
	// 	hexagonSide = 250 / (hexGen + 2);
	// 	//hexagonSide = 25;
	// 	//hexagonSide = (boardHeight - 2 * heightMargin) / 8;
	// 	widthMargin = (getWidth() - (int) (10 * hexagonSide * sqrt3div2)) / 2;
	// 	System.out.println("Boardheight: " + boardHeight);
	// 	System.out.println("HexagonSide: " + hexagonSide);
	// 	System.out.println("WidthMargin: " + widthMargin);

	// 	this.addComponentListener(new ComponentListener() {

    // 		public void componentResized(ComponentEvent e) {
    // 		//	System.out.println(e.getComponent().getSize());
    // 			boardHeight = getHeight();
    // 			//hexagonSide = (boardHeight - 2 * heightMargin) / 8;
    // 			widthMargin = (getWidth() - (int) (10 * hexagonSide * sqrt3div2)) / 2;
    // 			//System.out.println("Boardheight: " + boardHeight);
    // 			//System.out.println("HexagonSide: " + hexagonSide);
    // 			//System.out.println("WidthMargin: " + widthMargin);
    // 		}

    // 		public void componentHidden(ComponentEvent e) {}

    // 		public void componentMoved(ComponentEvent e) {}

    // 		public void componentShown(ComponentEvent e) {}
    // 	});

    // }

    // private void load(String imageFileName) {
    //     showFullImage(loadImage(imageFileName));
    //     setTitle(imageFileName);
    // }

    // private void save(String imageFileName) {
    //     try {
    //         BufferedImage bi = new BufferedImage(getWidth(), getHeight(), BufferedImage.TYPE_INT_RGB);
    //         paintComponent(bi.getGraphics());
    //         int index = imageFileName.lastIndexOf('.');
    //         if (index == -1)
    //             throw new RuntimeException("invalid image file name:  " + imageFileName);
    //         ImageIO.write(bi, imageFileName.substring(index + 1), new File(imageFileName));
    //     } catch ( IOException e) {
    //         throw new RuntimeException("unable to save image to file:  " + imageFileName);
    //     }
    // }

	// private BufferedImage loadImage(String imageFileName) {
		
	// 	if(imageFileName == null || "".equals(imageFileName)){
	// 		System.out.println("Image is null or \"\"");
	// 		return null;
	// 	} else{
	// 		final URL url = getClass().getResource(imageFileName);
	// 		if (url == null) {
	// 			throw new RuntimeException("cannot find file:  " + imageFileName);
	// 		}
	// 		try {
	// 			return ImageIO.read(url);
	// 		} catch (IOException e) {
	// 			throw new RuntimeException("unable to read from file:  " + imageFileName);
	// 		}
	// 	}
	// }


    // private void showFullImage(BufferedImage image) {
    //     for (int row = 0; row < getNumRows(); row++) {
    //         for (int col = 0; col < getNumCols(); col++) {
    //             int x = col * image.getWidth() / getNumCols();
    //             int y = row * image.getHeight() / getNumRows();
    //             int c = image.getRGB(x, y);

    //             int red = (c & 0x00ff0000) >> 16;
    //             int green = (c & 0x0000ff00) >> 8;
    //             int blue = c & 0x000000ff;

    //             map[row][col].setColor(new Color(red, green, blue));
    //         }
    //     }
    //     repaint();
    // }

  

	// private displayHexTile(){
	// 	pushMatrix();
	// 	translate(width*0.8, height*0.5);
	// 	polygon(0, 0, 70, 6);
	// 	popMatrix();
	// }

	//function that creates a n-sided polygon on a point circle
	private void hexagon(HexTile hTile) {
		int npoints = 6;
		float x = hTile.getCenterPixels().x;
		float y = hTile.getCenterPixels().y;
		float angle = TWO_PI / npoints;
		float radius = hTile.getRadius();
		beginShape();
		for (float a = 0; a < TWO_PI; a += angle) {
			float sx = x + cos(a) * radius;
			float sy = y + sin(a) * radius;
			vertex(sx, sy);
		}
		endShape(CLOSE);
	}



	public Polygon makeHex(Point center) {
		int xCenter = (int) center.getX();
		int yCenter = (int) center.getY();

		Polygon output = new Polygon();
		output.addPoint(xCenter + 1, yCenter + hexagonSide + 1);
		output.addPoint(xCenter + (int) (hexagonSide * sqrt3div2) + 1, yCenter + (int) (.5 * hexagonSide) + 1);
		output.addPoint(xCenter + (int) (hexagonSide * sqrt3div2) + 1, yCenter - (int) (.5 * hexagonSide) - 1);
		output.addPoint(xCenter + 1, yCenter - hexagonSide - 1);
		output.addPoint(xCenter - (int) (hexagonSide * sqrt3div2) - 1, yCenter - (int) (.5 * hexagonSide) - 1);
		output.addPoint(xCenter - (int) (hexagonSide * sqrt3div2) - 1, yCenter + (int) (.5 * hexagonSide) + 1);

		return output;
	}

	public PGraphics getHexPGraphics(HexTile hTile) {

		Point centerPixels = hTile.getCenterPixels();
		int xCenter = (int) centerPixels.getX();
		int yCenter = (int) centerPixels.getY();

		PGraphics pg = new PGraphics();

		// Polygon output = new Polygon();
		// output.addPoint(xCenter + 1, yCenter + hexagonSide + 1);
		// output.addPoint(xCenter + (int) (hexagonSide * sqrt3div2) + 1, yCenter + (int) (.5 * hexagonSide) + 1);
		// output.addPoint(xCenter + (int) (hexagonSide * sqrt3div2) + 1, yCenter - (int) (.5 * hexagonSide) - 1);
		// output.addPoint(xCenter + 1, yCenter - hexagonSide - 1);
		// output.addPoint(xCenter - (int) (hexagonSide * sqrt3div2) - 1, yCenter - (int) (.5 * hexagonSide) - 1);
		// output.addPoint(xCenter - (int) (hexagonSide * sqrt3div2) - 1, yCenter + (int) (.5 * hexagonSide) + 1);

		return pg;
	}

}  