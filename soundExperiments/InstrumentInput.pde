
interface InstrumentInputListener {
	void noteOn(final String id, final int frequencyKey, final int velocityKey);
	void noteOff(String id, int velocityKey);
	void changePitch(String id, int frequencyKey);
	void changeControl(int command, int parameter1, int parameter2);
}

class NoteEvent {
	float start;
	float stop = 0;
	int frequencyKey;

	NoteEvent(float time, int frequencyKey) {
		this.frequencyKey = frequencyKey;
		this.start = time;
	}

	void off(float time) {
		this.stop = time;
	}
}

interface CircularForeach {
	void run(NoteEvent val);
}
class CircularBuffer {
	/*
	[]        -> 0,0
	[3]       -> 0,1
	[3, 5]    -> 0,2
	[3, 5, 2] -> 0,3
	[4, 5, 2] -> 1, 1
	[4, 7, 2] -> 2, 2
	[4, 7, 9] -> 0, 3
	[1, 7, 9] -> 1, 1
	[1, 2, 9] -> 2, 2
	[1, 2, 3] -> 0, 3
	 */
	int start;
	int end;
	NoteEvent[] data;

	CircularBuffer(int capacity) {
		data = new NoteEvent[capacity];
	}

	void push(NoteEvent val) {
		if (end == data.length) {
			end = 0;
		}
		data[end] = val;
		// initial fillup
		if (start == 0 && end == 0 || end > start)
			end++;
		else if (start == end) {
			end++;
			start++;
			if (start == data.length)
				start = 0;
		}
	}

	void foreach(CircularForeach callback) {
		if (start == 0) {
			for (int i = start; i < end; i++) callback.run(data[i]);
		} else {
			for (int i = start; i < data.length; i++) callback.run(data[i]);
			for (int i = 0; i < end; i++) callback.run(data[i]);
		}
	}

	float[] getMinMaxFrequencyKey() {
		float min = 1000;
		float max = 0;

		for (int i = 0; i < end; i++) {
			if (data[i] == null)
				break;
			if (data[i].frequencyKey < min)
				min = data[i].frequencyKey;
			if (data[i].frequencyKey > max)
				max = data[i].frequencyKey;
		}

		return new float[]{min, max};
	}
}

interface InstrumentCreator {
	public InstrumentNode create(AudioContext ac);
}
InstrumentCreator[] creators = {
	new InstrumentCreator() {@Override public InstrumentNode create(AudioContext ac) {
		return new ViolinInstrument(ac);}},
	new InstrumentCreator() {@Override public InstrumentNode create(AudioContext ac) {
		return new GuitarInstrument(ac);}},
	new InstrumentCreator() {@Override public InstrumentNode create(AudioContext ac) {
		return new SynthInstrument(ac);}},
	new InstrumentCreator() {@Override public InstrumentNode create(AudioContext ac) {
		return new DrumsInstrument(ac);}}
};

abstract class InstrumentInputNode extends AudioNode {
	ArrayList<InstrumentInputListener> listeners = new ArrayList<InstrumentInputListener>();

	CircularBuffer events = new CircularBuffer(50);

	HashMap<String,NoteEvent> pendingEvents = new HashMap<String,NoteEvent>();

	InstrumentInputNode(AudioContext ac, Shape shape, Style style) {
		super(ac, shape, style);
	}

	void registerListener(InstrumentInputListener listener) {
		listeners.add(listener);
	}

	void removeListener(InstrumentInputListener listener) {
		listeners.remove(listener);
	}

	void noteOn(String id, int frequencyKey, int velocityKey) {
		NoteEvent event = new NoteEvent((float) ac.getTime(), frequencyKey);
		events.push(event);
		pendingEvents.put(id, event);

		for (InstrumentInputListener l : listeners) {
			l.noteOn(id, frequencyKey, velocityKey);
		}
	}

	void noteOff(String id, int velocityKey) {
		NoteEvent event = pendingEvents.get(id);
		if (event != null) {
			pendingEvents.remove(id);
			event.off((float) ac.getTime());
		}

		for (InstrumentInputListener l : listeners) {
			l.noteOff(id, velocityKey);
		}
	}

	void changePitch(String id, int deltaKey) {
		for (InstrumentInputListener l : listeners) {
			l.changePitch(id, deltaKey);
		}
	}

	void changeControl(String command, int parameter1, int parameter2) {
		int intCommand = Integer.valueOf(command);
		for (InstrumentInputListener l : listeners) {
			l.changeControl(intCommand, parameter1, parameter2);
		}
	}

	void maybeAdaptInstrument(final int index) {
		getWorld().addPostFrameCallback(new Callback() {
			@Override
			public void run() {
				if (index >= creators.length) {
					println("Non existent instrument requested, ignoring");
					return;
				}

				// check if we are currently connected to an instrument we can replace
				for (InstrumentInputListener l : listeners) {
					if (l instanceof InstrumentNode) {
						InstrumentNode oldInstrument = (InstrumentNode) l;
						InstrumentNode newInstrument = creators[index].create(ac);
						newInstrument.topLeft(oldInstrument.topLeft());
						for (Node n : oldInstrument.connected) {
							newInstrument.connectTo(n);
						}
						oldInstrument.delete();
						((NodeWorldMorph) getWorld()).addNode(newInstrument);
						InstrumentInputNode.this.connectTo(newInstrument);
						break;
					}
				}
			}
		});
	}

	@Override Morph delete() {
		// delete the default instrument if it's still connected
		if (listeners.size() == 1 && listeners.get(0) instanceof InstrumentNode) {
			final InstrumentNode instrument = (InstrumentNode) listeners.get(0);
			getWorld().addPostFrameCallback(new Callback() {
				@Override public void run() {
					instrument.delete();
				}
			});
		}

		listeners.clear();
		return super.delete();
	}

	@Override boolean acceptsIncomingConnection(Node node) {
		return false;
	}

	@Override boolean wantsToConnectTo(Node node) {
		// FIXME might be too restrictive, but works for now
		return node instanceof InstrumentNode || node instanceof TrashNode;
	}

	@Override AudioNodeOutputType getOutputType() {
		return AudioNodeOutputType.NOTES;
	}

	@Override UGen getOutput() { return null; }
	@Override void addInput(AudioNode node) {}
	@Override void removeInput(AudioNode node) {}

	@Override void drawConnection(PVector start, PVector end) {
		// line(start.x, start.y, end.x, end.y);

		pushMatrix();
		translate(start.x, start.y);
		final float length = start.dist(end);
		rotate(end.sub(start).heading());

		stroke(color(100, 100, 100, 180));
		strokeWeight(80);
		line(0, 0, length, 0);

		final float INTERVAL = 1000;
		final float endTime = (float) ac.getTime();
		final float startTime = endTime - INTERVAL;

		final float[] minMax = events.getMinMaxFrequencyKey();
		stroke(#ffffff);
		strokeWeight(8.0f);

		events.foreach(new CircularForeach() {
			@Override public void run(NoteEvent event) {
				if (event.start < startTime)
					return;

				float y = minMax[0] == minMax[1] ? 0 : map(event.frequencyKey, minMax[0], minMax[1], -20, 20);
				float relStart = 1 - (event.start - startTime) / INTERVAL;
				float relStop = 1 - (event.stop == 0 ? 1 : (event.stop - startTime) / INTERVAL);
				line(relStart * length, y, relStop * length, y);
			}
		});

		popMatrix();
	}
}

class RemoteInstrumentInputNode extends InstrumentInputNode {
	static final float BASE_RADIUS = 64;
	String id;

	PShape icon;
	final Style ICON_STYLE = new Style().hasStroke(false).fillColor(Theme.ICON_COLOR);

	public RemoteInstrumentInputNode(AudioContext ac, String id) {
		super(ac, new CircleShape(BASE_RADIUS), new Style().fillColor(Theme.CONTROLLER_COLOR));

		this.id = id;
		icon = loadShape("icons/input.svg");
		icon.disableStyle();
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

			public void control(String command, int parameter1, int parameter2) {
				RemoteInstrumentInputNode.this.changeControl(command, parameter1, parameter2);
			}

			public void requestInstrument(int index)  {
				RemoteInstrumentInputNode.this.maybeAdaptInstrument(index);
			}
		};
	}

	@Override
	void draw() {
		super.draw();

		pushMatrix();
		translate(-BASE_RADIUS, -BASE_RADIUS);
		ICON_STYLE.apply();
		shape(icon);
		popMatrix();
	}
}
