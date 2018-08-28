
abstract class Note {
    abstract UGen getOutput();
    abstract void stop(int velocityKey, UGen disconnectFrom);
    abstract void changePitch(int deltaKey);
}

class SineNote extends Note {
    Gain gain;
    Envelope envelope;
    Glide frequency;
    WavePlayer wavePlayer;

    float baseFrequency;

    SineNote(AudioContext ac, int frequencyKey, int velocityKey) {
	baseFrequency = map(frequencyKey, 0, 999, 50, 2000);

	envelope = new Envelope(ac, 0.0);
	envelope.addSegment(0.5, map(velocityKey, 0, 999, 100, 1000));

	gain = new Gain(ac, 1, envelope);
	frequency = new Glide(ac, baseFrequency);
	wavePlayer = new WavePlayer(ac, frequency, Buffer.SINE);

	gain.addInput(wavePlayer);
    }

    @Override UGen getOutput() {
	return gain;
    }

    @Override void changePitch(int deltaKey) {
	float delta = map(deltaKey, 0, 999, -100, 100);
	frequency.setValue(baseFrequency + delta);
    }

    @Override void stop(int velocityKey, UGen disconnectFrom) {
	float velocity = map(velocityKey, 0, 999, 100, 1000);
	envelope.addSegment(0.0, velocity, new KillTrigger(gain));
	// TODO remove connection to parent by using a KillAndDisconnectTrigger(parent, gain)
    }
}

abstract class InstrumentNode extends AudioNode {
    final Gain output;
    final AudioContext ac;
    final HashMap<String,Note> notes;

    InstrumentNode(final AudioContext ac, Communication communication, String id) {
	super(new CircleShape(64), new Style().fillColor(#ff0000));

	notes = new HashMap<String,Note>();
	output = new Gain(ac, 1);
	this.ac = ac;
    }

    InstrumentListener createListener() {
	return new InstrumentListener() {
	    public void noteOn(final String id, final int frequencyKey, final int velocityKey) {
		if (notes.containsKey(id))
		    return;
		final Note note = createNote(ac, frequencyKey, velocityKey);
		notes.put(id, note);
		output.addInput(note.getOutput());
	    }

	    public void noteOff(String id, int velocityKey) {
		if (!notes.containsKey(id))
		    return;
		Note note = notes.get(id);
		note.stop(velocityKey, output);
		notes.remove(id);
	    }

	    public void changePitch(String id, int frequencyKey) {
		if (!notes.containsKey(id))
		    return;
		Note note = notes.get(id);
		note.changePitch(frequencyKey);
	    }
	};
    }

    @Override void addInput(AudioNode node) {
    }

    @Override void removeInput(AudioNode node) {
    }

    @Override boolean acceptsIncomingConnection(Node node) {
	return false;
    }

    @Override UGen getOutput() {
	return output;
    }

    @Override AudioNodeOutputType getOutputType() {
	return AudioNodeOutputType.WAVES;
    }

    abstract Note createNote(AudioContext ac, int frequencyKey, int velocityKey);
}

class SineInstrument extends InstrumentNode {
    SineInstrument(AudioContext ac, Communication communication, String id) {
	super(ac, communication, id);
    }

    @Override Note createNote(AudioContext ac, int frequencyKey, int velocityKey) {
	return new SineNote(ac, frequencyKey, velocityKey);
    }
}
