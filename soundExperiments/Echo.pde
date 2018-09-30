import java.util.*;

class EchoNode extends AudioNode {
	Gain output;
	Gain inputs;

	Shape icon;

	EchoNode(AudioContext ac) {
		super(null, new Style().fillColor(#73DCFF));

		shape = new WaveAudioNodeCircleShape(this, "echo");

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
