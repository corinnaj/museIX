class Synth extends Instrument {

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
    // test split on 2 and multiplied by 999.99 will give the amount of adsr duration useDragged = false;
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
    int currentADSRParameter = 0;

    // wave controller variables
    String waveLabel = "SIN";
    static final byte SINE_OSC = 1;
    static final byte SAW_OSC = 2;
    static final byte SQR_OSC = 3;
    static final byte TRI_OSC = 4;
    static final byte NOISE_OSC = 5;
    byte currentOscillatorType = SAW_OSC;

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
        text(s, firstLetterPosX + spacingLetters * 2, letterPosY + 1);
        String r = "R";
        text(r, firstLetterPosX + spacingLetters * 3, letterPosY + 1);
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

        // Code in the making <- the first controller changes on mouseDragged
        // but will be further improved on a later point
        fill(0, 100, 100);
        strokeWeight(5);
        stroke(0, 80, 80);
        arc(firstCircPosX, circlePosY, circleWidth, circleHeight, 0, PI * test);
    }
    // test split on 2 and multiplied by 999 will give the amount of adsr duration 

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

//--Key positions used in mousedPressed methods---------------------------------
    float blackKeyMousePressedX1(int keyNumber) {
        return firstBlackBoxPosX + (boxSideLength * keyNumber) + (3 * keyNumber);
    }

    float blackKeyMousePressedX2(int keyNumber) {
        return firstBlackBoxPosX + (boxSideLength * keyNumber) + (3 * keyNumber) + (boxSideLength / 1.6);
    }

    float whiteKeyMousePressedX1(int keyNumber) {
        float value = 0;
        if (keyNumber > 0) {
            value = firstBoxPosX + (whiteBoxSideWidth * keyNumber) + (keyNumber * 3);
        } else {
            value = firstBlackBoxPosX; 
        }
        return value;
    }

    float whiteKeyMousePressedX2(int keyNumber) {
        float value = 0; 
        if (keyNumber > 0) {
            value = firstBoxPosX + (whiteBoxSideWidth * keyNumber) + (keyNumber * 3) + whiteBoxSideWidth;
        } else {
            value = firstBoxPosX + whiteBoxSideWidth;
        }
        return value;
    }

    void mousePressed() {
        float whiteKeyPosY2 = whiteboxesPosY + whiteKeysLength;
        float blackKeyPosY2 = boxPosY + blackKeyLength;
        
        int[] myFrequencyListBlackKeys = { 155.6, 185.0, 207.6, 233.0, 277.2, 311.1 };
        int[] myFrequencyListWhiteKeys = { 130.8, 146.6, 164.8, 174.6, 196.0, 220.00, 247.0, 261.6, 293.7, 329.6 };
        int[] adsrParameterList = { 2, 3, 4, 5 };
        // Alternatively
        // This is from C3 to E4
        int[] myWhiteKeyList = { 28, 30, 32, 33, 35, 37, 39, 40, 42, 44 };
        int baseKey = 28; // is C3

//------ Checks if mouse is pressed within keyboardarea ------------------------
        if (mouseX > 35 && mouseX <= 1881 && mouseY > 230 && mouseY <= 975) {

//------Click on BlackPianoKeys-------------------------------------------------
            
            // gotta do something smart for this one... because of the jump of the black keys
            for (int i = 0; i < 8; i++) {
                if (mouseX > whiteKeyMousePressedX1(i) && mouseX <= firstBoxPosX + whiteBoxSideWidth
                && mouseY > boxPosY && mouseY <= blackKeyPosY2) {
                    currentFrequency = myFrequencyListBlackKeys[i];
                }
            }
                        
            /*
            for (int i = 0; i < 8; i++)
                if (mouseX > firstKezMousePressedX1(i) && mouseX <= blackKezMousePressedX2(i))
                    currentFrequency = myFrequencyList[i];*/

            // black key one
            if (mouseX > firstBlackBoxPosX && mouseX <= firstBoxPosX + whiteBoxSideWidth
                && mouseY > boxPosY && mouseY <= blackKeyPosY2) {
                currentFrequency = baseKey;
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
                currentFrequency = 277.2;
            }
            // black key seven
            if (mouseX > blackKeyMousePressedX1(8) && mouseX <= blackKeyMousePressedX2(8)
                && mouseY > boxPosY && mouseY <= blackKeyPosY2) {
                currentFrequency = 311.1;
            }

//----------CLICK ON WHITE PIANO KEYS --------------------------------------
            for (int i = 0; i < 8; i++) {
                if (mouseX > whiteKeyMousePressedX1(i) && mouseX <= whiteKeyMousePressedX2(i)
                && mouseY > whiteBoxMousePressedPosY && mouseY <=  whiteKeyPosY2) {
                    currentFrequency = myFrequencyListBlackKeys[i];
                }
            }
           
            println(currentFrequency);
            currentNote = communication.noteOn((int) currentFrequency, 2);
        } 
        // HAVE TO CHECK IF THIS IS THE CORRECT WAY OF SETTING NOTEOFF! <- TOMORROW / LATER TODAY
        else {
            communication.noteOff(currentNote, 0);
            }

//------ ADSR controllers -----------------------------------------------------
        for (int i = 0; i < 4; i++) {
            if (dist(mouseX, mouseY, adsrControllersValue(i), circlePosY) < circleRadius) {
                currentADSRParameter = adsrParameterList[i];
            }
        }
        
//------ Wave controller -----------------------------------------------------
        if (mouseX > 665 && mouseX <= 665 + 190 && mouseY > 80 && mouseY <= 80 + 160) {
            changeOscillatorLabel();
            drawWaveControllerLabels();
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

    byte changeOscillatorLabel() {
        if (currentOscillatorType > 5) { currentOscillatorType = SINE_OSC; }
        changeOscillatorType();
        return currentOscillatorType++;
    }

    void changeOscillatorType() {
        switch (currentOscillatorType) {
            case SINE_OSC: communication.changeControl(1, 1, 0);
                    println("Changes to SINE");
                    break;
            case SQR_OSC: communication.changeControl(1, 2, 0);
                    println("Changes to SQR");
                    break;
            case SAW_OSC: communication.changeControl(1, 3, 0);
                    println("Changes to SAW");
                    break;
            case TRI_OSC: communication.changeControl(1, 4, 0);
                    println("Changes to TRI");
                    break;
            case NOISE_OSC: communication.changeControl(1, 5, 0);
                    println("Changes to NOISE");
                    break;
            default:
                communication.changeControl(1, 1, 0);
                println("Default is SINE-wave");
            break;	
        }  
    }

    void mouseReleased() {
        communication.noteOff(currentNote, 0);
    }

    void mouseDragged() {
        mouseDragged = true;
        adsrArcController();
    }

    // method in the making <- testing arc function on mouseDragged
    float adsrArcController() {
        
        if(mouseDragged) {
            test += 0.01;        
        }
        return test;
    }
    // test split on 2 and multiplied by 999.99 will give the amount of adsr duration 
    
}
