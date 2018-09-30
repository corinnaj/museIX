
class SynthNote extends Note {
    Gain gain;
    Envelope envelope;
    Glide frequency;
    WavePlayer wavePlayer;

    float baseFrequency;

    SynthNote(AudioContext ac, int frequencyKey, int velocityKey) {
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

class SynthInstrument extends InstrumentNode {
    SynthInstrument(AudioContext ac) {
        super(ac);
    }

    @Override String getIconName() {
        return "synth";
    }

    // This is how you get the sound out
    @Override Note createNote(AudioContext ac, int frequencyKey, int velocityKey) {
        return new SynthNote(ac, frequencyKey, velocityKey);
    }
}
