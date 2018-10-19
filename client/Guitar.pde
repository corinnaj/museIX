int NUM_STRINGS = 6;
float HEIGHT = 1920;
float WIDTH = 1080;
int NUM_BANDS = 12;
float BANDS_PERCENTAGE = 0.65;
float BAND_HEIGHT = HEIGHT * BANDS_PERCENTAGE / NUM_BANDS;
float BAND_WIDTH = 500.0;
float STRING_DISTANCE = BAND_WIDTH / NUM_STRINGS;
float CHORD_TEXT_SIZE = 80;

int CHORD_DURATION = 1000;
int lastNoteId;
int activeChord = -1;
int[] activeChordNoteIds = new int[6];
int activeChordStartTime;

int BASE_TONE_TUNING = 20;

int[] STRING_TONE_OFFSET = {
  BASE_TONE_TUNING + 0,  // e2
  BASE_TONE_TUNING + 5,  // a2
  BASE_TONE_TUNING + 10, // d3
  BASE_TONE_TUNING + 15, // g3
  BASE_TONE_TUNING + 19, // b3
  BASE_TONE_TUNING + 24  // e4
};

int[][] CHORDS = {
  {0, 0, 0, 2, 3, 2}, // d major
  {0, 0, 2, 2, 1, 0}, // a minor
  {0, 2, 2, 0, 0, 0}, // e minor
  {0, 3, 2, 0, 1, 0}, // c major
  {1, 3, 3, 2, 1, 1}, // f major
  {3, 2, 0, 0, 0, 3}, // g major
};

class Guitar extends Instrument {
  void display() {
    orientation(PORTRAIT);
    background(255);
    drawGuitar();
    textAlign(LEFT, BASELINE);
    textSize(CHORD_TEXT_SIZE);
    text("Dmaj", 0, CHORD_TEXT_SIZE * 2);
    text("Amin", 0, CHORD_TEXT_SIZE * 4);
    text("Emin", 0, CHORD_TEXT_SIZE * 6);
    text("Cmaj", 0, CHORD_TEXT_SIZE * 8);
    text("Fmaj", 0, CHORD_TEXT_SIZE * 10);
    text("Gmaj", 0, CHORD_TEXT_SIZE * 12);

    if (activeChord >= 0 && millis() - activeChordStartTime > CHORD_DURATION) {
      activeChordOff();
      activeChord = -1;
    }
  }

  void mouseDragged() {
  }

  void mouseReleased() {
    communication.noteOff(lastNoteId, 999);
    lastNoteId = -1;
  }

  void mousePressed() {
    float start = width / 2 - BAND_WIDTH / 2;

    // chords
    if (mouseX < CHORD_TEXT_SIZE * 3) {
      for (int i = 0; i < CHORDS.length; i++) {
        if (mouseY < (i * 2 + 2) * CHORD_TEXT_SIZE) {
          if (activeChord >= 0)
            activeChordOff();
          activeChord = i;
          activeChordStartTime = millis();
          for (int c = 0; c < CHORDS[i].length; c++) {
            activeChordNoteIds[c] = communication.noteOn(STRING_TONE_OFFSET[c] + CHORDS[i][c], 100);
          }
          return;
        }
      }
    }

    // strings
    for (int i = 0; i < NUM_STRINGS; i++) {
      if (mouseX >= start + i * STRING_DISTANCE && mouseX < start + (i + 1) * STRING_DISTANCE) {
        for (int j = 0; j < NUM_BANDS; j++) {
          if (mouseY >= BAND_HEIGHT * j && mouseY < BAND_HEIGHT * (j + 1)) {
            if (lastNoteId >= 0)
              communication.noteOff(lastNoteId, 999);
            lastNoteId = communication.noteOn(STRING_TONE_OFFSET[i] + j + 1, 100);
            return;
          }
        }
        // was outside the regular bands so play base tone
        lastNoteId = communication.noteOn(STRING_TONE_OFFSET[i], 100);
      }
    }
  }

  void activeChordOff() {
    for (int c = 0; c < CHORDS[activeChord].length; c++) {
      communication.noteOff(activeChordNoteIds[c], 999);
    }
  }

  void drawGuitar() {
    noStroke();
    // body
    fill(#BA763A);
    float BASE_SIZE = width  * 2;
    ellipse(width / 2, height + 50, BASE_SIZE, BASE_SIZE * 3.0/4.0);

    // head
    fill(#8A6B50);
    rect(width / 2 - BAND_WIDTH / 2, 0, BAND_WIDTH, height - (1 - BANDS_PERCENTAGE) / 2.0 * height);

    // circle on top of body
    fill(#695340);
    float CIRCLE_SIZE = height * (1 - BANDS_PERCENTAGE);
    ellipse(width / 2, height * (BANDS_PERCENTAGE + (1 - BANDS_PERCENTAGE) / 2), CIRCLE_SIZE, CIRCLE_SIZE);

    // bands
    stroke(#cccccc);
    for (int i = 1; i <= NUM_BANDS; i++) {
      float y = i * BAND_HEIGHT;
      line(width / 2 - BAND_WIDTH / 2, y, width / 2 + BAND_WIDTH / 2, y);
    }

    // strings
    stroke(#ffffff);
    float start = width / 2 - BAND_WIDTH / 2 + (STRING_DISTANCE / 2);
    for (int i = 0; i < NUM_STRINGS; i++) {
      float x = start + i * STRING_DISTANCE;
      line(x, 0, x, height);
    }

    // visualize chords
    noStroke();
    fill(#990000);
    if (activeChord >= 0) {
      for (int i = 0; i < CHORDS[activeChord].length; i++) {
        int offset = CHORDS[activeChord][i] - 1;
        if (offset >= 0)
          ellipse(start + i * STRING_DISTANCE, (offset + 0.5) * BAND_HEIGHT, STRING_DISTANCE,  STRING_DISTANCE);
      }
    }

  }
}
