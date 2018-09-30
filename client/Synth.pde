class Synth extends Instrument {

    // values used for base for the weekly challenge! 8-)
    //int boxPosY = 25;
    //int boxSideLength = 100;
    float whiteBoxMousePressedPosY = 650;
    float boxPosY = 300;
    float boxSideLength = 182;
    float firstBoxPosX = 25;
    float firstWhiteBoxPosX = 25;
    int whiteKeyLength = 640;
    int colorCode = 50;
    int colorCodeIncrease = 45;
    int transparencyValPCL = 0;
    int transparencyValPCR = 0;
    int transparencyValADSR;
    int piValue = 1;
    float test = 0;
    boolean mouseDragged = false;
    boolean adsrControllerActivated = false;
    boolean pitchControlLeftActivated = false;
    boolean pitchControlRightActivated  = false;

    // ADSR controllers variables
    int circleHeight = 170;
    int circleWidth = 170;
    int circleRadius = circleWidth / 2;
    int circlePosY = 160;
    int firstCircPosX = 1200;
    int spaceBetweenCircles = circleWidth + 15;

    // wave controller variables
    String waveLabel = "SIN";
    static final byte SINE_OSC = 1;
    static final byte SAW_OSC = 2;
    static final byte SQR_OSC = 3;
    static final byte TRI_OSC = 4;
    static final byte NOISE_OSC = 5;
    byte currentOscillatorType = SINE_OSC;

    // MousePressed variables for white keys
    float whiteboxesPosY = 300;
    float whiteBoxSideWidth = 182;
    int whiteKeysLength = 640;

    // drawing blackKeys
    int blackKeyLength = 350;
    float firstBlackBoxPosX = 207 - ((boxSideLength / 1.6)/2);

    // soundSetup
    float currentFrequency = 0.0;
    int currentNote = 0;

    void startup() {
        orientation(LANDSCAPE);
        textSize(100);
        //draws the base of the synth / piano
        drawWhitePianoKeys();
        drawBlackPianoKeys();
        //soundSetup();
    }

    // this is the designated draw class
    void display() {
        startup();
        drawPitchControllers();
        drawWaveController();
        drawADSRControllers();
        drawADSRLabels();
        drawWaveControllerLabels();
        drawPitchControllerLabels();
        mapKeyboardForMousePressedEvents();
    }

    void drawPitchControllers() {
        int boxXPos = 150;
        int boxYPos = 80;
        int boxWidth = 185;
        int boxHeight = 170;

        strokeWeight(2);
        stroke(0);
        fill(135, transparencyValPCL);
        rect(boxXPos, boxYPos, boxWidth, boxHeight);
        fill(135, transparencyValPCR);
        rect(boxXPos + 200, boxYPos, boxWidth, boxHeight);
    }

    void drawPitchControllerLabels() {
        int labelXPos = 235; //210
        int labelYPos = 160; //140
        String left = "<";
        String right = ">";
        text(left, labelXPos, labelYPos);
        text(right, labelXPos + 200, labelYPos);
    }

    void drawWaveController() {
        stroke(0);
        strokeWeight(2);
        fill(135, 50);
        rect(665, 80, 190, 160);
    }

    void drawWaveControllerLabels() {
        if (currentOscillatorType == SQR_OSC) { waveLabel = "SQR"; }
        if (currentOscillatorType == SINE_OSC) { waveLabel = "SIN"; }
        if (currentOscillatorType == TRI_OSC) { waveLabel = "TRI"; }
        if (currentOscillatorType == SAW_OSC) { waveLabel = "SAW"; }
        if (currentOscillatorType == NOISE_OSC) { waveLabel = "NOI"; }
        textSize(80);
        text(waveLabel, 754, 160);
        textSize(100);
    }

    void drawADSRLabels() {
        int firstLetterPosX = 1200;
        int letterPosY = 165;
        fill(255);
        int spacingLetters = 185;

        String a = "A";
        text(a, firstLetterPosX, letterPosY);

        String d = "D";
        text(d, firstLetterPosX + spacingLetters, letterPosY + 1);

        String s = "S";
        text(s, firstLetterPosX + spacingLetters*2, letterPosY + 1);

        String r = "R";
        text(r, firstLetterPosX + spacingLetters*3, letterPosY + 1);
    }

    void drawADSRControllers() {
        fill(0, 155, 155);
        ellipse(firstCircPosX, circlePosY, circleWidth, circleHeight);
        fill(103, 78, 167);
        ellipse(firstCircPosX + spaceBetweenCircles, circlePosY, circleWidth, circleHeight);
        fill(60, 120, 216);
        ellipse(firstCircPosX + spaceBetweenCircles * 2, circlePosY, circleWidth, circleHeight);
        fill(106, 167, 79);
        ellipse(firstCircPosX + spaceBetweenCircles * 3, circlePosY, circleWidth, circleHeight);

        fill(0, 100, 100);
        strokeWeight(5);
        stroke(0, 80, 80);
        arc(firstCircPosX, circlePosY, circleWidth, circleHeight, 0, PI * test);
    }

    void drawBlackPianoKeys() {
        int keysCounter = 0;
        float firstBlackBoxPosX = 207 - ((boxSideLength / 1.6)/2);

        while (firstBlackBoxPosX + boxSideLength < width) {
            if (keysCounter == 2 || keysCounter == 6) {
                firstBlackBoxPosX += boxSideLength + 3;
                keysCounter++;
                if (keysCounter > 6) { keysCounter = 0; }
            } else {
                fill(0);
                rect(firstBlackBoxPosX, boxPosY, boxSideLength / 1.6, blackKeyLength);
                firstBlackBoxPosX += boxSideLength + 3;
                keysCounter++;
            }
        }
    }

    void drawWhitePianoKeys() {
        while (firstWhiteBoxPosX + boxSideLength < width) {
            fill(255);
            rect(firstWhiteBoxPosX, boxPosY, boxSideLength, whiteKeyLength);
            firstWhiteBoxPosX += boxSideLength + 3;
        }
    }

    void mapKeyboardForMousePressedEvents() {
        // first white key
        stroke(121, 111, 120);
        noFill();
        rect(firstBoxPosX, whiteBoxMousePressedPosY, whiteBoxSideWidth, whiteKeysLength);
        // seccond white key
        stroke(12, 111, 120);
        rect(firstBoxPosX + whiteBoxSideWidth + 3, whiteBoxMousePressedPosY, whiteBoxSideWidth, whiteKeysLength);
        // third white key
        stroke(12, 18, 120);
        rect(firstBoxPosX + whiteBoxSideWidth * 2 + 6, whiteBoxMousePressedPosY, whiteBoxSideWidth, whiteKeysLength);
        // fourth white key
        stroke(120, 18, 120);
        rect(firstBoxPosX + whiteBoxSideWidth * 3 + 9, whiteBoxMousePressedPosY, whiteBoxSideWidth, whiteKeysLength);
        // fifth white key
        stroke(170, 18, 120);
        rect(firstBoxPosX + whiteBoxSideWidth * 4 + 12, whiteBoxMousePressedPosY, whiteBoxSideWidth, whiteKeysLength);
        // sixth white key
        stroke(0, 180, 120);
        rect(firstBoxPosX + whiteBoxSideWidth * 5 + 15, whiteBoxMousePressedPosY, whiteBoxSideWidth, whiteKeysLength);
        // seventh white key
        stroke(0, 1, 120);
        rect(firstBoxPosX + whiteBoxSideWidth * 6 + 18, whiteBoxMousePressedPosY, whiteBoxSideWidth, whiteKeysLength);
        // eigth white key
        stroke(0, 160, 44);
        rect(firstBoxPosX + whiteBoxSideWidth * 7 + 21, whiteBoxMousePressedPosY, whiteBoxSideWidth, whiteKeysLength);
        // ninth white key
        stroke(0, 1, 80);
        rect(firstBoxPosX + whiteBoxSideWidth * 8 + 24, whiteBoxMousePressedPosY, whiteBoxSideWidth, whiteKeysLength);
        // tenth white key
        stroke(0, 1, 180);
        rect(firstBoxPosX + whiteBoxSideWidth * 9 + 27, whiteBoxMousePressedPosY, whiteBoxSideWidth, whiteKeysLength);

        // first black key
        stroke(250, 200, 180);
        rect(firstBlackBoxPosX, boxPosY, boxSideLength / 1.6, blackKeyLength);
        stroke(0);
        // seccond black key
        stroke(250, 150, 100);
        rect(firstBlackBoxPosX + (boxSideLength * 1) + 3, boxPosY, boxSideLength / 1.6, blackKeyLength);
        // third black key
        stroke(200, 150, 100);
        rect(firstBlackBoxPosX + (boxSideLength * 3) + 9, boxPosY, boxSideLength / 1.6, blackKeyLength);
        stroke(0);

        // Keyboard area
        stroke(3);
        rect(firstBlackBoxPosX + (boxSideLength * 3) + 9, boxPosY, boxSideLength / 1.6, blackKeyLength);
        stroke(0);
    }

//--Key positions used in mousedPressed methods---------------------------------
    float blackKeyMousePressedX1(int keyNumber) {
        return firstBlackBoxPosX + (boxSideLength * keyNumber) + (3 * keyNumber);
    }

    float blackKeyMousePressedX2(int keyNumber) {
        return firstBlackBoxPosX + (boxSideLength * keyNumber) + (3 * keyNumber) + (boxSideLength / 1.6);
    }

    // only works from seccond key, indexing from 0, 1, 2, 3
    float whiteKeyMousePressedX1(int keyNumber) {
        return firstBoxPosX + (whiteBoxSideWidth * keyNumber) + (keyNumber * 3);
    }

    float whiteKeyMousePressedX2(int keyNumber) {
        return firstBoxPosX + (whiteBoxSideWidth * keyNumber) + (keyNumber * 3) + whiteBoxSideWidth;
    }

    void mousePressed() {
         println("mouseX: " + mouseX);
         println("mouseY: " + mouseY);

//------ Checks if mouse is pressed within keyboardarea ------------------------
        if (mouseX > 35 && mouseX <= 1881 && mouseY > 230 && mouseY <= 975) {

//------Click on BlackPianoKeys-------------------------------------------------
            float blackKeyPosY2 = boxPosY + blackKeyLength;
            // black key one
            if (mouseX > firstBlackBoxPosX && mouseX <= firstBoxPosX + whiteBoxSideWidth
                && mouseY > boxPosY && mouseY <= blackKeyPosY2) {
                currentFrequency = 138.6;
            }
            // black key two
            if (mouseX > blackKeyMousePressedX1(1) && mouseX <= blackKeyMousePressedX2(1)
                && mouseY > boxPosY && mouseY <= blackKeyPosY2) {
                currentFrequency = 155.6;
            }
            // black key three
            if (mouseX > blackKeyMousePressedX1(3) && mouseX <= blackKeyMousePressedX2(3)
                && mouseY > boxPosY && mouseY <= blackKeyPosY2) {
                currentFrequency = 185.0;
            }
            // black key fire
            if (mouseX > blackKeyMousePressedX1(4) && mouseX <= blackKeyMousePressedX2(4)
                && mouseY > boxPosY && mouseY <= blackKeyPosY2) {
                currentFrequency = 207.6;
            }
            // black key fem
            if (mouseX > blackKeyMousePressedX1(5) && mouseX <= blackKeyMousePressedX2(5)
                && mouseY > boxPosY && mouseY <= blackKeyPosY2) {
                currentFrequency = 233.0;
            }
            // black key six
            if (mouseX > blackKeyMousePressedX1(7) && mouseX <= blackKeyMousePressedX2(7)
                && mouseY > boxPosY && mouseY <= blackKeyPosY2) {
                println("Black key 6 er trykket på");
                currentFrequency = 277.2;
            }
            // black key seven
            if (mouseX > blackKeyMousePressedX1(8) && mouseX <= blackKeyMousePressedX2(8)
                && mouseY > boxPosY && mouseY <= blackKeyPosY2) {
                println("Black key 7 er trykket på");
                currentFrequency = 311.1;
            }

//------CLICK ON WHITE PIANO KEYS --------------------------------------
            float whiteKeyPosY2 = whiteboxesPosY + whiteKeysLength;
            // first key (0)
            if (mouseX > firstBoxPosX && mouseX <= firstBoxPosX + whiteBoxSideWidth
                && mouseY > whiteBoxMousePressedPosY && mouseY <= whiteKeyPosY2) {
                println("Første key er trykket på");
                currentFrequency = 130.8;
            }
            // seccond key (1)
            if (mouseX > whiteKeyMousePressedX1(1) && mouseX <= whiteKeyMousePressedX2(1)
                && mouseY > whiteBoxMousePressedPosY && mouseY <=  whiteKeyPosY2) {
                println("Andre key er trykket på");
                currentFrequency = 146.6;
            }
            // third key (2)
            if (mouseX > whiteKeyMousePressedX1(2) && mouseX <= whiteKeyMousePressedX2(2)
                && mouseY > whiteBoxMousePressedPosY && mouseY <=  whiteKeyPosY2) {
                println("Tredje key er trykket på");
                currentFrequency = 164.8;
            }
            // fourth key (3)
            if (mouseX > whiteKeyMousePressedX1(3) && mouseX <= whiteKeyMousePressedX2(3)
                && mouseY > whiteBoxMousePressedPosY && mouseY <=  whiteKeyPosY2) {
                println("Fjerde key er trykket på");
                currentFrequency = 174.6;

            }
            // fifth key (4)
            if (mouseX > whiteKeyMousePressedX1(4) && mouseX <= whiteKeyMousePressedX2(4)
                && mouseY > whiteBoxMousePressedPosY && mouseY <=  whiteKeyPosY2) {
                println("Femte key er trykket på");
                currentFrequency = 196.0;
            }
            // sixth key (5)
            if (mouseX > whiteKeyMousePressedX1(5) && mouseX <= whiteKeyMousePressedX2(5)
                && mouseY > whiteBoxMousePressedPosY && mouseY <=  whiteKeyPosY2) {
                println("Sjette key er trykket på");
                currentFrequency = 220.00;
            }
            //  seventh key (6)
            if (mouseX > whiteKeyMousePressedX1(6) && mouseX <= whiteKeyMousePressedX2(6)
                && mouseY > whiteBoxMousePressedPosY && mouseY <=  whiteKeyPosY2) {
                println("Sjuende key er trykket på");
                currentFrequency = 247.0;
            }
            //  eight key (7)
            if (mouseX > whiteKeyMousePressedX1(7) && mouseX <= whiteKeyMousePressedX2(7)
                && mouseY > whiteBoxMousePressedPosY && mouseY <=  whiteKeyPosY2) {
                println("Åttende key er trykket på");
                currentFrequency = 261.6;
            }
            // ninth key (8)
            if (mouseX > whiteKeyMousePressedX1(8) && mouseX <= whiteKeyMousePressedX2(8)
                && mouseY > whiteBoxMousePressedPosY && mouseY <=  whiteKeyPosY2) {
                println("Niende key er trykket på");
                currentFrequency = 293.7;
            }
            // tenth key (9)
            if (mouseX > whiteKeyMousePressedX1(9) && mouseX <= whiteKeyMousePressedX2(9)
                && mouseY > whiteBoxMousePressedPosY && mouseY <=  whiteKeyPosY2) {
                println("Tiende key er trykket på");
                currentFrequency = 329.6;
            }
            currentNote = communication.noteOn((int) currentFrequency, 2);
        } else {
            communication.noteOff(currentNote, 0);
            }


//------ ADSR controllers -----------------------------------------------------
        if (dist(mouseX, mouseY, firstCircPosX, circlePosY) < circleRadius) {
            println("A activated");
        }
        if (dist(mouseX, mouseY, firstCircPosX + spaceBetweenCircles, circlePosY) < circleRadius) {
            println("D activated");
        }
        if (dist(mouseX, mouseY, firstCircPosX + spaceBetweenCircles * 2, circlePosY) < circleRadius) {
            println("S activated");
        }
        if (dist(mouseX, mouseY, firstCircPosX + spaceBetweenCircles * 3, circlePosY) < circleRadius) {
            println("R activated");
        }
//------ Wave controller -----------------------------------------------------
        if (mouseX > 665 && mouseX <= 665 + 190 && mouseY > 80 && mouseY <= 80 + 160) {
            changeOscillatorLabel();
            drawWaveControllerLabels();
            println("kjører");
        }
    }

    byte changeOscillatorLabel() {
        if (currentOscillatorType > 5) { currentOscillatorType = SINE_OSC; }
        return currentOscillatorType++;
    }

    //void changeOscillatorType() {
    //    communication.changeControl()
    //}

    void mouseReleased() {
        communication.noteOff(currentNote, 0);
    }

    void mouseDragged() {
        mouseDragged = true;
        adsrArcController();
        //println(mouseDragged);
    }

    float adsrArcController() {
        if(mouseDragged) {
            test += 0.01;
            if (test >= 2) {
                test = 2;
            }
        }
        //println(test);
        return test;
    }

    // Buffer getBuffer() {
    //     if (bufferType == SINE_OSC) { SINE; }
    //     if (bufferType == SAW_OSC) { SAW; }
    //     if (bufferType == SQR_OSC) { SQUARE; }
    //     if (bufferType == TRI_OSC) { TRIANGLE; }
    //     if (bufferType == NOISE_OSC) { NOISE; }
    //     else return SINE;
    // }

    // void setBuffer(byte bufferType) {
    //     this.bufferType = bufferType;
    // }
}
