
class RotationIndicatorShape extends CircleShape {
	final float WIDTH = 10;

	float min;
	float max;

	float value;

	PShape icon;
	boolean logMode;

	RotationIndicatorShape(PShape icon, boolean logMode, float min, float max, float value) {
		super(60);
		this.icon = icon;
		this.logMode = logMode;
		if (logMode) {
			this.min = log(min);
			this.max = log(max);
			this.value = log(value);
		} else {
			this.min = min;
			this.max = max;
			this.value = value;
		}
	}

	void setValue(float f) {
		value = constrain(f, min, max);
	}

	float getValue() {
		return value;
	}

	@Override
	void draw(Style style) {
		super.draw(style);

		float width = (WIDTH + radius) * 2;
		arc(0, 0, width, width, 0, map(value, min, max, 0, 2 * PI));

		shape(icon, -radius, -radius);
	}
}

abstract class RotatableNode extends AudioNode {
	final Style ICON_STYLE = new Style().hasStroke(false).fillColor(#000000);

	Glide glide;

	boolean active = false;
	boolean logMode;
	PVector lastMousePos = new PVector();
	float incrementFactor;

	// for frequencies
	public RotatableNode(AudioContext ac, float current, String icon, Style style) {
		this(ac, true, current, 20, 8000, 0.01, icon, style);
	}

	public RotatableNode(AudioContext ac, boolean logMode, float current, float min, float max, float incrementFactor, String icon, Style style) {
		super(new RotationIndicatorShape(loadShape("icons/" + icon + ".svg"), logMode, min, max, current), style);
		this.glide = new Glide(ac, current);
		this.logMode = logMode;
		this.incrementFactor = incrementFactor;
	}

	Glide getGlide() {
		return glide;
	}

	@Override
	void mouseLongPress(MouseEvent event) {
		super.mouseLongPress(event);

		cancelMoving();
		active = true;
		grabMouseFocus();
		lastMousePos.set(event.x, event.y);
	}

	@Override
	void mouseMove(MouseEvent event) {
		super.mouseMove(event);

		if (!active)
			return;

		RotationIndicatorShape indicator = (RotationIndicatorShape) shape;

		indicator.setValue(indicator.getValue() + (event.y - lastMousePos.y) * incrementFactor);
		glide.setValue(logMode ? exp(indicator.getValue()) : indicator.getValue());
		lastMousePos.set(event.x, event.y);
	}

	@Override
	void mouseRelease(MouseEvent event) {
		super.mouseRelease(event);

		active = false;
		releaseMouseFocus();
	}
}
