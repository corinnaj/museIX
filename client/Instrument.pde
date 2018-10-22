abstract class Instrument {
  int index;

  Instrument(int index) {
    this.index = index;
  }

  void activate() {
    if (index >= 0)
      communication.requestInstrument(index);
  }

  abstract void display();
  abstract void mousePressed();
  abstract void mouseReleased();
  abstract void mouseDragged();
}

class NoInstrument extends Instrument {
  NoInstrument(int index) {
    super(index);
  }

  @Override
  void activate() {}

  void display() {
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
