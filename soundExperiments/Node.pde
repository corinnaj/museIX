
/**
 * NB should be used within the same parent as it does not consider scenegraph transforms
 */
class Node extends Morph {

	ArrayList<Node> connected = new ArrayList<Node>();
	boolean dragging = false;
	PVector lastPosition = new PVector();
	Style lineStyle;

	Node(Shape shape, Style style, Style lineStyle) {
		super(shape, style);
		this.lineStyle = lineStyle;
	}

	void connectTo(Node node) {
		connected.add(node);
	}

	@Override
	void fullDraw() {
		lineStyle.apply();
		PVector myCenter = center();
		for (Node other : connected) {
			PVector otherCenter = other.center();
			line(myCenter.x, myCenter.y, otherCenter.x, otherCenter.y);
		}

		super.fullDraw();
	}

	@Override
	void mousePress(MouseEvent event) {
		dragging = true;
		lastPosition.set(event.x, event.y);
	}

	@Override
	void mouseMove(MouseEvent event) {
		if (dragging) {
			position.add(event.x - lastPosition.x, event.y - lastPosition.y);
			lastPosition.set(event.x, event.y);
			grabMouseFocus();
		}
	}

	@Override
	void mouseRelease(MouseEvent event) {
		cancelMoving();
	}

	void cancelMoving() {
		dragging = false;
		releaseMouseFocus();
	}
}

abstract class AudioNode extends Node {
	AudioNode(Shape shape, Style style) {
		super(shape, style, new Style());
	}

	abstract UGen getOutput();

	AudioNode addInput(AudioNode node) {
		node.connectTo(this);
		return this;
	}
}

