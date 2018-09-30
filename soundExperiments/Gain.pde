
class GainNode extends RotatableNode {
	static final float MIN_VOLUME = 0.01;
	static final float MAX_VOLUME = 2;

	Gain gain;

	GainNode(AudioContext ac) {
		this(ac, 1);
	}

	GainNode(AudioContext ac, float def) {
		super(ac, false, def, MIN_VOLUME, MAX_VOLUME, 0.01, "speaker", new Style().fillColor(Theme.FILTER_COLOR));

		gain = new Gain(ac, 1, getGlide());
	}

	@Override void addInput(AudioNode node) {
		gain.addInput(node.getOutput());
	}

	@Override void removeInput(AudioNode node) {
		gain.removeAllConnections(node.getOutput());
	}

	@Override UGen getOutput() {
		return gain;
	}

	@Override AudioNodeOutputType getOutputType() {
		return AudioNodeOutputType.WAVES;
	}
}
