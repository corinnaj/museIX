import websockets.*;

interface CommunicationListener {
  void instrumentJoined(String id);
}

class Communication {
  WebsocketServer ws;
  CommunicationListener listener;

  Communication(CommunicationListener listener) {
    ws = new WebsocketServer(this, 8025, "/museIX");
    this.listener = listener;
  }

  int mapVelocity(int velocityKey) {
    return (int) map(velocityKey, 0, 999, 10, 1500);
  }

  void playNote(String id, int frequencyKey, int velocityKey) {
    if (notes.containsKey(id))
      return;

    Note note = new Note(map(frequencyKey, 0, 999, Note.MIN_FREQUENCY, Note.MAX_FREQUENCY), mapVelocity(velocityKey));
    notes.put(id, note);
    note.play(ac, ac.out);
  }

  void stopNote(String id, int velocityKey) {
    if (!notes.containsKey(id))
      return;
    Note note = notes.get(id);
    note.stop(ac.out, mapVelocity(velocityKey));
    notes.remove(id);
  }

  void changePitch(String id, int delta) {
    if (!notes.containsKey(id))
      return;
    float change = map(delta, 0, 999, -100, 100);
    Note note = notes.get(id);
    note.changePitch(change);
  }

  void messageReceived(String msg) {
    // 2 dev_id, 1 command, 2 note_id, 4 parameter, (4 parameter2)
    println(msg);
    assert(msg.length() == 13 || msg.length() == 9);

    String deviceId = msg.substring(0, 1);
    char command = msg.charAt(2);
    String noteId = msg.substring(3, 4);
    int parameter = Integer.valueOf(msg.substring(5, 9));
    int parameter2 = 0;
    if (msg.length() > 9) {
      parameter2 = Integer.valueOf(msg.substring(10, 13));
    }

    switch (command) {
      case 'j':
        listener.instrumentJoined(deviceId);
      case 'n':
        playNote(noteId, parameter, parameter2);
        break;
      case 'p':
        changePitch(noteId, parameter);
        break;
      case 'f':
        stopNote(noteId, parameter);
        break;
    }
  }
}

Communication communication = new Communication();

void webSocketServerEvent(String msg){
}

