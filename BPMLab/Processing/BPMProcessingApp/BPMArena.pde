/*
 File: BPMArena.pde
 Version: 1.0
 Date: 23/03/2019
 Project: Systel BPM Lab Application Simple Connection
 Author: Daniel Valentin - dtvalentin@gmail.com
 */


public class BPMQuadrant {

  public static final String QUAD_A = "A";
  public static final String QUAD_B = "B";
  public static final String QUAD_C = "C";
  public static final String QUAD_D = "D";
  public static final String QUAD_E = "E";
  public static final String QUAD_F = "F";
  public static final String QUAD_G = "G";
  public static final String QUAD_H = "H";
  public static final String QUAD_I = "I";

  public int pos_x;
  public int pos_y;
  public String id;
  public int index;

  public BPMQuadrant(int index, String id, int x, int y) {
    this.pos_x = x;
    this.pos_y = y;
    this.id = id;
    this.index = index;
  }
}


public class BPMArena {

  public LinkedHashMap<Integer, String> quadsX = new LinkedHashMap<Integer, String>();
  public LinkedHashMap<Integer, String> quadsY = new LinkedHashMap<Integer, String>();
  public LinkedHashMap<String, BPMQuadrant> quadCoords = new LinkedHashMap<String, BPMQuadrant>();

  private PImage arena;
  private PImage mice;
  private PImage rearingUp;
  private PImage rearingDown;
  private PImage hpOff;
  private PImage hpOn;

  private int x = 0;
  private int y = 0;
  private int z = 0;
  private int h = 0;

  private int offset_x = 285;
  private int offset_y = 275;
  private int sensor_dx = 24;
  private int sensor_dy = 22;
  private int diameter = 50;
  private float ex;
  private float ey;
  private float easing = 0.3;

  private String pos = "";
  private String hp = "";

  public BPMArena() {

    quadsX.put(0, "A,D,G");
    quadsX.put(1, "A,D,G");
    quadsX.put(2, "A,D,G");
    quadsX.put(3, "A,D,G");
    quadsX.put(4, "A,D,G");
    quadsX.put(5, "A,D,G");
    quadsX.put(6, "A,D,G");

    quadsX.put(7, "B,E,H");
    quadsX.put(8, "B,E,H");
    quadsX.put(9, "B,E,H");
    quadsX.put(10, "B,E,H");
    quadsX.put(11, "B,E,H");
    quadsX.put(12, "B,E,H");
    quadsX.put(13, "B,E,H");
    quadsX.put(14, "B,E,H");
    quadsX.put(15, "B,E,H");
    quadsX.put(16, "B,E,H");

    quadsX.put(17, "C,F,I");
    quadsX.put(18, "C,F,I");
    quadsX.put(19, "C,F,I");
    quadsX.put(20, "C,F,I");
    quadsX.put(21, "C,F,I");
    quadsX.put(22, "C,F,I");    
    quadsX.put(23, "C,F,I");

    quadsY.put(0, "A,B,C");
    quadsY.put(1, "A,B,C");
    quadsY.put(2, "A,B,C");
    quadsY.put(3, "A,B,C");

    quadsY.put(4, "D,E,F");
    quadsY.put(5, "D,E,F");
    quadsY.put(6, "D,E,F");    
    quadsY.put(7, "D,E,F");

    quadsY.put(8, "G,H,I");
    quadsY.put(9, "G,H,I");
    quadsY.put(10, "G,H,I");
    quadsY.put(11, "G,H,I");

    quadCoords.put(BPMQuadrant.QUAD_G, new BPMQuadrant(7, BPMQuadrant.QUAD_G, 0, 0));
    quadCoords.put(BPMQuadrant.QUAD_H, new BPMQuadrant(8, BPMQuadrant.QUAD_H, 1, 0));
    quadCoords.put(BPMQuadrant.QUAD_I, new BPMQuadrant(9, BPMQuadrant.QUAD_I, 2, 0));
    quadCoords.put(BPMQuadrant.QUAD_D, new BPMQuadrant(4, BPMQuadrant.QUAD_D, 0, 1));
    quadCoords.put(BPMQuadrant.QUAD_E, new BPMQuadrant(5, BPMQuadrant.QUAD_E, 1, 1));
    quadCoords.put(BPMQuadrant.QUAD_F, new BPMQuadrant(6, BPMQuadrant.QUAD_F, 2, 1));
    quadCoords.put(BPMQuadrant.QUAD_A, new BPMQuadrant(1, BPMQuadrant.QUAD_A, 0, 2));
    quadCoords.put(BPMQuadrant.QUAD_B, new BPMQuadrant(2, BPMQuadrant.QUAD_B, 1, 2));
    quadCoords.put(BPMQuadrant.QUAD_C, new BPMQuadrant(3, BPMQuadrant.QUAD_C, 2, 2));

    arena = loadImage("arena.png");
    mice = loadImage("mice.png");
    rearingUp = loadImage("rearingUp.png");
    rearingDown = loadImage("rearingDown.png");
    hpOff  = loadImage("hpOff.png");
    hpOn  = loadImage("hpOn.png");

    reset();
  }

  public void reset() {
    BPMRegister reset = new BPMRegister();
    setPosition(reset);
  }

  public void setPosition(BPMRegister register) {
    if (register.pos_x >= 0 &&  register.pos_y >= 0) {

      // Z Position
      z = register.pos_z;

      // X Position
      x = (register.pos_x * sensor_dx);

      // Y Position
      y = (register.pos_y * sensor_dy);

      // H Position
      h = register.hp;

      pos = "Sensor: (  )";
      if (register.pos_z != -1) {
        pos = "Sensor: ( " + register.pos_z + " )";
      }

      hp = "Sensor: (  )";
      if (register.hp != -1) {
        hp = "Sensor: ( " + (register.hp + 1) + " )";
      }
    }
  }

  public void update() {

    // Position Calc
    image(arena, 300, 50, 620, 310);
    float targetX = x;
    float dx = targetX - ex;
    ex += dx * easing;
    float targetY = y;
    float dy = targetY - ey;
    ey += dy * easing;

    // Quadrants
    textFont(font3, 35);
    text("A", 400, 290);
    text("B", 600, 290);
    text("C", 800, 290);
    text("D", 400, 190);
    text("E", 600, 190);
    text("F", 800, 190);
    text("G", 400, 80);
    text("H", 600, 80);
    text("I", 800, 80);

    // Arena Draw
    textFont(font1, 20);
    fill(0, 102, 153);
    text(hp, 290, 390);
    text(pos, 630, 390);
    fill(0, 0, 255);
    image(mice, (ex + offset_x) + (diameter / 2), (-ey + offset_y)+ (diameter / 2), diameter, diameter);

    if (h == -1) {
      image(hpOff, 410, 390, 160, 68);
    } else {
      image(hpOn, 410, 390, 160, 68);
    }

    if (z == -1) {
      image(rearingDown, 750, 365, 163, 97);
    } else {
      image(rearingUp, 750, 365, 173, 107);
    }
  }
}
