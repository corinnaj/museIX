import beads.*;

App app;

abstract class App {
	static final int LONG_PRESS_DURATION_MS = 300;

	protected WorldMorph world;

	int longPressTimeStart = 0;
	PVector lastMousePress = new PVector();

	App() {
		Style s = new Style().fillColor(0xff0000);
		world = new WorldMorph(s);
	}

	void draw() {
		if (longPressTimeStart != 0 && millis() - longPressTimeStart > LONG_PRESS_DURATION_MS) {
			world.startBubbleEvent(new MouseEvent(mouseX, mouseY, MouseEventType.LONG_PRESSED), mouseX, mouseY);
		}

		world.fullDraw();
	}

	void mousePressed() {
		world.startBubbleEvent(new MouseEvent(mouseX, mouseY, MouseEventType.PRESSED), mouseX, mouseY);
		lastMousePress.set(mouseX, mouseY);
		longPressTimeStart = millis();
	}

	void mouseMoved() {
		longPressTimeStart = 0;
		world.startBubbleEvent(new MouseEvent(mouseX, mouseY, MouseEventType.MOVED), mouseX, mouseY);
	}

	void mouseReleased() {
		world.startBubbleEvent(new MouseEvent(mouseX, mouseY, MouseEventType.RELEASED), mouseX, mouseY);
	}

	void onRemoteMessage(String string) {
	}
}

void setup() {
	size(800, 800);

	if (platformNames[platform] == "linux") {
		app = new Desktop(this);
	} else {
		app = new Android(this);
	}
}

void draw() {
	app.draw();
}

void mousePressed() {
	app.mousePressed();
}

void mouseMoved() {
	app.mouseMoved();
}

void mouseReleased() {
	app.mouseReleased();
}

void mouseDragged() {
	app.mouseMoved();
}

void webSocketServerEvent(String msg){
	app.onRemoteMessage(msg);
}

void webSocketEvent(String msg){
	app.onRemoteMessage(msg);
}
