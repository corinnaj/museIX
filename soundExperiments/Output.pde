
class OutputNode extends AudioNode {
	Clip clip;

	OutputNode(AudioContext ac) {
		super(ac, null, new Style().fillColor(Theme.GLOBAL_COLOR));
		shape = new WaveAudioNodeCircleShape(this, "speaker");

		clip = new Clip(ac);
		ac.out.addInput(clip);
	}

	@Override void addInput(AudioNode node) {
		clip.addInput(node.getOutput());
	}

	@Override void removeInput(AudioNode node) {
		clip.removeAllConnections(node.getOutput());
	}

	@Override AudioNodeOutputType getOutputType() {
		return AudioNodeOutputType.WAVES;
	}

	@Override UGen getOutput() {
		return ac.out;
	}

	@Override boolean acceptsIncomingConnection(Node node) {
		return ((AudioNode) node).getOutputType() == AudioNodeOutputType.WAVES;
	}

	@Override boolean wantsToConnectTo(Node node) {
		return false;
	}
}
