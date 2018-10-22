float currentBaseFrequencyKey = 0;
int currentNote = -1;

String message = null;

Communication communication = new Communication(new CommunicationListener() {
    void onMessage(String m) {}
    void onError(String e) {
      message = e;
    }
});

void setup() {
  size(400, 400);
}

void draw() {
  text(message != null ? message : "This is a phone.", 100, 100);
}

int i = 0;
void mousePressed() {
  // test for control messages
  if (mouseButton == RIGHT) {
    // communication.changeControl(3, 4, 5);
    communication.requestInstrument(i++);
    return;
  }
  currentBaseFrequencyKey = mouseY;
  currentNote = communication.noteOn((int) map(mouseY, 0, height, 0, 999), 200);
}

void mouseReleased() {
  if (mouseButton == RIGHT)
    return;

  communication.noteOff(currentNote, 200);
  currentNote = -1;
}

void mouseDragged() {
  if (currentNote >= 0) {
    float delta = mouseY - currentBaseFrequencyKey;
    communication.changePitch(currentNote, (int) constrain(map(delta, -30, 30, 0, 999), 0, 999));
  }
}
