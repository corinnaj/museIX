import websockets.*;

interface CommunicationListener {
  InstrumentListener instrumentJoined(String id);
}

interface InstrumentListener {
  public void noteOn(String id, int frequencyKey, int velocityKey);
  public void noteOff(String id, int velocityKey);
  public void changePitch(String id, int frequencyKey);
}

class Communication {
  WebsocketServer ws;
  CommunicationListener listener;
  HashMap<String,InstrumentListener> instrumentListeners;

  Communication(PApplet applet) {
    ws = new WebsocketServer(applet, 8037, "/museIX");
    instrumentListeners = new HashMap<String,InstrumentListener>();
  }

  void setListener(CommunicationListener listener) {
    this.listener = listener;
  }

  void registerInstrumentListener(String id, InstrumentListener listener) {
    instrumentListeners.put(id, listener);
  }

  void messageReceived(String msg) {
    // 2 dev_id, 1 command, 2 note_id, 4 parameter, (4 parameter2)
    assert(msg.length() == 13 || msg.length() == 9);

    String deviceId = msg.substring(0, 1);
    char command = msg.charAt(2);
    String noteId = msg.substring(3, 4);
    int parameter = Integer.valueOf(msg.substring(5, 9));
    int parameter2 = 0;
    if (msg.length() > 9) {
      parameter2 = Integer.valueOf(msg.substring(10, 13));
    }

    InstrumentListener instrumentListener = instrumentListeners.get(deviceId);

    switch (command) {
      case 'j':
	if (listener != null) {
	  instrumentListeners.put(deviceId, listener.instrumentJoined(deviceId));
	}
	break;
      case 'n':
	if (instrumentListener != null) instrumentListener.noteOn(noteId, parameter, parameter2);
	break;
      case 'p':
	if (instrumentListener != null) instrumentListener.changePitch(noteId, parameter);
	break;
      case 'f':
	if (instrumentListener != null) instrumentListener.noteOff(noteId, parameter);
	break;
    }
  }
}

Communication communication = new Communication(this);

void webSocketServerEvent(String msg){
  println(msg);
  communication.messageReceived(msg);
}

