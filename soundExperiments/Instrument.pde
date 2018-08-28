
abstract class Note {
	abstract UGen getOutput();
	abstract void stop(int velocityKey, UGen disconnectFrom);
	abstract void changePitch(int deltaKey);
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

class SampleBasedNote extends Note {
	SamplePlayer samplePlayer;
	SampleBasedNote(AudioContext ac, Sample sample) {
		samplePlayer = new SamplePlayer(ac, sample);
	}

	@Override UGen getOutput() {
		return samplePlayer;
	}

	@Override void changePitch(int deltaKey) {
		// FIXME noop?
	}

	@Override void stop(int velocityKey, UGen disconnectFrom) {
		// TODO remove connection to parent by using a KillAndDisconnectTrigger(parent, gain)
	}
}

abstract class SampleBasedInstrument extends InstrumentNode {
	private Sample[] samples;

	SampleBasedInstrument(AudioContext ac, Communication communication, String id) {
		super(ac, communication, id);

		try {
			String[] sampleNames = getSampleNames();
			if (sampleNames == null)
				print("ASDASDASD");
			samples = new Sample[sampleNames.length];
			for (int i = 0; i < sampleNames.length; i++) {
				print("Loading " + sampleNames[i]);
				samples[i] = new Sample(sketchPath("") + getBasePath() + sampleNames[i] + ".wav");
			}
		} catch(Exception e) {
			println("Exception while attempting to load sample!");
			e.printStackTrace();
			exit();
		}
	}

	@Override Note createNote(AudioContext ac, int frequencyKey, int velocityKey) {
		int index = (int) map(frequencyKey, 0, 999, 0, samples.length);
		println(index);
		return new SampleBasedNote(ac, samples[index]);
	}

	abstract String getBasePath();
	abstract String[] getSampleNames();
}

class DrumsInstrument extends SampleBasedInstrument {

	DrumsInstrument(AudioContext ac, Communication communication, String id) {
		super(ac, communication, id);
	}

	@Override String getBasePath() {
		return "OpenPathMusic44V1/";
	}

	@Override String[] getSampleNames() {
		return new String[] {
			"cowbell-large-closed",
			"drum-bass-lo-1",
			"drum-snare-rim",
			"drum-tom-hi-brush",
		};
	}
}

