class Synth extends Instrument {
    Synth(int index) {
        super(index);
    }

    float whiteBoxMousePressedPosY = 650;
    float boxPosY = 300;
    float boxSideLength = 182;
    float firstBoxPosX = 25;
    float firstWhiteBoxPosX = 25;
    int whiteKeyLength = 640;
    int colorCode = 50;
    int colorCodeIncrease = 45;
    int transparencyValPC = 125;
    int transparencyValADSR;
    int piValue = 1;
    
    // ADSR controllers variables
    int circleHeight = 170;
    int circleWidth = 170;
    int circleRadius = circleWidth / 2;
    int circlePosY = 160;
    int firstCircPosX = 1200;
    int spaceBetweenCircles = circleWidth + 15;
    
    int currentADSRParameter = -1;
    float[] adsr = { 1, 1, 1, 1 };
    
    //pitchState 
    static final byte LIST_C2_E3 = 1;
    static final byte LIST_C3_E4 = 2;
    static final byte LIST_C4_E5 = 3;
    static final byte LIST_C5_E6 = 4;
    byte currentPitchList = LIST_C3_E4;

    // wave controller variables
    String waveLabel = "SIN";
    static final byte SINE_OSC = 1;
    static final byte SAW_OSC = 2;
    static final byte SQR_OSC = 3;
    static final byte TRI_OSC = 4;
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
        background(255);
        //draws the base of the synth
        drawWhitePianoKeys();
        drawBlackPianoKeys();
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
        adsrArcController();
    }

    void drawPitchControllers() {
        int boxXPos = 150;
        int boxYPos = 80;
        int boxWidth = 185;
        int boxHeight = 170;

        strokeWeight(2);
        stroke(0);
        fill(135, transparencyValPC);
        rect(boxXPos, boxYPos, boxWidth, boxHeight);
        fill(135, transparencyValPC);
        rect(boxXPos + 200, boxYPos, boxWidth, boxHeight);
    }

    void drawPitchControllerLabels() {
        int labelXPos = 235;
        int labelYPos = 160;
        String left = "<";
        String right = ">";
        text(left, labelXPos, labelYPos);
        text(right, labelXPos + 200, labelYPos);
    }

    void drawWaveController() {
        stroke(0);
        strokeWeight(2);
        fill(135, transparencyValPC);
        rect(665, 80, 190, 160);
    }

    void drawWaveControllerLabels() {
        if (currentOscillatorType == SQR_OSC) { waveLabel = "SQR"; }
        if (currentOscillatorType == SINE_OSC) { waveLabel = "SIN"; }
        if (currentOscillatorType == TRI_OSC) { waveLabel = "TRI"; }
        if (currentOscillatorType == SAW_OSC) { waveLabel = "SAW"; }
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
        text(s, firstLetterPosX + spacingLetters * 2, letterPosY + 1);
        String r = "R";
        text(r, firstLetterPosX + spacingLetters * 3, letterPosY + 1);
    }

    void drawADSRControllers() {
        color[] fillColors = {color(0, 155, 155), color(103, 78, 167), color(60, 120, 216), color(106, 167, 79)};
        color[] strokeColors = {color(0, 80, 80), color(103, 3, 92), color(60, 46, 141), color(106, 92, 4)};
        color[] colors = {color(0, 100, 100), color(103, 23, 112), color(60, 65, 161), color(106, 112, 20)};
        color[] activeColors = {color(0, 185, 185), color(103,108, 197), color(70, 150, 246), color(106, 197, 109)};
        for (int i = 0; i < 4; i++) {
            fill(colors[i]);
            ellipse(firstCircPosX + spaceBetweenCircles * i, circlePosY, circleWidth, circleHeight);

            fill(currentADSRParameter == i ? activeColors[i] : fillColors[i]);
            strokeWeight(5);
            stroke(strokeColors[i]);
            arc(firstCircPosX + spaceBetweenCircles * i, circlePosY, circleWidth, circleHeight, -PI/2, PI * adsr[i] - PI/2);
        }
        
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
         float firstWhiteBoxPosX = 25;
         float boxSideLength = 182;
         int whiteKeyLength = 640;
         float boxPosY = 300;

        while (firstWhiteBoxPosX + boxSideLength < width) {
            fill(255);
            rect(firstWhiteBoxPosX, boxPosY, boxSideLength, whiteKeyLength);
            firstWhiteBoxPosX += boxSideLength + 3;
        }
    }

//--Key positions used in mousedPressed methods---------------------------------
    float blackKeyMousePressedX(int keyNumber) {
        float boxSideLength = 182;
        float firstBlackBoxPosX = 207 - ((boxSideLength / 1.6)/2);

        if (keyNumber > 5)
            keyNumber += 2;
        else if (keyNumber > 2)
            keyNumber += 1;
        
        return firstBlackBoxPosX + keyNumber * boxSideLength;
    }

    float whiteKeyMousePressedX(int keyNumber) {
        float firstBoxPosX = 25;
        float whiteBoxSideWidth = 182;
        
        return firstBoxPosX + (whiteBoxSideWidth * keyNumber);
    }

    void mousePressed() {
        float whiteKeyPosY2 = whiteboxesPosY + whiteKeysLength;
        float blackKeyPosY2 = boxPosY + blackKeyLength;

        lastMouseY = mouseY;
        
        int base = currentPitchList * 12;
        int[] whiteKeysIndices = {0, 2, 4, 5, 7, 9, 11, 12, 14, 16};
        int[] blackKeysIndices = {1, 3, 6, 8, 10, 13, 15};

//------ Checks if mouse is pressed within keyboardarea ------------------------
        if (mouseX > 35 && mouseX <= 1881 && mouseY > 230 && mouseY <= 975) {

//------Click on BlackPianoKeys-------------------------------------------------
            for (int i = 0; i < 7; i++) {
                if (mouseX > blackKeyMousePressedX(i) && mouseX <= blackKeyMousePressedX(i + 1)
                && mouseY > boxPosY && mouseY <= blackKeyPosY2) {
                    currentFrequency = base + blackKeysIndices[i];
                }
            }

//----------CLICK ON WHITE PIANO KEYS --------------------------------------
            for (int i = 0; i < 10; i++) {
                if (mouseX > whiteKeyMousePressedX(i) && mouseX <= whiteKeyMousePressedX(i + 1)
                && mouseY > whiteBoxMousePressedPosY && mouseY <=  whiteKeyPosY2) {
                    currentFrequency = base + whiteKeysIndices[i];
                }
            }
           
            currentNote = communication.noteOn((int) currentFrequency, 2);
        } 

//------ ADSR controllers -----------------------------------------------------
        for (int i = 0; i < 4; i++) {
            if (dist(mouseX, mouseY, adsrControllersValue(i), circlePosY) < circleRadius) {
                if (currentADSRParameter == i)
                    currentADSRParameter = -1;
                else
                    currentADSRParameter = i;
            }
        }
        
//------ Wave controller -----------------------------------------------------
        if (mouseX > 665 && mouseX <= 665 + 190 && mouseY > 80 && mouseY <= 80 + 160) {
            changeOscillatorLabel();
            changeOscillatorType();
            drawWaveControllerLabels();
        }

//------ Pitch controller -----------------------------------------------------
        // Left pitch controller
        if (mouseX > 150 && mouseX <= 335 && mouseY > 80 && mouseY <= 80 + 160) {
            decreasePitchListsValue();
        }

        if (mouseX > 350 && mouseX <= 535 && mouseY > 80 && mouseY <= 80 + 160) {
            increasePitchListsValue();
        }
    }

    int adsrControllersValue(int arrayNumber) {
        int value = 0;
        if (arrayNumber > 0) {
            value = firstCircPosX + spaceBetweenCircles * arrayNumber;
        } else {
            value = firstCircPosX;
        }
        return value;
    }

    byte increasePitchListsValue() {
        if (currentPitchList == 5) { currentPitchList = LIST_C5_E6; }
        if (currentPitchList == 0) { currentPitchList = LIST_C2_E3; }
        else { currentPitchList++; }
        return currentPitchList;
    }

    byte decreasePitchListsValue() {
        if (currentPitchList == 5) { currentPitchList = LIST_C5_E6; }
        if (currentPitchList == 0) { currentPitchList = LIST_C2_E3; }
        else { currentPitchList--; }
        return currentPitchList;
    }

    byte changeOscillatorLabel() {
        if (currentOscillatorType > TRI_OSC) { currentOscillatorType = 0; }
        return currentOscillatorType++;
    }

    void changeOscillatorType() {
        switch (currentOscillatorType) {
            case SINE_OSC: communication.changeControl(1, 1, 0);
                    break;
            case SQR_OSC: communication.changeControl(1, 2, 0);
                    break;
            case SAW_OSC: communication.changeControl(1, 3, 0);
                    break;
            case TRI_OSC: communication.changeControl(1, 4, 0);
                    break;	
        }  
    }

    void mouseReleased() {
        communication.noteOff(currentNote, 0);
    }

    float lastMouseY = 0;
    void mouseDragged() {
        communication.changePitch(currentNote, (int) ((lastMouseY - mouseY) * 1));
        lastMouseY = mouseY;
    }

    void adsrArcController() {
        if (currentADSRParameter < 0)
            return;

        final float deadZone = 1;
        if (abs(accelerometerY) < deadZone)
            return;

        float increment = 0.008 * abs(accelerometerY);

        if (0 < accelerometerY) {
            adsr[currentADSRParameter] += increment; 
            if (adsr[currentADSRParameter] > 2) {
                adsr[currentADSRParameter] = 2;
            }
        }
        if (0 > accelerometerY) {
            adsr[currentADSRParameter] -= increment;
            if (adsr[currentADSRParameter] < 0) {
                adsr[currentADSRParameter] = 0;
            }
        }
        communication.changeControl(currentADSRParameter + 2, (int) constrain(map(adsr[currentADSRParameter], 0, 2, 0, 999), 0, 999), 0);
    }
    
}
