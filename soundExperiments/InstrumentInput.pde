
interface InstrumentInputListener {
	void noteOn(final String id, final int frequencyKey, final int velocityKey);
	void noteOff(String id, int velocityKey);
	void changePitch(String id, int frequencyKey);
}

abstract class InstrumentInputNode extends AudioNode {
	ArrayList<InstrumentInputListener> listeners = new ArrayList<InstrumentInputListener>();

	InstrumentInputNode(Shape shape, Style style) {
		super(shape, style);
	}

	void registerListener(InstrumentInputListener listener) {
		listeners.add(listener);
	}

	void removeListener(InstrumentInputListener listener) {
		listeners.remove(listener);
	}

	void noteOn(String id, int frequencyKey, int velocityKey) {
		for (InstrumentInputListener l : listeners) {
			l.noteOn(id, frequencyKey, velocityKey);
		}
	}

	void noteOff(String id, int velocityKey) {
		for (InstrumentInputListener l : listeners) {
			l.noteOff(id, velocityKey);
		}
	}

	void changePitch(String id, int deltaKey) {
		for (InstrumentInputListener l : listeners) {
			l.changePitch(id, deltaKey);
		}
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
}

class SequencerInstrumentInputNode extends InstrumentInputNode {
	Shape icon;

	boolean sequence[][] = {
		{true, false, false, false},
		{false, false, false, false},
		{false, true, true, false},
		{true, false, false, true}
	};

	static final int VELOCITY = 200;

	public SequencerInstrumentInputNode(AudioContext ac) {
		super(new CircleShape(64), new Style().fillColor(#cc4444));

		Clock clock = new Clock(ac, 1000);
		clock.setTicksPerBeat(4);
		ac.out.addDependent(clock);

		icon = new SVGShape(loadShape("icons/sequencer.svg"));

		Bead sequencer = new Bead () {
			public void messageReceived(Bead message)
			{
				int tick = ((Clock) message).getInt();
				for (int i = 0; i < sequence.length; i++) {
					if (sequence[i][tick % 4]) {
						noteOn(Integer.toString(i), i, VELOCITY);
					} else {
						noteOff(Integer.toString(i), VELOCITY);
					}
				}
			}
		};
		clock.addMessageListener(sequencer);
	}

	@Override
	void draw() {
		super.draw();
		shape.translateToCenterOfRotation(-1);
		icon.draw(style);
		shape.translateToCenterOfRotation(1);
	}
}

class RemoteInstrumentInputNode extends InstrumentInputNode {
	Shape icon;

	public RemoteInstrumentInputNode() {
		super(new CircleShape(64), new Style().fillColor(#cc4444));

		icon = new SVGShape(loadShape("icons/input.svg"));
	}

	InstrumentListener createListener() {
		return new InstrumentListener() {
			public void noteOn(final String id, final int frequencyKey, final int velocityKey) {
				RemoteInstrumentInputNode.this.noteOn(id, frequencyKey, velocityKey);
			}

			public void noteOff(String id, int velocityKey) {
				RemoteInstrumentInputNode.this.noteOff(id, velocityKey);
			}

			public void changePitch(String id, int deltaKey) {
				RemoteInstrumentInputNode.this.changePitch(id, deltaKey);
			}
		};
	}

	@Override
	void draw() {
		super.draw();
		shape.translateToCenterOfRotation(-1);
		icon.draw(style);
		shape.translateToCenterOfRotation(1);
	}
}

