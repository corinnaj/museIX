import java.util.concurrent.CountDownLatch;
import java.net.URI;
import org.eclipse.jetty.websocket.client.ClientUpgradeRequest;
import org.eclipse.jetty.websocket.client.WebSocketClient;
import org.eclipse.jetty.websocket.api.Session;
import org.eclipse.jetty.websocket.api.annotations.OnWebSocketConnect;
import org.eclipse.jetty.websocket.api.annotations.OnWebSocketError;
import org.eclipse.jetty.websocket.api.annotations.OnWebSocketMessage;
import org.eclipse.jetty.websocket.api.annotations.WebSocket;

interface CommunicationListener {
  void onMessage(String message);
  void onError(String message);
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
    final String url = "ws://192.168.43.79:8037/museIX";
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

  void join() {
    sendMessage('j', 0, 0);
  }

  int noteOn(int frequency, int velocity) {
    int noteId = nextNoteId;
    sendMessage('n', noteId, frequency, velocity);
    nextNoteId = (nextNoteId + 1) % 100;
    return noteId;
  }

  void noteOff(int note, int velocity) {
    sendMessage('f', note, velocity);
  }

  void changePitch(int note, int change) {
    sendMessage('p', note, change);
  }

  void changeControl(int command, int parameter1, int parameter2) {
    sendMessage('c', command, parameter1, parameter2);
  }

  String getId() {
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
