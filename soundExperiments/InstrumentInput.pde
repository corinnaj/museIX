
interface InstrumentInputListener {
	void noteOn(final String id, final int frequencyKey, final int velocityKey);
	void noteOff(String id, int velocityKey);
	void changePitch(String id, int frequencyKey);
}

class InstrumentInputNode extends AudioNode {
	ArrayList<InstrumentInputListener> listeners = new ArrayList<InstrumentInputListener>();

	Shape icon;

	public InstrumentInputNode() {
		super(new CircleShape(64), new Style().fillColor(#cc4444));

		icon = new SVGShape(loadShape("icons/input.svg"));
	}

	InstrumentListener createListener() {
		return new InstrumentListener() {
			public void noteOn(final String id, final int frequencyKey, final int velocityKey) {
				for (InstrumentInputListener l : listeners) {
					l.noteOn(id, frequencyKey, velocityKey);
				}
			}

			public void noteOff(String id, int velocityKey) {
				for (InstrumentInputListener l : listeners) {
					l.noteOff(id, velocityKey);
				}
			}

			public void changePitch(String id, int deltaKey) {
				for (InstrumentInputListener l : listeners) {
					l.changePitch(id, deltaKey);
				}
			}
		};
	}

	@Override boolean acceptsIncomingConnection(Node node) {
		return false;
	}

	@Override boolean wantsToConnectTo(Node node) {
		// FIXME might be too restrictive, but works for now
		return node instanceof InstrumentNode;
	}

	@Override AudioNodeOutputType getOutputType() {
		return AudioNodeOutputType.NOTES;
	}

	@Override UGen getOutput() { return null; }
	@Override void addInput(AudioNode node) {}
	@Override void removeInput(AudioNode node) {}

	void registerListener(InstrumentInputListener listener) {
		listeners.add(listener);
	}

	void removeListener(InstrumentInputListener listener) {
		listeners.remove(listener);
	}


	@Override
	void draw() {
		super.draw();
		shape.translateToCenterOfRotation(-1);
		icon.draw(style);
		shape.translateToCenterOfRotation(1);
	}
}

