
class LowpassFilterNode extends FrequencyChangerNode {
	BiquadFilter filter;
	Shape icon;

	LowpassFilterNode(AudioContext ac) {
		super(new Glide(ac, 500));
		filter = new BiquadFilter(ac, BiquadFilter.Type.LP, frequency, 0.5);
		icon = new SVGShape(loadShape("icons/filter.svg"));
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

	@Override
	void draw() {
		super.draw();
		shape.translateToCenterOfRotation(-1);
		icon.draw(style);
		shape.translateToCenterOfRotation(1);
	}
}
