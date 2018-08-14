
class EchoNode extends AudioNode {
	Gain output;
	Gain inputs;

	Shape icon;

	EchoNode(AudioContext ac) {
		super(new CircleShape(64), new Style().fillColor(#ff5555));

		icon = new SVGShape(loadShape("icons/echo.svg"));

		inputs = new Gain(ac, 2);

		TapIn delayIn = new TapIn(ac, 2000);
		delayIn.addInput(inputs);
		TapOut delayOut = new TapOut(ac, delayIn, new Static(ac, 500.0));

		Gain delayGain = new Gain(ac, 1, 0.50);
		delayGain.addInput(delayOut);
		delayIn.addInput(delayGain);

		output = new Gain(ac, 1, 1);
		output.addInput(delayGain);
		output.addInput(inputs);
	}

	@Override
	void addInput(AudioNode node) {
		inputs.addInput(node.getOutput());
	}

	@Override
	void removeInput(AudioNode node) {
		inputs.removeAllConnections(node.getOutput());
	}

	@Override
	UGen getOutput() {
		return output;
	}

	@Override
	void draw() {
		super.draw();
		shape.translateToCenterOfRotation(-1);
		icon.draw(style);
		shape.translateToCenterOfRotation(1);
	}
}

