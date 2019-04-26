/*
 File: BPMArena.pde
 Version: 1.0
 Date: 23/03/2019
 Project: Systel BPM Lab Application Simple Connection
 Author: Daniel Valentin - dtvalentin@gmail.com
 */

HashMap<String, String> quadsX = new HashMap<String, String>();
HashMap<String, String> quadsY = new HashMap<String, String>();

public class BPMArena {

  public static final String QUAD_A = "A";
  public static final String QUAD_B = "B";
  public static final String QUAD_C = "C";
  public static final String QUAD_D = "D";
  public static final String QUAD_E = "E";
  public static final String QUAD_F = "F";
  public static final String QUAD_G = "G";
  public static final String QUAD_H = "H";
  public static final String QUAD_I = "I";

  PApplet parent;

  private PImage arena;
  private PImage mice;

  private int x;
  private int y;
  private int z;
  private int offset_x = 310;
  private int offset_y = 60;


  private int sensor_dx = 25;
  private int sensor_dy = 25;
  private int sensor_y = 12;
  private int sensor_x = 24;
  private int diameter = 25;

  float ex;
  float ey;
  float easing = 0.1;

  String p = "";
  String h = "";


  public BPMArena(PApplet parent) {
    this.parent = parent;

    quadsX.put("00", "A,D,G");
    quadsX.put("01", "A,D,G");
    quadsX.put("02", "A,D,G");
    quadsX.put("03", "A,D,G");
    quadsX.put("04", "A,D,G");
    quadsX.put("05", "A,D,G");
    quadsX.put("06", "A,D,G");
    quadsX.put("07", "A,D,G");

    quadsX.put("08", "B,E,H");
    quadsX.put("09", "B,E,H");
    quadsX.put("10", "B,E,H");
    quadsX.put("11", "B,E,H");
    quadsX.put("12", "B,E,H");
    quadsX.put("13", "B,E,H");
    quadsX.put("14", "B,E,H");
    quadsX.put("15", "B,E,H");

    quadsX.put("16", "C,F,I");
    quadsX.put("17", "C,F,I");
    quadsX.put("18", "C,F,I");
    quadsX.put("19", "C,F,I");
    quadsX.put("20", "C,F,I");
    quadsX.put("21", "C,F,I");
    quadsX.put("22", "C,F,I");    
    quadsX.put("23", "C,F,I");

    quadsY.put("00", "A,B,C");
    quadsY.put("01", "A,B,C");
    quadsY.put("02", "A,B,C");
    quadsY.put("03", "A,B,C");

    quadsY.put("04", "D,E,F");
    quadsY.put("05", "D,E,F");
    quadsY.put("06", "D,E,F");    
    quadsY.put("07", "D,E,F");

    quadsY.put("08", "G,H,I");
    quadsY.put("09", "G,H,I");
    quadsY.put("10", "G,H,I");
    quadsY.put("11", "G,H,I");

    arena = parent.loadImage("arena.png");
    mice = parent.loadImage("mice.png");
    x = 0;
    y = 0;
  }

  public void holePoke(int hp) {
    h = "HP: " + hp;
  }

  public void position(int pos_x, int pos_y, int pos_z, int size_w, int size_h, int size_l, int hp) {
    z = pos_z;
    if (pos_x < 0) {
      x = 0;
    } else if (pos_x > (sensor_x - 1)) 
      x = ((sensor_x - 1) * sensor_dx);
    else x = (pos_x * sensor_dx);
    if (pos_y < 0) {
      y = 0;
    } else if (pos_y > (sensor_y - 1))
      y = ((sensor_y - 1) * sensor_dy);
    else y = (pos_y * sensor_dy);

    p = "POS: (" + pos_x + ", " + pos_y + ", " + pos_z + ")";
    h = "HP: (" + hp + ")";
  }

  public void update() {
    parent.image(arena, 300, 50, 620, 310);
    float targetX = x;
    float dx = targetX - ex;
    ex += dx * easing;
    float targetY = y;
    float dy = targetY - ey;
    ey += dy * easing;

    textFont(font3, 35);
    text(QUAD_A, 400, 120);
    text(QUAD_B, 600, 120);
    text(QUAD_C, 800, 120);

    text(QUAD_D, 400, 220);
    text(QUAD_E, 600, 220);
    text(QUAD_F, 800, 220);


    text(QUAD_G, 400, 320);
    text(QUAD_H, 600, 320);
    text(QUAD_I, 800, 320);

    textFont(font1, 20);
    text(p, 300, 390);
    text(h, 300, 420);

    fill(0, 0, 255);
    parent.image(mice, (ex + offset_x), (ey + offset_y), diameter*2, diameter*2);
  }
}
