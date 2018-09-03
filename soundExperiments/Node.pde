
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

	void disconnectFrom(Node node) {
		connected.remove(node);
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
		grabMouseFocus();
	}

	@Override
	void mouseMove(MouseEvent event) {
		if (dragging) {
			position.add(event.x - lastPosition.x, event.y - lastPosition.y);
			lastPosition.set(event.x, event.y);

			for (Node node : ((NodeWorldMorph) owner).nodes) {
				if (node != this &&
						node.acceptsIncomingConnection(this) &&
						this.wantsToConnectTo(node) &&
						!this.isConnectedTo(node) &&
						node.overlapsWith(this)) {
					this.connectTo(node);
				}
			}
		}
	}

	boolean acceptsIncomingConnection(Node node) {
		return true;
	}

	boolean wantsToConnectTo(Node node) {
		return true;
	}

	@Override void mouseRelease(MouseEvent event) {
		cancelMoving();
	}

	@Override Morph delete() {
		cutAllConnections();
		cutAllIncomingConnections();
		return super.delete();
	}

	void cancelMoving() {
		dragging = false;
		releaseMouseFocus();
	}

	void cutAllConnections() {
		for (Node n : new ArrayList<Node>(connected)) {
			disconnectFrom(n);
		}
	}

	void cutAllIncomingConnections() {
		for (Node node : ((NodeWorldMorph) owner).nodes) {
			if (node.isConnectedTo(this)) {
				node.disconnectFrom(this);
			}
		}
	}

	boolean isConnectedTo(Node node) {
		return connected.contains(node);
	}

	// FIXME we assume to always have circles here
	static final float RADIUS = 64;
	boolean overlapsWith(Node node) {
		return (position.x - node.position.x) * (position.x - node.position.x) +
			(position.y - node.position.y) * (position.y - node.position.y) <= (RADIUS * 2) * (RADIUS * 2);
	}
}

enum AudioNodeOutputType {
	FREQUENCIES,
	NOTES,
	WAVES
}

class WaveAudioNodeCircleShape extends CircleShape {
	static final float MAX_GROW_RADIUS = 60;
	static final float BASE_RADIUS = 64;
	AudioNode node;
	PShape icon;
	float baseRadius;

	WaveAudioNodeCircleShape(AudioNode node, String icon) {
		super(BASE_RADIUS);
		this.node = node;
		this.icon = loadShape("icons/" + icon + ".svg");
	}

	@Override void draw(Style style) {
		float grow = Math.max(0, node.getOutput().getValue() * MAX_GROW_RADIUS);
		float size = BASE_RADIUS * 2 + grow;
		noStroke();
		fill(#999999);
		ellipse(0, 0, size, size);

		style.apply();
		ellipse(0, 0, radius * 2, radius * 2);

		pushMatrix();
		translate(-BASE_RADIUS, -BASE_RADIUS);
		shape(icon);
		popMatrix();
	}
}

abstract class AudioNode extends Node {
	AudioNode(Shape shape, Style style) {
		super(shape, style, new Style());
	}

	abstract AudioNodeOutputType getOutputType();

	abstract UGen getOutput();

	protected abstract void addInput(AudioNode node);

	protected abstract void removeInput(AudioNode node);

	@Override
	void connectTo(Node node) {
		((AudioNode) node).addInput(this);
		super.connectTo(node);
	}

	@Override
	void disconnectFrom(Node node) {
		super.disconnectFrom(node);
		((AudioNode) node).removeInput(this);
	}

	boolean acceptsInputs() {
		return true;
	}
}

