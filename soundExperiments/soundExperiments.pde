import beads.*;

App app;

abstract class App {
	static final int LONG_PRESS_DURATION_MS = 300;

	protected WorldMorph world;

	int longPressTimeStart = 0;
	PVector lastMousePress = new PVector();

	App() {
		world = instantiateWorld();
	}

	void draw() {
		if (longPressTimeStart != 0 && millis() - longPressTimeStart > LONG_PRESS_DURATION_MS) {
			world.startBubbleEvent(new MorphMouseEvent(mouseX, mouseY, MouseEventType.LONG_PRESSED), mouseX, mouseY);
		}

		world.fullDraw();
	}

	void mousePressed() {
		world.startBubbleEvent(new MorphMouseEvent(mouseX, mouseY, MouseEventType.PRESSED), mouseX, mouseY);
		lastMousePress.set(mouseX, mouseY);
		longPressTimeStart = millis();
	}

	void mouseMoved() {
		longPressTimeStart = 0;
		world.startBubbleEvent(new MorphMouseEvent(mouseX, mouseY, MouseEventType.MOVED), mouseX, mouseY);
	}

	void mouseReleased() {
		world.startBubbleEvent(new MorphMouseEvent(mouseX, mouseY, MouseEventType.RELEASED), mouseX, mouseY);
	}

	void mouseWheel(int delta) {
		world.startBubbleEvent(new MorphMouseEvent(mouseX, mouseY,
					delta < 0 ? MouseEventType.WHEEL_UP : MouseEventType.WHEEL_DOWN), mouseX, mouseY);
	}

	void onRemoteMessage(String string) {
	}

	WorldMorph instantiateWorld() {
		return new WorldMorph(new Style());
	}
}

void setup() {
	size(1600, 1000);

	app = new Desktop(this);
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

void mouseWheel(MouseEvent event) {
	app.mouseWheel(event.getCount());
}
