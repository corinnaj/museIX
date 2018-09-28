
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

	SampleBasedInstrument(AudioContext ac) {
		super(ac);

		try {
			String[] sampleNames = getSampleNames();
			samples = new Sample[sampleNames.length];
			for (int i = 0; i < sampleNames.length; i++) {
				samples[i] = new Sample(sketchPath("") + getBasePath() + sampleNames[i]);
			}
		} catch(Exception e) {
			println("Exception while attempting to load sample!");
			e.printStackTrace();
			exit();
		}
	}

	@Override Note createNote(AudioContext ac, int frequencyKey, int velocityKey) {
		// int index = (int) map(frequencyKey, 0, 999, 0, samples.length) % samples.length;
		return new SampleBasedNote(ac, samples[frequencyKey % samples.length]);
	}

	abstract String getBasePath();
	abstract String[] getSampleNames();
}

class DrumsInstrument extends SampleBasedInstrument {

	DrumsInstrument(AudioContext ac) {
		super(ac);
	}

	@Override String getBasePath() {
		return "OpenPathMusic44V1/";
	}

	@Override String getIconName() {
		return "drums";
	}

	@Override String[] getSampleNames() {
		return new String[] {
			"cowbell-large-closed.wav",
			"drum-bass-lo-1.wav",
			"drum-snare-rim.wav",
			"drum-tom-hi-brush.wav",
		};
	}

	@Override void changeControl(int control, int parameter1, int parameter2) {
		// just an example, actual impl todo
		println("Change control ", control, parameter1, parameter2);
	}
}
