// import ketai.sensors.*;

void setup() {
  size(800, 800);
}

float currentBaseFrequencyKey = 0;
int currentNote = -1;

int computeVelocity() {
  return (int) map(mouseX, 0, width, 0, 999);
}

void mousePressed() {
  currentBaseFrequencyKey = mouseY;
  currentNote = communication.noteOn((int) map(mouseY, 0, height, 0, 999), computeVelocity());
}

void mouseReleased() {
  communication.noteOff(currentNote, computeVelocity());
  currentNote = -1;
}

void mouseDragged() {
  if (currentNote >= 0) {
    float delta = mouseY - currentBaseFrequencyKey;
    communication.changePitch(currentNote, (int) constrain(map(delta, -30, 30, 0, 999), 0, 999));
  }
}

void draw() {}

