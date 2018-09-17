
enum MouseEventType {
	RELEASED,
	PRESSED,
	LONG_PRESSED,
	MOVED
}

class MouseEvent {
	int x;
	int y;
	MouseEventType type;

	MouseEvent(int x, int y, MouseEventType type) {
		this.x = x;
		this.y = y;
		this.type = type;
	}
}

abstract class Shape {
	abstract void translateToCenterOfRotation(float scale);
	abstract boolean containsPoint(float x, float y);
	abstract void draw(Style style);
	/**
	 * Return topLeft.x,topLeft.y,bottomRight.x,bottomRight.y
	 */
	abstract float[] calculateBoundingBox(float x, float y);
}

class SVGShape extends RectangleShape {
	PShape shape;

	SVGShape(PShape shape) {
		super(shape.width, shape.height);
		this.shape = shape;
	}

	@Override
	void draw(Style style) {
		shape(shape);
	}
}

class CircleShape extends Shape {
	float radius;

	CircleShape(float radius) {
		this.radius = radius;
	}

	@Override
	void draw(Style style) {
		style.apply();
		ellipse(0, 0, radius * 2, radius * 2);
	}

	@Override
	boolean containsPoint(float x, float y) {
		return Math.sqrt(x * x + y * y) < radius;
	}

	@Override
	void translateToCenterOfRotation(float scale) {
		translate(radius * scale, radius * scale);
	}

	@Override
	float[] calculateBoundingBox(float x, float y) {
		return new float[] {x - radius, y - radius, x + radius, y + radius};
	}
}

class TextShape extends Shape {
	String contents;
	float width;
	float height;

	TextShape(String contents) {
		this.contents = contents;
		updateExtents();
	}

	void updateExtents() {
		width = textWidth(contents);
		height = textAscent() + textDescent();
	}

	@Override
	void draw(Style style) {
		style.apply();
		textSize(22);
		text(contents, 0, height);
	}

	@Override
	boolean containsPoint(float x, float y) {
		return x >= 0 && y >= 0 && x <= width && y <= height;
	}

	@Override
	void translateToCenterOfRotation(float scale) {
		translate(width * scale * 0.5f, height * scale * 0.5f);
	}

	@Override
	float[] calculateBoundingBox(float x, float y) {
		return new float[] {0, 0, width, height};
	}
}

class LineShape extends Shape {
	PVector from;
	PVector to;

	LineShape(PVector from, PVector to) {
		this.from = from;
		this.to = to;
	}

	@Override
	boolean containsPoint(float x, float y) {
		return false;
	}

	@Override
	void translateToCenterOfRotation(float scale) {
		// FIXME
	}

	@Override
	void draw(Style style) {
		style.apply();
		line(from.x, from.y, to.x, to.y);
	}

	@Override
	float[] calculateBoundingBox(float x, float y) {
		// TODO swap coordinates if necessary to make sure topLeft/bottomRight is correct
		return new float[] {x + from.x, y + from.y, x + to.x, y + to.y};
	}
}

class RectangleShape extends Shape {
	float width;
	float height;

	RectangleShape(float width, float height) {
		this.width = width;
		this.height = height;
	}

	void translateToCenterOfRotation(float scale) {
		translate(width * scale * 0.5f, height * scale * 0.5f);
	}

	boolean containsPoint(float x, float y) {
		return x >= 0 && y >= 0 && x <= width && y <= height;
	}

	void draw(Style style) {
		style.apply();
		rect(0, 0, width, height);
	}

	@Override
	float[] calculateBoundingBox(float x, float y) {
		return new float[] {x, y, x + width, y + height};
	}

	void setSize(float width, float height) {
		this.width = width;
		this.height = height;
	}
}

class WorldShape extends Shape {
	@Override
	void translateToCenterOfRotation(float scale) {}
	@Override
	boolean containsPoint(float x, float y) { return true; }
	@Override
	void draw(Style style) {
		background(style.fillColor());
	}
	@Override
	float[] calculateBoundingBox(float x, float y) {
		// FIXME not sure about this
		return new float[]{0, 0, width, height};
	}
}

/*class ContainerShape extends Shape {
	@Override
}*/

class Style {
	private boolean _hasFill = true;
	private color _fillColor = #ffffff;

	private boolean _hasStroke = true;
	private color _strokeColor = #000000;
	private float _strokeWeight = 4.0f;

	void apply() {
		if (!_hasFill) {
			noFill();
		} else {
			fill(_fillColor);
		}
		if (!_hasStroke) {
			noStroke();
		} else {
			stroke(_strokeColor);
			strokeWeight(_strokeWeight);
		}
	}

	Style hasFill(boolean b) { _hasFill = b; return this; }
	Style hasStroke(boolean b) { _hasStroke = b; return this; }
	Style fillColor(color c) { _fillColor = c; return this; }
	color fillColor() { return _fillColor; }
	Style strokeColor(color c) { _strokeColor = c; return this; }
	Style strokeWeight(float f) { _strokeWeight = f; return this; }
}

class Morph {
	Shape shape;

	PVector position = new PVector(0, 0);
	float angle = 0;
	Style style;

	Morph owner;
	ArrayList<Morph> submorphs = new ArrayList<Morph>();

	Morph(Shape shape, Style style) {
		this.shape = shape;
		this.style = style;
	}

	boolean containsPoint(float x, float y) {
		return shape.containsPoint(x - position.x, y - position.y);
	}

	void fullDraw() {
		pushMatrix();
		draw();
		for (Morph m : new ArrayList<Morph>(submorphs)) {
			m.fullDraw();
		}
		popMatrix();
	}

	void draw() {
		translate(position.x, position.y);
		if (angle != 0) {
			shape.translateToCenterOfRotation(1);
			rotate(angle);
			shape.translateToCenterOfRotation(-1);
		}

		shape.draw(style);
	}

	boolean bubbleEvent(MouseEvent event, float x, float y) {
		if (containsPoint(x, y)) {
			for (int i = submorphs.size() - 1; i >= 0; i--) {
				Morph m = submorphs.get(i);
				if (m.bubbleEvent(event, x - position.x, y - position.y)) {
					return true;
				}
			}

			if (handlesEvent(event)) {
				takeEvent(event);
				return true;
			}
		}

		return false;
	}

	void takeEvent(MouseEvent event) {
		switch (event.type) {
			case PRESSED:
				mousePress(event);
				break;
			case LONG_PRESSED:
				mouseLongPress(event);
				break;
			case RELEASED:
				mouseRelease(event);
				break;
			case MOVED:
				mouseMove(event);
				break;
		}
	}

	void mouseLongPress(MouseEvent event) {
	}

	void mousePress(MouseEvent event) {
	}

	void mouseMove(MouseEvent event) {
	}

	void mouseRelease(MouseEvent event) {
	}

	boolean handlesEvent(MouseEvent event) {
		return true;
	}

	// PUBLIC API
	WorldMorph getWorld() {
		return owner.getWorld();
	}

	Morph addMorph(Morph morph) {
		morph.owner = this;
		submorphs.add(morph);
		return this;
	}

	Morph removeMorph(Morph morph) {
		submorphs.remove(morph);
		morph.owner = null;
		return this;
	}

	Morph removeAllMorphs() {
		for (Morph m : submorphs) {
			m.owner = null;
		}
		submorphs.clear();
		return this;
	}

	Morph delete() {
		if (owner != null) {
			owner.removeMorph(this);
		}
		return this;
	}

	Morph setPosition(float x, float y) {
		position.set(x, y);
		return this;
	}

	Morph setPosition(PVector v) {
		position.set(v);
		return this;
	}

	void grabMouseFocus() {
		getWorld().setMouseFocusMorph(this);
	}

	void releaseMouseFocus() {
		if (getWorld().getMouseFocusMorph() == this) {
			getWorld().setMouseFocusMorph(null);
		}
	}

	Morph addTo(Morph other) {
		other.addMorph(this);
		return this;
	}

	PVector center() {
		float[] bbox = shape.calculateBoundingBox(position.x, position.y);
		return new PVector(
				bbox[0] + (bbox[2] - bbox[0]) / 2,
				bbox[1] + (bbox[3] - bbox[1]) / 2);
	}

	PVector centerTop() {
		float[] bbox = shape.calculateBoundingBox(position.x, position.y);
		return new PVector(bbox[0] + (bbox[2] - bbox[0]) / 2, bbox[1]);
	}

	PVector centerBottom() {
		float[] bbox = shape.calculateBoundingBox(position.x, position.y);
		return new PVector(bbox[0] + (bbox[2] - bbox[0]) / 2, bbox[2]);
	}

	Morph resizeToSubmorphs() {
		float x = position.x, y = position.y;
		float width = 0, height = 0;

		for (Morph m : submorphs) {
			float[] bbox = m.shape.calculateBoundingBox(position.x, position.y);

			if (bbox[0] < x) x = bbox[0];
			if (bbox[1] < y) y = bbox[1];
			if (bbox[2] > x + width) width = bbox[2] - x;
			if (bbox[3] > y + height) height = bbox[2] - y;
		}

		position.sub(x, y);

		return this;
	}
}

class WorldMorph extends Morph {
	private Morph mouseFocusMorph = null;

	WorldMorph(Style style) {
		super(new WorldShape(), style);
	}

	WorldMorph getWorld() {
		return this;
	}

	Morph getMouseFocusMorph() {
		return mouseFocusMorph;
	}

	void setMouseFocusMorph(Morph morph) {
		mouseFocusMorph = morph;
	}

	void startBubbleEvent(MouseEvent event, float x, float y) {
		if (mouseFocusMorph == null)
			bubbleEvent(event, x, y);
		else
			// TODO apply transforms
			mouseFocusMorph.takeEvent(event);
	}
}

interface ButtonMorphListener {
	void buttonPressed();
}

class ButtonMorph extends Morph {
	ButtonMorphListener listener;

	ButtonMorph(Shape shape, Style style, ButtonMorphListener listener) {
		super(shape, style);
		this.listener = listener;
	}

	@Override void mousePress(MouseEvent event) {
		listener.buttonPressed();
	}
}
