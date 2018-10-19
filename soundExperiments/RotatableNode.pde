
class RotationIndicatorShape extends CircleShape {
	final Style ICON_STYLE = new Style().hasStroke(false).fillColor(Theme.ICON_COLOR);

	final float WIDTH = 10;

	float min;
	float max;

	float value;
	boolean active = false;

	PShape icon;
	boolean logMode;

	RotationIndicatorShape(PShape icon, boolean logMode, float min, float max, float value) {
		super(60);
		this.icon = icon;
		icon.disableStyle();
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

	color brighten(color col) {
		colorMode(HSB);
		color newCol = color(hue(col), saturation(col), brightness(col) + 40);
		colorMode(RGB);
		return newCol;
	}

	@Override void draw(Style style) {
		color originalColor = 0;
		if (active) {
			originalColor = style.fillColor();
			style.fillColor(brighten(style.fillColor()));
		}
		super.draw(style);
		if (active) {
			style.fillColor(originalColor);
		}

		float width = (WIDTH + radius) * 2;
		arc(0, 0, width, width, 0, map(value, min, max, 0, 2 * PI));

		ICON_STYLE.apply();
		shape(icon, -radius, -radius);
	}
}

abstract class RotatableNode extends AudioNode {
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
		this(ac, logMode, current, min, max, incrementFactor, icon, style, new Glide(ac, current));
	}

	public RotatableNode(AudioContext ac, boolean logMode, float current, float min, float max, float incrementFactor, String icon, Style style, Glide glide) {
		super(ac, new RotationIndicatorShape(loadShape("icons/" + icon + ".svg"), logMode, min, max, current), style);
		this.glide = glide;
		this.logMode = logMode;
		this.incrementFactor = incrementFactor;
	}

	Glide getGlide() {
		return glide;
	}

	@Override
	void mouseLongPress(MorphMouseEvent event) {
		super.mouseLongPress(event);

		cancelMoving();
		active = true;
		((RotationIndicatorShape) shape).active = true;
		grabMouseFocus();
		lastMousePos.set(event.x, event.y);
	}

	@Override
	void mouseMove(MorphMouseEvent event) {
		super.mouseMove(event);

		if (!active)
			return;

		RotationIndicatorShape indicator = (RotationIndicatorShape) shape;

		indicator.setValue(indicator.getValue() + (event.y - lastMousePos.y) * incrementFactor);
		glide.setValue(logMode ? exp(indicator.getValue()) : indicator.getValue());
		lastMousePos.set(event.x, event.y);
	}

	@Override
	void mouseRelease(MorphMouseEvent event) {
		super.mouseRelease(event);

		active = false;
		((RotationIndicatorShape) shape).active = false;
		releaseMouseFocus();
	}
}
