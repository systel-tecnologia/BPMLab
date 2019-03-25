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

  private float x;
  private float y;
  private float easing = 0.05;
  private int radius = 24;
  private int edge = 100;
  private int inner = edge + radius;


  public BPMArena(PApplet parent) {
    this.parent = parent;
    arena = parent.loadImage("arena.png");
  }

  public void draw() {
    parent.image(arena, 400, 300, 620, 310);

    if (abs(mouseX - x) > 0.1) {
      x = x + (mouseX - x) * easing;
    }
    if (abs(mouseY - y) > 0.1) {
      y = y + (mouseY- y) * easing;
    }

/*    x = constrain(x, inner, arena.width - inner);
    y = constrain(y, inner, arena.height - inner);
    fill(76);
    rect(arena.top, arena., arena.width-edge, arena.height-edge);
    fill(150);  
    ellipse(x, y, radius, radius);*/

    float targetX = mouseX;
    float dx = targetX - x;
    x += dx * easing;
    float targetY = mouseY;
    float dy = targetY - y;
    y += dy * easing;
    parent.ellipse(x, y, 15, 15);
  }
}
