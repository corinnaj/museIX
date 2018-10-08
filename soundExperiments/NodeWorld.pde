
class NodeWorldMorph extends WorldMorph {
	boolean dragging = false;
	PVector lastPosition = new PVector();

	ArrayList<Node> nodes = new ArrayList();

	public AudioContext ac;

	NodeWorldMorph() {
		super(new Style().fillColor(Theme.BACKGROUND_COLOR));
	}

	NodeWorldMorph(Shape shape) {
		super(shape, new Style().fillColor(Theme.BACKGROUND_COLOR));
	}

	void addNode(Node node) {
		UGen o = ((AudioNode) node).getOutput();
		// ensure that we're always updated
		if (o != null) {
			ac.out.addDependent(o);
		}
		addMorph(node);
		nodes.add(node);
	}

	void removeNode(Node node) {
		UGen o = ((AudioNode) node).getOutput();
		if (o != null) {
			ac.out.removeDependent(o);
		}
		removeMorph(node);
		nodes.remove(node);
	}

	@Override
	void mousePress(MouseEvent event) {
		super.mousePress(event);
		dragging = true;
		lastPosition.set(event.x, event.y);
	}

	@Override
	void mouseMove(MouseEvent event) {
		if (dragging) {
			ArrayList<Node> dead = new ArrayList();
			for (Node node : nodes) {
				PVector myCenter = node.center();
				for (Node connected : node.connected) {
					PVector otherCenter = connected.center();
					if (testLinesIntersect(lastPosition.x, lastPosition.y, event.x, event.y,
								myCenter.x, myCenter.y, otherCenter.x, otherCenter.y)) {
						dead.add(connected);
					}
				}

				for (Node n : dead) node.disconnectFrom(n);
				dead.clear();
			}
		}
	}

	@Override
	void mouseRelease(MouseEvent event) {
		super.mouseRelease(event);
		dragging = false;
	}

	// SOURCE: https://stackoverflow.com/questions/563198/how-do-you-detect-where-two-line-segments-intersect
	boolean testLinesIntersect(float p0_x, float p0_y, float p1_x, float p1_y, float p2_x, float p2_y, float p3_x, float p3_y) {
	    float s1_x, s1_y, s2_x, s2_y;
	    s1_x = p1_x - p0_x;     s1_y = p1_y - p0_y;
	    s2_x = p3_x - p2_x;     s2_y = p3_y - p2_y;

	    float s, t;
	    s = (-s1_y * (p0_x - p2_x) + s1_x * (p0_y - p2_y)) / (-s2_x * s1_y + s1_x * s2_y);
	    t = ( s2_x * (p0_y - p2_y) - s2_y * (p0_x - p2_x)) / (-s2_x * s1_y + s1_x * s2_y);

	    return s >= 0 && s <= 1 && t >= 0 && t <= 1;
	}
}

class BeatWavesShape extends WorldShape {
	Clock clock;
	double lastTick;

	void setClock(Clock clock) {
		this.clock = clock;
		Bead ticker = new Bead() {
			public void messageReceived(Bead message) {
				if (((Clock) message).isBeat())
					lastTick = ((Clock) message).getSubTickNow();
			}
		};
		clock.addMessageListener(ticker);
	}

	@Override void draw(Style style) {
		background(style.fillColor());

		int maxOpacity = 80;
		float beatLength = clock.getIntervalEnvelope().getValue() / 1000.0 * clock.getTicksPerBeat();
		float progress = (float) (clock.getSubTickNow() - lastTick);
		float scale = map(progress, 0, beatLength, 0, 1);
		float diameter = Math.max(width, height) * (float) Math.sqrt(2) * scale;

		noFill();
		stroke(color(150, maxOpacity - scale * maxOpacity));
		strokeWeight(map(scale, 0, 1, 80.0, 1.0));
		ellipse(width / 2, height / 2, diameter, diameter);
	}
}
