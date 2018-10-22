import ketai.sensors.*;

float currentBaseFrequencyKey = 0;
int currentNote = -1;
String message;

Instrument instrument;
HashMap<String, Instrument> instruments = new HashMap<String, Instrument>();

Communication communication = new Communication(new CommunicationListener() {
    void onMessage(String m) {}
    void onError(String e) {
      message = e;
    }
});

void setup() {
  sensor = new KetaiSensor(this);
  orientation(PORTRAIT);
  textAlign(CENTER, CENTER);
  textSize(36);
  instruments.put("violin", new Violin(0));
  instruments.put("guitar", new Guitar(1));
  instruments.put("synth", new Synth(2));
  
  instrument = new NoInstrument(-1);
  sensor.start();
}

KetaiSensor sensor;
float accelerometerX, accelerometerY, accelerometerZ;

Instrument previousInstrument = null;

void draw() {
  if (accelerometerX < 2.5 && accelerometerX > -2.5 &&
      accelerometerY < 2.5 && accelerometerY > -2.5 &&
      accelerometerZ > 8 && accelerometerZ < 11.5) {
    instrument = instruments.get("violin");
  } else if (accelerometerX > 0 &&
             accelerometerZ > -2 && accelerometerZ < 8) {
    instrument = instruments.get("synth");
  } else if (accelerometerX > -9 && accelerometerX < -5 &&
      accelerometerY < 3 && accelerometerY > -3 &&
      accelerometerZ > 2 && accelerometerZ < 6) {
    instrument = instruments.get("guitar");
  } else {
    instrument = new NoInstrument(-1);
  }
  
  if (previousInstrument != instrument) {
    previousInstrument = instrument;
    instrument.activate();
  }
  instrument.display();
}

void mousePressed() {
  instrument.mousePressed();
}

void mouseReleased() {
  instrument.mouseReleased();
}

void mouseDragged() {
  instrument.mouseDragged();
}

void onAccelerometerEvent(float x, float y, float z)
{
  accelerometerX = x;
  accelerometerY = y;
  accelerometerZ = z;
}
