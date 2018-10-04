
class Metronome extends RotatableNode {
	static final float MIN_MS = 100;
	static final float MAX_MS = 3000;
	static final float DEFAULT = 1000;

	Metronome(AudioContext ac) {
		super(ac, false, DEFAULT, MIN_MS, MAX_MS, 2, "metronome", new Style().fillColor(Theme.GLOBAL_COLOR));
	}

	@Override void addInput(final AudioNode node) {}
	@Override void removeInput(final AudioNode node) {}
	@Override AudioNodeOutputType getOutputType() {
		return AudioNodeOutputType.NONE;
	}
	@Override UGen getOutput() {
		return null;
	}
}
