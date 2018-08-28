class Guitar extends Instrument {
  void display() {
    PImage image = loadImage("guitar.jpg");
    image(image, width/2, height/2, width, height);
  }

  void mousePressed() {
    println(mouseX + "   " + mouseY);
  }
  void mouseReleased() {
  }
  void mouseDragged() {
  }
}
