abstract class Instrument {
  abstract void display();
  abstract void mousePressed();
  abstract void mouseReleased();
  abstract void mouseDragged();
}

class NoInstrument extends Instrument {
  void display() {
    fill(255);
    background(78, 93, 75);
    text("Accelerometer: \n" +
        "x: " + nfp(accelerometerX, 1, 3) + "\n" +
        "y: " + nfp(accelerometerY, 1, 3) + "\n" +
        "z: " + nfp(accelerometerZ, 1, 3), 0, 0, width, height);
  }
  void mousePressed() {}
  void mouseReleased() {}
  void mouseDragged() {}
}
