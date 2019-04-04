/*
 File: BPMArena.pde
 Version: 1.0
 Date: 23/03/2019
 Project: Systel BPM Lab Application Simple Connection
 Author: Daniel Valentin - dtvalentin@gmail.com
 */

public class BPMArena {

  PApplet parent;

  private PImage arena;
  private PImage mice;

  private int x;
  private int y;
  private int z;
  private int offset_x = 295;
  private int offset_y = 60;


  private int sensor_dx = 25;
  private int sensor_dy = 25;
  private int sensor_y = 12;
  private int sensor_x = 24;
  private int diameter = 25;

  PFont font = createFont("Arial", 6);

  float ex;
  float ey;
  float easing = 0.1;

  String t = "";
  String p = "";
  String h = "";

  public BPMArena(PApplet parent) {
    this.parent = parent;
    arena = parent.loadImage("arena.png");
    mice = parent.loadImage("mice.png");
    x = 0;
    y = 0;
  }

  public void setTitle(String title) {
    t = title;
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
    p = "POS: (" + pos_x + ", " + pos_y + ")";
  }

  public void draw() {
    parent.image(arena, 580, 195, 620, 310);
    float targetX = x;
    float dx = targetX - ex;
    ex += dx * easing;
    float targetY = y;
    float dy = targetY - ey;
    ey += dy * easing;

    textFont(font, 26);
    text(t, 900, 60);
    text(p, 900, 90);
    text(h, 900, 130);
    fill(0, 0, 255);
    parent.image(mice, (ex + offset_x), (ey + offset_y), diameter*2, diameter*2);
  }
}
