import websockets.*;
import processing.sound.*;

SinOsc[] sineWaves; // Array of sines
float[] sineFreq; // Array of frequencies
int numSines = 5; // Number of oscillators to use

WebsocketServer ws;
void setup() {
  ws = new WebsocketServer(this,8025,"/john");
  
  size(1000, 1000);
  
  sineWaves = new SinOsc[numSines]; // Initialize the oscillators
  sineFreq = new float[numSines]; // Initialize array for Frequencies

  for (int i = 0; i < numSines; i++) {
    // Calculate the amplitude for each oscillator
    float sineVolume = (1.0 / numSines) / (i + 1);
    // Create the oscillators
    sineWaves[i] = new SinOsc(this);
    // Start Oscillators
    sineWaves[i].play();
    // Set the amplitudes for all oscillators
    sineWaves[i].amp(sineVolume);
  }
}

float sx;
float sy;

void webSocketServerEvent(String msg){
  int firstIndex = msg.indexOf(",");
  float x = Float.valueOf(msg.substring(0, firstIndex));
  
  int secondIndex = msg.indexOf(",", firstIndex + 1);
  float y = Float.valueOf(msg.substring(firstIndex + 1, secondIndex));
  
  float z = Float.valueOf(msg.substring(secondIndex + 1));
  sx = x;
  sy = y;
  
  float yoffset = map(x, 0, 3, 0, 1);
  //Map mouseY logarithmically to 150 - 1150 to create a base frequency range
  float frequency = pow(1000, yoffset) + 150;
  //Use mouseX mapped from -0.5 to 0.5 as a detune argument
  float detune = map(mouseX, 0, width, -0.5, 0.5);

  for (int i = 0; i < numSines; i++) { 
    sineFreq[i] = frequency * (i + 1 * detune);
    // Set the frequencies for all oscillators
    sineWaves[i].freq(sineFreq[i]);
  }
}

void draw() {
  rect(sx * 100, sy * 100, 100, 100);
}

