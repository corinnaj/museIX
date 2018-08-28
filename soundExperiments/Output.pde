
class OutputNode extends AudioNode {
	AudioContext ac;

	Clip clip;

	OutputNode(AudioContext ac) {
		super(new SVGShape(loadShape("icons/speaker.svg")), new Style().fillColor(#0044ff));

		clip = new Clip(ac);
		ac.out.addInput(clip);

		this.ac = ac;
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
		return null;
	}

	@Override boolean acceptsIncomingConnection(Node node) {
		return ((AudioNode) node).getOutputType() == AudioNodeOutputType.WAVES;
	}

	@Override boolean wantsToConnectTo(Node node) {
		return false;
	}
}
