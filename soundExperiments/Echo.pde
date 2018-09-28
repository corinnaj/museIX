import java.util.*;

class EchoNode extends RotatableNode {
	static final float MAX_MS = 2000;
	static final float MIN_MS = 10;
	Gain output;
	Gain inputs;

	Shape icon;

	EchoNode(AudioContext ac) {
		super(ac, false, 500, MIN_MS, MAX_MS, 2, "echo", new Style().fillColor(Theme.FILTER_COLOR));

		inputs = new Gain(ac, 1);

		TapIn delayIn = new TapIn(ac, MAX_MS + 100);
		delayIn.addInput(inputs);
		TapOut delayOut = new TapOut(ac, delayIn, getGlide());
		delayOut.setMode(TapOut.InterpolationType.LINEAR);

		Gain delayGain = new Gain(ac, 1, 0.50);
		delayGain.addInput(delayOut);
		delayIn.addInput(delayGain);

		output = new Gain(ac, 1, 1);
		output.addInput(delayGain);
		output.addInput(inputs);
	}

	@Override
	AudioNodeOutputType getOutputType() {
		return connected.size() < 1 ? AudioNodeOutputType.WAVES : ((AudioNode) connected.get(0)).getOutputType();
	}

	@Override void addInput(AudioNode node) {
		inputs.addInput(node.getOutput());
	}

	@Override void removeInput(AudioNode node) {
		inputs.removeAllConnections(node.getOutput());
	}

	@Override boolean acceptsIncomingConnection(Node node) {
		return ((AudioNode) node).getOutputType() == AudioNodeOutputType.WAVES;
	}

	@Override UGen getOutput() {
		return output;
	}
}
