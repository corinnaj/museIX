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
    int transparencyValPCL = 0;
    int transparencyValPCR = 0;
    int transparencyValADSR;
    int piValue = 1;
    float attackParameter = 0;
 
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
        arc(firstCircPosX, circlePosY, circleWidth, circleHeight, 0, PI * attackParameter);
        //println("Test 1 : " + attackParameter);
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
    float blackKeyMousePressedX1(int keyNumber) {
        float value = 0;
        float boxSideLength = 182;
        float firstBlackBoxPosX = 207 - ((boxSideLength / 1.6)/2);

        if (keyNumber > 2 && keyNumber < 5) { keyNumber = keyNumber + 1; }
        if (keyNumber > 6 && keyNumber < 8) { keyNumber = keyNumber + 2; } 
        
        value = firstBlackBoxPosX + (boxSideLength * keyNumber) + (3 * keyNumber);
        
        println("blackposx1" + value);
        return value;
    }

    float blackKeyMousePressedX2(int keyNumber) {
        float value = 0;
        float boxSideLength = 182;
        float firstBlackBoxPosX = 207 - ((boxSideLength / 1.6)/2);
        
        if (keyNumber > 2 || keyNumber < 5) { keyNumber = keyNumber + 1; }
        if (keyNumber > 6 || keyNumber < 8) { keyNumber = keyNumber + 2; }
            
        value = firstBlackBoxPosX + (boxSideLength * keyNumber) + (3 * keyNumber) + (boxSideLength / 1.6);
            
        println("blackpos2 " + value);
        return value;
    }

    float whiteKeyMousePressedX1(int keyNumber) {
        float firstBoxPosX = 25;
        float whiteBoxSideWidth = 182;
        float value = 0;

        if (keyNumber > 0) {
            value = firstBoxPosX + (whiteBoxSideWidth * keyNumber) + (keyNumber * 3);
        } else {
            value = firstBlackBoxPosX; 
        }

        return value;
    }

    float whiteKeyMousePressedX2(int keyNumber) {
        float firstBoxPosX = 25;
        float whiteBoxSideWidth = 182;
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
        
        // float[] myFrequencyListBlackKeys = { 155.6, 185.0, 207.6, 233.0, 277.2, 311.1 };
        // float[] myFrequencyListWhiteKeys = { 130.8, 146.6, 164.8, 174.6, 196.0, 220.00, 247.0, 261.6, 293.7, 329.6 };
        
        int[] adsrParameterList = { 2, 3, 4, 5 };
       
        // C2 to E3
        int[] whiteKeyList1 = { 16, 18, 20, 21, 23, 25, 27, 28, 30, 32 };
        int[] blackKeyList1 = { 17, 19, 22, 24, 26, 29, 31 };
        // C3 to E4
        int[] whiteKeyList2 = { 28, 30, 32, 33, 35, 37, 39, 40, 42, 44 };
        int[] blackKeyList2 = { 29, 31, 34, 36, 38, 41, 43 };
        // C4 to E5
        int[] whiteKeyList3 = { 40, 42, 44, 45, 47, 49, 51, 52, 54, 56 };
        int[] blackKeyList3 = { 41, 43, 46, 48, 50, 53, 55 };
        //  C5 to E6
        int[] whiteKeyList4 = { 52, 54, 56, 57, 59, 61, 63, 64, 66, 68 };
        int[] blackKeyList4 = { 53, 55, 58, 60, 62, 65, 67 };

//------ Checks if mouse is pressed within keyboardarea ------------------------
        if (mouseX > 35 && mouseX <= 1881 && mouseY > 230 && mouseY <= 975) {

//------Click on BlackPianoKeys-------------------------------------------------
            for (int i = 0; i < 8; i++) {
                if (mouseX > blackKeyMousePressedX1(i) && mouseX <= blackKeyMousePressedX2(i)
                && mouseY > boxPosY && mouseY <= blackKeyPosY2) {
                    if (currentPitchList == LIST_C2_E3) { currentFrequency = blackKeyList1[i]; }
                    if (currentPitchList == LIST_C3_E4) { currentFrequency = blackKeyList2[i]; }
                    if (currentPitchList == LIST_C4_E5) { currentFrequency = blackKeyList3[i]; }
                    if (currentPitchList == LIST_C5_E6) { currentFrequency = blackKeyList4[i]; }     
                }
            }

//----------CLICK ON WHITE PIANO KEYS --------------------------------------
            for (int i = 0; i < 11; i++) {
                if (mouseX > whiteKeyMousePressedX1(i) && mouseX <= whiteKeyMousePressedX2(i)
                && mouseY > whiteBoxMousePressedPosY && mouseY <=  whiteKeyPosY2) {
                    if (currentPitchList == LIST_C2_E3) { currentFrequency = whiteKeyList1[i]; }
                    if (currentPitchList == LIST_C3_E4) { currentFrequency = whiteKeyList2[i]; }
                    if (currentPitchList == LIST_C4_E5) { currentFrequency = whiteKeyList3[i]; }
                    if (currentPitchList == LIST_C5_E6) { currentFrequency = whiteKeyList4[i]; }                    
                }
            }
           
            println(currentFrequency);
            currentNote = communication.noteOn((int) currentFrequency, 2);
        } 
        // HAVE TO CHECK IF THIS IS THE CORRECT WAY OF SETTING NOTEOFF! <- TOMORROW 
        else {
            communication.noteOff(currentNote, 0);
            }

//------ ADSR controllers -----------------------------------------------------
        for (int i = 0; i < 4; i++) {
            if (dist(mouseX, mouseY, adsrControllersValue(i), circlePosY) < circleRadius) {
                currentADSRParameter = adsrParameterList[i];
                //changeADSRcontroller(currentADSRParameter);

                //Alt 1: Include the motion-change here.....
                // Write a function that is being activated when mouse is pressed in the 
                // Specific area

                //communication.changeControl(i, );
                println("currentADSRpara: " + currentADSRParameter);
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
            println(currentPitchList);
        }

        if (mouseX > 350 && mouseX <= 535 && mouseY > 80 && mouseY <= 80 + 160) {
            increasePitchListsValue();
            println(currentPitchList);
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
        if (currentOscillatorType > NOISE_OSC) { currentOscillatorType = 0; }
        println("decrese:" + currentPitchList);
        return currentOscillatorType++;
    }

    void changeOscillatorType() {
        switch (currentOscillatorType) {
            case SINE_OSC: communication.changeControl(1, 1, 0);
                    println("Current Wavetype:  SINE");
                    break;
            case SQR_OSC: communication.changeControl(1, 2, 0);
                    println("Current Wavetype:  SQR");
                    break;
            case SAW_OSC: communication.changeControl(1, 3, 0);
                    println("Current Wavetype:  SAW");
                    break;
            case TRI_OSC: communication.changeControl(1, 4, 0);
                    println("Current Wavetype:  TRI");
                    break;
            case NOISE_OSC: communication.changeControl(1, 5, 0);
                    println("Current Wavetype:  NOISE");
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

    void changeADSRcontroller(byte adsrControllToChange) {
        
        println(accelerometerY);    // <- TRY TO IMPLEMENT THIS SHITT! 
        //communication.changeControl(adsrControllToChange, )
    }

    // method in the making <- testing arc function on mouseDragged
    float adsrArcController() {

        if(mouseDragged) {
            attackParameter += 0.01;        
        }
        return attackParameter;
    }
    // test split on 2 and multiplied by 999.99 will give the amount of adsr duration 
    
}
