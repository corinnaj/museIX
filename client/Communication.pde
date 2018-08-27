import websockets.*;

class Communication {
  String id;
  WebsocketClient wsc;
  int nextNoteId = 0;

  Communication(PApplet applet) {
    // wsc = new WebsocketClient(applet, "ws://10.42.0.1:8025/museIX");
    wsc = new WebsocketClient(applet, "ws://127.0.0.1:8025/museIX");

    // FIXME not a desirable way to set an id
    id = String.format("%02d", (int) random(0, 99));
  }

  int noteOn(int frequency, int velocity) {
    int noteId = nextNoteId;
    sendMessage('n', noteId, frequency, velocity);
    nextNoteId = nextNoteId + 1 % 100;
    return noteId;
  }
  void noteOff(int note, int velocity) {
    sendMessage('f', note, velocity);
  }
  void changePitch(int note, int change) {
    sendMessage('p', note, change);
  }
  String getId() {
    return id;
  }

  private void sendMessage(char command, int noteId, int parameter, int parameter2) {
    String msg = String.format("%s%c%02d%04d%04d", id, command, noteId, parameter, parameter2);
    assert(msg.length() == 13);
    wsc.sendMessage(msg);
  }
  private void sendMessage(char command, int noteId, int parameter) {
    String msg = String.format("%s%c%02d%04d", id, command, noteId, parameter);
    assert(msg.length() == 9);
    wsc.sendMessage(msg);
  }
}

Communication communication = new Communication(this);

/* for later, two-way-communication
void websocketEvent(String msg) {
  if (msg.charAt(0) == 'j') {
    id = msg.substring(1, 2);
  } else {
    println("Unknown message from server");
  }
}*/
