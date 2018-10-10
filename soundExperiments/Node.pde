
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
		// FIXME not good style
		lineStyle.strokeColor(Theme.LINE_COLOR);
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
			drawConnection(myCenter, otherCenter);
		}

		super.fullDraw();
	}
	
	void drawConnection(PVector start, PVector end) {
		line(start.x, start.y, end.x, end.y);
	}

	@Override void mousePress(MorphMouseEvent event) {
		dragging = true;
		lastPosition.set(event.x, event.y);
		grabMouseFocus();
	}

	@Override void mouseMove(MorphMouseEvent event) {
		if (owner == null) {
			cancelMoving();
			return;
		}

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

	@Override void mouseRelease(MorphMouseEvent event) {
		cancelMoving();
	}

	@Override Morph delete() {
		cutAllConnections();
		cutAllIncomingConnections();
		((NodeWorldMorph) getWorld()).removeNode(this);
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
	WAVES,
	NONE
}


class WaveAudioNodeCircleShape extends CircleShape {
	static final float MAX_GROW_RADIUS = 100;
	static final float BASE_RADIUS = 64;

	final Style ICON_STYLE = new Style().hasStroke(false).fillColor(Theme.ICON_COLOR);

	AudioNode node;
	PShape icon;
	float baseRadius;

	WaveAudioNodeCircleShape(AudioNode node, String icon) {
		super(BASE_RADIUS);
		this.node = node;
		this.icon = loadShape("icons/" + icon + ".svg");
		this.icon.disableStyle();
	}

	@Override void draw(Style style) {
		float grow = Math.max(0, node.getOutput().getValue() * MAX_GROW_RADIUS);
		float size = BASE_RADIUS * 2 + grow;
		noStroke();
		fill(Theme.WAVES_COLOR);
		ellipse(0, 0, size, size);

		style.apply();
		ellipse(0, 0, radius * 2, radius * 2);

		pushMatrix();
		translate(-BASE_RADIUS, -BASE_RADIUS);
		ICON_STYLE.apply();
		shape(icon);
		popMatrix();
	}
}

abstract class AudioNode extends Node {
	AudioContext ac;

	AudioNode(AudioContext ac, Shape shape, Style style) {
		super(shape, style, new Style());
		this.ac = ac;
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

	@Override void drawConnection(PVector start, PVector end) {
		drawWaveformLine(start, end, getOutput());
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
