import ketai.sensors.*;

float currentBaseFrequencyKey = 0;
int currentNote = -1;

Instrument instrument;
HashMap<String, Instrument> instruments = new HashMap<String, Instrument>();

void setup() {
  sensor = new KetaiSensor(this);
  sensor.start();
  orientation(LANDSCAPE);
  textAlign(CENTER, CENTER);
  textSize(36);

  instruments.put("violin", new Violin());
  instruments.put("guitar", new Guitar());

  instrument = new NoInstrument();
}

KetaiSensor sensor;
float accelerometerX, accelerometerY, accelerometerZ;

void draw() {
  if (accelerometerX < 1 && accelerometerX > -1.5 &&
      accelerometerY < 2 && accelerometerY > -0.5 &&
      accelerometerZ > 9 && accelerometerZ < 10.5) {
    instrument = instruments.get("violin");
  } else {
    instrument = instruments.get("guitar");
  }
  instrument.display();
}

void mousePressed() {
  instrument.mousePressed();
  currentBaseFrequencyKey = mouseY;
  currentNote = communication.noteOn((int) map(mouseY, 0, height, 0, 999), 200);
}

void mouseReleased() {
  instrument.mouseReleased();
  communication.noteOff(currentNote, 200);
  currentNote = -1;
}

void mouseDragged() {
  instrument.mouseDragged();
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
