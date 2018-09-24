class Violin extends Instrument {
  static final float eFrequency = 659.0;
  static final float aFrequency = 440.0;
  static final float dFrequency = 293.7;
  static final float gFrequency = 196.0;
  float currentFrequency = 0.0;
  int initialMouseY = 0;
  
  int prevMouseX = -1;
  int tutStep = -1;
  boolean isInTut = false;

  void startup() {
    orientation(PORTRAIT);
    imageMode(CENTER);
    rectMode(CORNER);
    textSize(50);
  }

  void display()  {
    startup();
    PImage img = loadImage("violin.jpg");
    pushMatrix();
    translate(width/2, height/2 + 800);
    scale(4, 4);
    image(img, 0, 0);
    scale(0.25, 0.25);
    popMatrix();
    createLabels();
    if (isInTut) {
      fill(125, 200);
      rect(0, 0, width, height);
      playTutorial(tutStep);
    } else {
      createTutorialButton();
    }
  }
  
  void createLabels() {
    fill(255);
    textSize(100);
    text("G", 1 * width/4, height - 100);
    text("D", 4 * width/10, height - 100);
    text("A", 6 * width/10, height - 100);
    text("E", 26 * width/36, height - 100);
  }
  
  void createTutorialButton() {
    noStroke();
    fill(125, 125);
    rect(40, 40, 400, 120, 7);
    fill(255);
    textSize(42);
    textAlign(CENTER, CENTER);
    text("Show tutorial", 240, 100);
  }

  void playTutorial(int step) {
    isInTut = true;
    fill(255);
    if (step < 0 || step > 3) {
      tutStep = -1;
      isInTut = false;
    } else if (step == 0) {
        text("Press any of the strings to play a sound", 0, 0, width, height);
    } else if (step == 1) {
        text("Drag finger across the strings to keep playing", 0, 0, width, height);
    } else if (step == 2) {
        text("Dragging more quickly will make the sound louder", 0, 0, width, height);
    } else if (step == 3) {
        text("Drag finger up or down to change the pitch", 0, 0, width, height);
    }
  }
  
   boolean isInTutButton() {
     return mouseX > 40 && mouseX < 440 && mouseY > 40 && mouseY < 160;
   }
   
  void mousePressed() {
    initialMouseY = mouseY;
    if (isInTut) {
      playTutorial(tutStep++);
      return;
    }
    if (isInTutButton()){
      tutStep = 0;
      playTutorial(tutStep);
    }
    if (mouseX > width/4 && mouseX <= 7 * width/18) {
      currentFrequency = gFrequency;
    } else if (mouseX > 7 * width/18 && mouseX <= width/2) {
      currentFrequency = dFrequency;
    } else if (mouseX > width/2 && mouseX <= 11 * width/18) {
      currentFrequency = aFrequency;
    } else if (mouseX > 11 * width/18 && mouseX <= 3 * width/4) {
      currentFrequency = eFrequency;
    }
    currentNote = communication.noteOn((int) currentFrequency, 0);
  }

  int getMouseMovementSpeed() {
    int speedX;
    if (prevMouseX > 0) {
      speedX = abs(mouseX - prevMouseX);
    } else {
      speedX = 0;
    }
    prevMouseX = mouseX;
    return speedX;
  }

  void mouseReleased() {
    communication.noteOff(currentNote, 0);
  }

  void mouseDragged() {
      int speed = getMouseMovementSpeed();
      if (speed > 0) {
        currentNote = communication.noteOn((int) currentFrequency, speed);
      }
      communication.changePitch(currentNote, initialMouseY - mouseY);
  }
}
