class Violin extends Instrument {
  void display()  {
    imageMode(CENTER);
    PImage img = loadImage("violin.jpg");
    pushMatrix();
    translate(width/2 + 800, height/2);
    rotate(-HALF_PI);
    scale(4, 4);
    image(img, 0, 0);
    scale(0.25, 0.25);
    rotate(HALF_PI);
    translate(-width/2 - 200, -height/2);
    popMatrix();
    createLabels();
    help();
  }
  void createLabels() {
    fill(255);
    textSize(100);
    pushMatrix();
    translate(width/2, height/2);
    rotate(-HALF_PI);
    text("G", -width/8, 2 * height/3);
    text("D", -width/16, 2 * height/3);
    text("A", width/16, 2 * height/3);
    text("E", width/8, 2 * height/3);
    translate(-width/2, -height/2);
    rotate(HALF_PI);
    popMatrix();
  }
  void help() {
    fill(255);
    rect(height/4, 0, height/2, height);
  }

  void mousePressed() {
    if (mouseX < width/2 && mouseX > width/4) {
      println("here");
    }
    println("VIOLIN!!");
  }
  void mouseReleased() {
    println("VIOLIN! Release!");
  }
  void mouseDragged() {
    println("VIOLIN! Drag!");
  }
}
