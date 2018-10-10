
abstract class Note {
	abstract UGen getOutput();
	abstract void stop(int velocityKey, UGen disconnectFrom);
	abstract void changePitch(int deltaKey);
}

abstract class InstrumentNode extends AudioNode implements InstrumentInputListener {
	final Gain output;
	final HashMap<String,Note> notes;

	InstrumentNode(final AudioContext ac) {
		super(ac, null, new Style().fillColor(Theme.GENERATOR_COLOR));
		shape = new WaveAudioNodeCircleShape(this, getIconName());

		notes = new HashMap<String,Note>();
		output = new Gain(ac, 1);
	}

	String getIconName() {
		return "instrument";
	}

	@Override void addInput(AudioNode node) {
		assert(node instanceof InstrumentInputNode);

		((InstrumentInputNode) node).registerListener(this);
	}

	@Override void removeInput(AudioNode node) {
		((InstrumentInputNode) node).removeListener(this);
	}

	@Override boolean acceptsIncomingConnection(Node node) {
		return ((AudioNode) node).getOutputType() == AudioNodeOutputType.NOTES;
	}

	@Override UGen getOutput() {
		return output;
	}

	@Override AudioNodeOutputType getOutputType() {
		return AudioNodeOutputType.WAVES;
	}

	@Override void noteOn(final String id, final int frequencyKey, final int velocityKey) {
		if (notes.containsKey(id))
			return;
		final Note note = createNote(ac, frequencyKey, velocityKey);
		notes.put(id, note);
		UGen ugen = note.getOutput();
		output.addInput(ugen);
		ugen.start();
	}

	void noteOff(String id, int velocityKey) {
		if (!notes.containsKey(id))
			return;
		Note note = notes.get(id);
		note.stop(velocityKey, output);
		notes.remove(id);
	}

	void changePitch(String id, int frequencyKey) {
		if (!notes.containsKey(id))
			return;
		Note note = notes.get(id);
		note.changePitch(frequencyKey);
	}

	// can be overriden if need be, otherwise ignores all control commands
	void changeControl(int command, int parameter1, int parameter2) {
	}

	abstract Note createNote(AudioContext ac, int frequencyKey, int velocityKey);
}
