
class OutputNode extends AudioNode {
	AudioContext ac;

	OutputNode(AudioContext ac) {
		super(new SVGShape(loadShape("icons/speaker.svg")), new Style().fillColor(#0044ff));
		this.ac = ac;
	}

	@Override
	void addInput(AudioNode node) {
		ac.out.addInput(node.getOutput());
	}

	@Override
	void removeInput(AudioNode node) {
		ac.out.removeAllConnections(node.getOutput());
	}

	@Override
	UGen getOutput() {
		return null;
	}

	@Override
	boolean wantsToConnect() {
		return false;
	}
}
