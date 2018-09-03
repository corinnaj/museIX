class Violin extends Instrument {
  static final float eFrequency = 659.0;
  static final float aFrequency = 440.0;
  static final float dFrequency = 293.7;
  static final float gFrequency = 196.0;
  float currentFrequency = 0.0;
  int initialMouseX = 0;
  int initialMouseY = 0;

  void display()  {
    orientation(PORTRAIT);
    imageMode(CENTER);
    PImage img = loadImage("violin.jpg");
    pushMatrix();
    translate(width/2, height/2 + 800);
    scale(4, 4);
    image(img, 0, 0);
    scale(0.25, 0.25);
    popMatrix();
    //createLabels();
  }
  void createLabels() {
    fill(255);
    textSize(100);
    text("G", width/2, height);
    text("D", width/2, height);
    text("A", width/2, height);
    text("E", width/2, height);
  }

  void mousePressed() {
    initialMouseX = mouseX;
    initialMouseY = mouseY;
    if (mouseX > width/4 && mouseX <= 7 * width/18) {
      currentFrequency = gFrequency;
    } else if (mouseX > 7 * width/18 && mouseX <= width/2) {
      currentFrequency = dFrequency;
    } else if (mouseX > width/2 && mouseX <= 11 * width/18) {
      currentFrequency = aFrequency;
    } else if (mouseX > 11 * width/18 && mouseX <= 3 * width/4) {
      currentFrequency = eFrequency;
    }
  }
  void mouseReleased() {
    println("VIOLIN! Release!");
  }
  void mouseDragged() {
    println(initialMouseX - mouseX);
    println(initialMouseY - mouseY);
  }
}
