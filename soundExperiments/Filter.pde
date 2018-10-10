
class LowpassFilterNode extends RotatableNode {
	BiquadFilter filter;
	Shape icon;

	LowpassFilterNode(AudioContext ac) {
		super(ac, 500, "filter", new Style().fillColor(#00ffff));
		filter = new BiquadFilter(ac, BiquadFilter.Type.LP, getGlide(), 0.5);
	}

	@Override void addInput(AudioNode node) {
		filter.addInput(node.getOutput());
	}

	@Override void removeInput(AudioNode node) {
		filter.removeAllConnections(node.getOutput());
	}

	@Override UGen getOutput() {
		return filter;
	}

	@Override AudioNodeOutputType getOutputType() {
		return AudioNodeOutputType.WAVES;
	}

	@Override boolean acceptsIncomingConnection(Node node) {
		return ((AudioNode) node).getOutputType() == AudioNodeOutputType.WAVES;
	}
}
