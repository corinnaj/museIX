
class SynthNote extends Note {
    Gain gain;
    Envelope envelope;
    Glide frequency;
    WavePlayer wavePlayer;

    float baseFrequency;

    SynthNote(AudioContext ac, int frequencyKey, int velocityKey) {
        baseFrequency = frequencyKey;

        envelope = new Envelope(ac, 0.0);
        envelope.addSegment(0.5, velocityKey);

        gain = new Gain(ac, 1, envelope);
        frequency = new Glide(ac, baseFrequency);
        wavePlayer = new WavePlayer(ac, frequency, Buffer.SQUARE);

        gain.addInput(wavePlayer);
    }

    @Override UGen getOutput() {
		return gain;
	}

	@Override void changePitch(int deltaKey) {
		float delta = deltaKey;
		frequency.setValue(baseFrequency + delta);
	}

	@Override void stop(int velocityKey, UGen disconnectFrom) {
		float velocity = velocityKey;
		envelope.addSegment(0.0, velocity, new KillTrigger(gain));
	}
}

class SynthInstrument extends InstrumentNode {
    SynthInstrument(AudioContext ac) {
        super(ac);
    }

    @Override String getIconName() {
        return "synth";
    }

    @Override Note createNote(AudioContext ac, int frequencyKey, int velocityKey) {
        return new SynthNote(ac, frequencyKey, velocityKey);
    }
}
