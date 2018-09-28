
class WaveGeneratorNode extends RotatableNode {
	WavePlayer wavePlayer;
	Gain gain;
	Shape icon;
	Style iconStyle;

	WaveGeneratorNode(AudioContext ac) {
		super(ac, 440, "sine-wave", new Style().fillColor(#ff00ff));
		wavePlayer = new WavePlayer(ac, getGlide(), Buffer.SINE);
		gain = new Gain(ac, 1, 0.3);
		gain.addInput(wavePlayer);
	}

	@Override
	void addInput(AudioNode node) {
		cutAllIncomingConnections();

		wavePlayer.setFrequency(node.getOutput());
	}

	@Override
	void removeInput(AudioNode node) {
		wavePlayer.setFrequency(getGlide());
	}

	@Override
	UGen getOutput() {
		return gain;
	}

	@Override boolean acceptsIncomingConnection(Node node) {
		return ((AudioNode) node).getOutputType() == AudioNodeOutputType.FREQUENCIES;
	}

	@Override
	AudioNodeOutputType getOutputType() {
		return AudioNodeOutputType.WAVES;
	}
}
