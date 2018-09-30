import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.server.handler.ContextHandler;
import org.eclipse.jetty.websocket.server.WebSocketHandler;
import org.eclipse.jetty.websocket.servlet.WebSocketServletFactory;
import org.eclipse.jetty.websocket.servlet.WebSocketCreator;
import org.eclipse.jetty.websocket.servlet.ServletUpgradeRequest;
import org.eclipse.jetty.websocket.servlet.ServletUpgradeResponse;
import org.eclipse.jetty.websocket.api.Session;
import org.eclipse.jetty.websocket.api.annotations.OnWebSocketClose;
import org.eclipse.jetty.websocket.api.annotations.OnWebSocketConnect;
import org.eclipse.jetty.websocket.api.annotations.OnWebSocketError;
import org.eclipse.jetty.websocket.api.annotations.OnWebSocketMessage;
import org.eclipse.jetty.websocket.api.annotations.WebSocket;

interface CommunicationListener {
  InstrumentListener instrumentJoined(String id);
  void instrumentRemoved(String id);
}

interface InstrumentListener {
  public void noteOn(String id, int frequencyKey, int velocityKey);
  public void noteOff(String id, int velocityKey);
  public void changePitch(String id, int frequencyKey);
  public void control(String command, int parameter1, int parameter2);
}

@WebSocket
class Communication {
  @WebSocket
  public class WebSocketClientHandler {
    Session session;
    Communication communication;
    InstrumentListener listener;
    String id;

    public WebSocketClientHandler(Communication c) {
      communication = c;
    }

    @OnWebSocketMessage
    public void handleMessage(String msg) {
      // 2 dev_id, 1 command, 2 note_id, 4 parameter, (4 parameter2)
      if (msg.length() != 13 && msg.length() != 9) {
        println("Invalid package received, skipping (" + msg + ")");
        return;
      }

      String deviceId = msg.substring(0, 2);
      char command = msg.charAt(2);
      String noteId = msg.substring(3, 5);
      int parameter = Integer.valueOf(msg.substring(5, 9));
      int parameter2 = 0;
      if (msg.length() > 9) {
	  parameter2 = Integer.valueOf(msg.substring(9, 13));
      }

      switch (command) {
	case 'n':
	  listener.noteOn(noteId, parameter, parameter2);
	  break;
    case 'c':
      listener.control(noteId, parameter, parameter2);
      break;
	case 'p':
	  listener.changePitch(noteId, parameter);
	  break;
	case 'f':
	  listener.noteOff(noteId, parameter);
	  break;
      }
    }

    @OnWebSocketError
    public void handleError(Throwable error) {
      print("----- Websocket client error ------");
      error.printStackTrace();
    }

    @OnWebSocketClose
    public void handleClose(int statusCode, String reason) {
      communication.requestRemoveInstrumentListener(id);
    }

    @OnWebSocketConnect
    public void handleConnect(Session session) {
      id = session.getRemoteAddress().toString();
      this.session = session;
      listener = communication.requestInstrumentListener(id);
    }

    public void sendMessage(String message) {
      session.getRemote().sendStringByFuture(message);
    }
  }

  CommunicationListener listener;
  HashMap<String,InstrumentListener> instrumentListeners;

  Communication(PApplet applet) {
    Server server = new Server(8037);

    WebSocketHandler wsHandler = new WebSocketHandler() {
      @Override public void configure(WebSocketServletFactory factory){
	factory.setCreator(new WebSocketCreator() {
	  @Override public Object createWebSocket(ServletUpgradeRequest request, ServletUpgradeResponse response) {
	    return new WebSocketClientHandler(Communication.this);
	  }
	});
      }
    };

    ContextHandler contextHandler = new ContextHandler("/museIX");
    contextHandler.setAllowNullPathInfo(true);
    contextHandler.setHandler(wsHandler);

    server.setHandler(contextHandler);

    try {
      server.start();
    } catch (Exception e) {
      e.printStackTrace();
    }

    instrumentListeners = new HashMap<String,InstrumentListener>();
  }

  void setListener(CommunicationListener listener) {
    this.listener = listener;
  }

  InstrumentListener requestInstrumentListener(String deviceId) {
    return listener.instrumentJoined(deviceId);
  }

  void requestRemoveInstrumentListener(String deviceId) {
    listener.instrumentRemoved(deviceId);
  }
}

Communication communication = new Communication(this);
