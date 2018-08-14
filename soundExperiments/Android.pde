import websockets.*;

class Android extends App {
    WebsocketClient wsc;

    Android(PApplet applet) {
	super();

	wsc = new WebsocketClient(applet, "ws://10.42.0.1:8025/museix");
    }

    void draw() {
    }

    void send(String msg) {
	wsc.sendMessage(msg);
    }
}
