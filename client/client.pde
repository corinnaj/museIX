import ketai.sensors.*;

float currentBaseFrequencyKey = 0;
int currentNote = -1;

Instrument instrument;

void setup() {
  sensor = new KetaiSensor(this);
  sensor.start();
  orientation(LANDSCAPE);
  textAlign(CENTER, CENTER);
  textSize(36);
  instrument = new NoInstrument();
}

KetaiSensor sensor;
float accelerometerX, accelerometerY, accelerometerZ;

void draw() {
  if (accelerometerX < 1 && accelerometerX > -1.5 &&
      accelerometerY < 2 && accelerometerY > -0.5 &&
      accelerometerZ > 9 && accelerometerZ < 10.5) {
    textSize(50);
    background(#ff0000);

    instrument = new Violin();
  } else {
    instrument = new NoInstrument();
  }
  instrument.display();

}

abstract class Instrument {
  abstract void display();
}

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
}

class NoInstrument extends Instrument {
  void display() {
    background(78, 93, 75);
    text("Accelerometer: \n" +
        "x: " + nfp(accelerometerX, 1, 3) + "\n" +
        "y: " + nfp(accelerometerY, 1, 3) + "\n" +
        "z: " + nfp(accelerometerZ, 1, 3), 0, 0, width, height);
  }
}

void mousePressed() {
  currentBaseFrequencyKey = mouseY;
  currentNote = communication.noteOn((int) map(mouseY, 0, height, 0, 999), 200);
}

void mouseReleased() {
  communication.noteOff(currentNote, 200);
  currentNote = -1;
}

void mouseDragged() {
  if (currentNote >= 0) {
    float delta = mouseY - currentBaseFrequencyKey;
    communication.changePitch(currentNote, (int) constrain(map(delta, -30, 30, 0, 999), 0, 999));
  }
}

void onAccelerometerEvent(float x, float y, float z)
{
  accelerometerX = x;
  accelerometerY = y;
  accelerometerZ = z;
}
