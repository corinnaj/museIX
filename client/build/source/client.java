import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ketai.sensors.*; 
import java.util.concurrent.CountDownLatch; 
import java.net.URI; 
import org.eclipse.jetty.websocket.client.ClientUpgradeRequest; 
import org.eclipse.jetty.websocket.client.WebSocketClient; 
import org.eclipse.jetty.websocket.api.Session; 
import org.eclipse.jetty.websocket.api.annotations.OnWebSocketConnect; 
import org.eclipse.jetty.websocket.api.annotations.OnWebSocketError; 
import org.eclipse.jetty.websocket.api.annotations.OnWebSocketMessage; 
import org.eclipse.jetty.websocket.api.annotations.WebSocket; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class client extends PApplet {



float currentBaseFrequencyKey = 0;
int currentNote = -1;
String message;

Instrument instrument;
HashMap<String, Instrument> instruments = new HashMap<String, Instrument>();

Communication communication = new Communication(new CommunicationListener() {
    public void onMessage(String m) {}
    public void onError(String e) {
      message = e;
    }
});

public void setup() {
  sensor = new KetaiSensor(this);
  orientation(PORTRAIT);
  textAlign(CENTER, CENTER);
  textSize(36);

  instruments.put("violin", new Violin());
  instruments.put("guitar", new Guitar());
  instruments.put("synth", new Synth());

  instrument = new NoInstrument();
  sensor.start();
}

KetaiSensor sensor;
float accelerometerX, accelerometerY, accelerometerZ;

public void draw() {
  if (accelerometerX < 1 && accelerometerX > -1.5f &&
      accelerometerY < 2 && accelerometerY > -0.5f &&
      accelerometerZ > 9 && accelerometerZ < 10.5f) {
    //instrument = instruments.get("violin");
  //} else {
    //instrument = instruments.get("guitar");
  }
  instrument = instruments.get("synth");
  instrument.display();
}

public void mousePressed() {
  instrument.mousePressed();
}

public void mouseReleased() {
  instrument.mouseReleased();
}

public void mouseDragged() {
  instrument.mouseDragged();
}

public void onAccelerometerEvent(float x, float y, float z)
{
  accelerometerX = x;
  accelerometerY = y;
  accelerometerZ = z;
}










interface CommunicationListener {
  public void onMessage(String message);
  public void onError(String message);
}

@WebSocket
public class Communication {
  String id;
  int nextNoteId = 0;

  Session session;
  CommunicationListener listener;
  CountDownLatch latch = new CountDownLatch(1);

  Communication(CommunicationListener listener) {
    this.listener = listener;

		WebSocketClient client = new WebSocketClient();
    try {
      client.start();
    } catch (Exception e) {
      println("Failed to start client");
      e.printStackTrace();
    }

    // final String url = "ws://127.0.0.1:8037/museIX";
    final String url = "ws://192.168.43.184:8037/museIX";
    ClientUpgradeRequest request = new ClientUpgradeRequest();
    try {
      client.connect(this, new URI(url), request);
      // client.connect(socket, new URI(url), request);
    } catch (Exception e) {
      println("Failed to connect to host " + url + " (" + e.toString() + ")");
    }
    try {
      latch.await();
    } catch (Exception e) {
      e.printStackTrace();
    }

    // FIXME not a desirable way to set an id
    id = String.format("%02d", (int) random(0, 99));
    join();
  }

  @OnWebSocketMessage public void onText(Session session, String message) throws IOException {
    listener.onMessage(message);
  }

	@OnWebSocketConnect public void onConnect(Session session) {
    println("Connection established!");
    this.session = session;
    latch.countDown();
	}

  @OnWebSocketError public void onError(Throwable cause) {
    println("----------- Websocket Error: -----------");
    cause.printStackTrace();
    listener.onError(cause.toString());
  }

  public void join() {
    sendMessage('j', 0, 0);
  }

  public int noteOn(int frequency, int velocity) {
    int noteId = nextNoteId;
    sendMessage('n', noteId, frequency, velocity);
    nextNoteId = (nextNoteId + 1) % 100;
    return noteId;
  }

  public void noteOff(int note, int velocity) {
    sendMessage('f', note, velocity);
  }

  public void changePitch(int note, int change) {
    sendMessage('p', note, change);
  }

  public String getId() {
    return id;
  }

  private void sendMessage(char command, int noteId, int parameter, int parameter2) {
    String msg = String.format("%s%c%02d%04d%04d", id, command, noteId, parameter, parameter2);
    if (msg.length() != 13) {
      println("Invalid length, skpping", msg, id, Integer.toString(noteId), Integer.toString(parameter), Integer.toString(parameter2));
      return;
    }
    assert(msg.length() == 13);
    sendMessage(msg);
  }
  private void sendMessage(char command, int noteId, int parameter) {
    String msg = String.format("%s%c%02d%04d", id, command, noteId, parameter);
    if (msg.length() != 9) {
      println("Invalid length, skpping", msg, id, Integer.toString(noteId), Integer.toString(parameter));
      return;
    }
          
    assert(msg.length() == 9);
    sendMessage(msg);
  }

  private void sendMessage(final String message) {
    final Session s = session;
    Thread thread = new Thread(new Runnable() {
      @Override public void run() {
        try  {
          s.getRemote().sendStringByFuture(message);
        } catch (Exception e) {
          println("Failed to send message!");
          e.printStackTrace();
        }
      }
    });
    thread.start(); 
  }
}

/* for later, two-way-communication
void websocketEvent(String msg) {
  if (msg.charAt(0) == 'j') {
    id = msg.substring(1, 2);
  } else {
    println("Unknown message from server");
  }
}*/
class Guitar extends Instrument {
  public void display() {
    orientation(LANDSCAPE);
    PImage image = loadImage("guitar.jpg");
    image(image, width/2, height/2, width, height);
  }

  public void mousePressed() {
    println(mouseX + "   " + mouseY);
  }
  public void mouseReleased() {
  }
  public void mouseDragged() {
  }
}
abstract class Instrument {
  public abstract void display();
  public abstract void mousePressed();
  public abstract void mouseReleased();
  public abstract void mouseDragged();
}

class NoInstrument extends Instrument {
  public void display() {
    background(78, 93, 75);
    text("Accelerometer: \n" +
        "x: " + nfp(accelerometerX, 1, 3) + "\n" +
        "y: " + nfp(accelerometerY, 1, 3) + "\n" +
        "z: " + nfp(accelerometerZ, 1, 3), 0, 0, width, height);
  }
  public void mousePressed() {}
  public void mouseReleased() {}
  public void mouseDragged() {}
}
class Synth extends Instrument {

    // values used for base for the weekly challenge! 8-)
    //int boxPosY = 25;
    //int boxSideLength = 100;
    float boxPosY = 300;
    float boxSideLength = 182;
    float firstBoxPosX = 25;
    float firstWhiteBoxPosX = 25;
    int whiteKeyLength = 580;
    int colorCode = 50;
    int colorCodeIncrease = 45;
    int keysCounter = 0;
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

    public void startup() {
        orientation(LANDSCAPE);

        //Setup the font
        PFont font = createFont("Arial", 100);
        textFont(font);
        textSize(100);

        //draws the base of the synth / piano
        drawWhitePianoKeys();
        drawBlackPianoKeys();
        //soundSetup();
    }

    // this is the designated draw class
    public void display() {
        startup();
        drawPitchControllers();
        drawWaveController();
        drawADSRControllers();
        drawText();
        // println("Mousex: " + mouseX);
        // println("MouseY: " + mouseY);
        //instantiateSound();
    }

    public void drawPitchControllers() {
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

    public void drawWaveController() {
    stroke(0);
    strokeWeight(2);
    fill(135, 50);
    rect(650, 120, 185, 160);
    }

    public void drawText() {
        int firstLetterPosX = 1170;
        int letterPosY = 195;
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

    public void drawADSRControllers() {
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
    arc(firstCircPosX, circlePosY, circleWidth, circleHeight, 0, PI*test);
    }

    public void drawBlackPianoKeys() {
        float firstBlackBoxPosX = 207 - ((boxSideLength / 1.6f)/2);
        int blackKeyLength = 350;
        int blackPosY = 0;

        while (firstBlackBoxPosX + boxSideLength < width) {
            if (keysCounter == 2 || keysCounter == 6) {
                firstBlackBoxPosX += boxSideLength + 3;
                keysCounter++;
                if (keysCounter > 6) { keysCounter = 0; }

            } else {
                fill(0);
                rect(firstBlackBoxPosX, boxPosY, boxSideLength / 1.6f, blackKeyLength);
                firstBlackBoxPosX += boxSideLength + 3;
                keysCounter++;
            }
        }
        fill(134,44,145);
        rect(firstWhiteBoxPosX, firstBoxPosX + boxSideLength, boxPosY, whiteKeyLength);
    }

    public void drawWhitePianoKeys() {
        float firstWhiteBoxPosX = 25;
        while (firstWhiteBoxPosX + boxSideLength < width) {
            fill(255);
            rect(firstWhiteBoxPosX, boxPosY, boxSideLength, whiteKeyLength);
            firstWhiteBoxPosX += boxSideLength + 3;
        }
    }

    public void mousePressed() {
        // ADSR controllers
        if (dist(mouseX, mouseY, firstCircPosX, circlePosY) < circleRadius) {
        println("Første sirkel aktivert");
        }
        if (dist(mouseX, mouseY, firstCircPosX + spaceBetweenCircles, circlePosY) < circleRadius) {
            println("Andre sirkel aktivert");
        }
        if (dist(mouseX, mouseY, firstCircPosX + spaceBetweenCircles * 2, circlePosY) < circleRadius) {
            println("Tredje sirkel aktivert");
        }
        if (dist(mouseX, mouseY, firstCircPosX + spaceBetweenCircles * 3, circlePosY) < circleRadius) {
            println("Fjerde sirkel aktivert");
        }

        // Click on the WhitePianoKeys
        if (mouseX > firstWhiteBoxPosX && mouseX <= firstBoxPosX + boxSideLength && mouseY > boxPosY && mouseY <= whiteKeyLength) {
            println("Første key er trykket på");
        }

        // Click on BlackPianoKeys

    }

    public void mouseReleased() {}

    public void mouseDragged() {
        mouseDragged = true;
        adsrArcController();
        //println(mouseDragged);
    }

    public float adsrArcController() {
    if(mouseDragged) {
        test += 0.01f;
        if (test >= 2) {
            test = 2;
        }
    }
    //println(test);
    return test;
    }


}
class Violin extends Instrument {
  static final float eFrequency = 659.0f;
  static final float aFrequency = 440.0f;
  static final float dFrequency = 293.7f;
  static final float gFrequency = 196.0f;
  float currentFrequency = 0.0f;
  int initialMouseY = 0;
  
  int prevMouseX = -1;
  int tutStep = -1;
  boolean isInTut = false;

  public void startup() {
    orientation(PORTRAIT);
    imageMode(CENTER);
    rectMode(CORNER);
    textSize(50);
  }

  public void display()  {
    startup();
    PImage img = loadImage("violin.jpg");
    pushMatrix();
    translate(width/2, height/2 + 800);
    scale(4, 4);
    image(img, 0, 0);
    scale(0.25f, 0.25f);
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
  
  public void createLabels() {
    fill(255);
    textSize(100);
    text("G", 1 * width/4, height - 100);
    text("D", 4 * width/10, height - 100);
    text("A", 6 * width/10, height - 100);
    text("E", 26 * width/36, height - 100);
  }
  
  public void createTutorialButton() {
    noStroke();
    fill(125, 125);
    rect(40, 40, 400, 120, 7);
    fill(255);
    textSize(42);
    textAlign(CENTER, CENTER);
    text("Show tutorial", 240, 100);
  }

  public void playTutorial(int step) {
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
  
   public boolean isInTutButton() {
     return mouseX > 40 && mouseX < 440 && mouseY > 40 && mouseY < 160;
   }
   
  public void mousePressed() {
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

  public int getMouseMovementSpeed() {
    int speedX;
    if (prevMouseX > 0) {
      speedX = abs(mouseX - prevMouseX);
    } else {
      speedX = 0;
    }
    prevMouseX = mouseX;
    return speedX;
  }

  public void mouseReleased() {
    communication.noteOff(currentNote, 0);
  }

  public void mouseDragged() {
      int speed = getMouseMovementSpeed();
      if (speed > 0) {
        currentNote = communication.noteOn((int) currentFrequency, speed);
      }
      communication.changePitch(currentNote, initialMouseY - mouseY);
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "client" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
