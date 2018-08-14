import websockets.*;
import ketai.sensors.*;

WebsocketClient wsc;
int now;

void setup() {
  wsc = new WebsocketClient(this, "ws://10.42.0.1:8025/john");
  now = millis();
  
  sensor = new KetaiSensor(this);
  sensor.start();
  orientation(LANDSCAPE);
  textAlign(CENTER, CENTER);
  textSize(36);
}

KetaiSensor sensor;
float accelerometerX, accelerometerY, accelerometerZ;

void draw()
{
  background(78, 93, 75);
  text("Accelerometer: \n" + 
    "x: " + nfp(accelerometerX, 1, 3) + "\n" +
    "y: " + nfp(accelerometerY, 1, 3) + "\n" +
    "z: " + nfp(accelerometerZ, 1, 3), 0, 0, width, height);


     if (accelerometerX < 1 && accelerometerX > -1.5 &&
         accelerometerY < 2 && accelerometerY > -0.5 &&
         accelerometerZ > 9 && accelerometerZ < 10.5) {
       textSize(50);
       background(#ff0000);
       text("Violin", 0, 0, width, height);
     }
}

void onAccelerometerEvent(float x, float y, float z)
{
  accelerometerX = x;
  accelerometerY = y;
  accelerometerZ = z;

  if (millis() > now + 5){
    wsc.sendMessage(Float.toString(x) + "," + Float.toString(y) + "," + Float.toString(z));
    now = millis();
  }
}
