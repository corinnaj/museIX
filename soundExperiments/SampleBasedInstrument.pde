
class SampleBasedNote extends Note {
	SamplePlayer samplePlayer;
	Envelope envelope;
	Gain gain;

	SampleBasedNote(AudioContext ac, Sample sample, UGen output) {
		envelope = new Envelope(ac, 1.0);
		// FIXME I assume we dont need this here?
		// envelope.addSegment(0.5, map(velocityKey, 0, 999, 100, 1000));

		samplePlayer = new SamplePlayer(ac, sample);
		samplePlayer.setKillOnEnd(true);
		samplePlayer.setKillListener(new KillTrigger(samplePlayer));

		samplePlayer.start();

		gain = new Gain(ac, 1, envelope);
		gain.addInput(samplePlayer);
	}

	@Override UGen getOutput() {
		return gain;
	}

	@Override void changePitch(int deltaKey) {
		// FIXME noop?
	}

	@Override void stop(int velocityKey) {
		float velocity = map(velocityKey, 0, 999, 100, 1000);
		envelope.addSegment(0.0, velocity, new KillTrigger(gain));
	}
}

Map<String,Sample> sampleCache = new HashMap<String,Sample>();

Sample loadSampleFile(String file) {
	if (sampleCache.containsKey(file)) {
		return sampleCache.get(file);
	}

	try {
		Sample sample = new Sample(sketchPath("") + file);
		sampleCache.put(file, sample);
		return sample;
	} catch(Exception e) {
		println("Exception while attempting to load sample!");
		e.printStackTrace();
		exit();
		return null;
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
				samples[i] = sampleNames[i] == null
					? null
					: loadSampleFile(getBasePath() + sampleNames[i]);
			}
		} catch(Exception e) {
			println("Exception while attempting to load sample!");
			e.printStackTrace();
			exit();
		}
	}

	int baseNoteIndex() {
		return 0;
	}

	@Override Note createNote(AudioContext ac, int frequencyKey, int velocityKey) {
		int index = frequencyKey - baseNoteIndex();
		if (index >= 0 && index < samples.length && samples[index] != null) {
			return new SampleBasedNote(ac, samples[index], output);
		} else {
			return null;
		}
	}

	abstract String getBasePath();
	abstract String[] getSampleNames();
}

