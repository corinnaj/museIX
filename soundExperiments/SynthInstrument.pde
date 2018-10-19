
class SynthConfig {
    float attack = 100;
    float decay = 50;
    float sustain = 800;
    float release = 100;
    Buffer waveType;
}

class SynthNote extends Note {
    Gain gain;
    Envelope envelope;
    Glide frequency;
    WavePlayer wavePlayer;
    SynthConfig config;

    float baseFrequency;

    SynthNote(AudioContext ac, int frequencyKey, SynthConfig config) {
        baseFrequency = noteIndexToFrequency(frequencyKey);

        envelope = new Envelope(ac, 0.0);
        envelope.addSegment(0.4, config.attack);
        envelope.addSegment(0.2, config.decay);

	this.config = config;

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

    @Override void stop(int velocityKey) {
	float velocity = velocityKey;
	envelope.addSegment(0.0, config.release, new KillTrigger(gain));
    }
}

class SynthInstrument extends InstrumentNode {
    SynthConfig config = new SynthConfig();

    SynthInstrument(AudioContext ac) {
        super(ac);
    }

    @Override String getIconName() {
        return "synth";
    }

    @Override Note createNote(AudioContext ac, int frequencyKey, int velocityKey) {
        return new SynthNote(ac, frequencyKey, config);
    }

    @Override void changeControl(int command, int parameter1, int parameter2) {
	switch (command) {
	    case 1: // change curve
		switch (parameter1) {
		    case 0:
			config.waveType = Buffer.SINE;
			break;
		    case 1:
			config.waveType = Buffer.TRIANGLE;
			break;
		    case 2:
			config.waveType = Buffer.SAW;
			break;
		}
		break;
	    case 2: // attack
		config.attack = map(parameter1, 0, 999, 10, 2000);
		break;
	    case 3: // decay
		config.decay = map(parameter1, 0, 999, 10, 2000);
		break;
	    case 4: // sustain
		config.sustain = map(parameter1, 0, 999, 10, 2000);
		break;
	    case 5: // release
		config.release = map(parameter1, 0, 999, 10, 2000);
		break;
	}
    }
}
