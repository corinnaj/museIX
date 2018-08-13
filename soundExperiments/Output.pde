
class OutputNode extends AudioNode {
    AudioContext ac;

    OutputNode(AudioContext ac) {
	super(new CircleShape(10), new Style().fillColor(#0044ff));
	this.ac = ac;
    }

    @Override
    AudioNode addInput(AudioNode node) {
	super.addInput(node);
	ac.out.addInput(node.getOutput());
	return this;
    }

    @Override
    UGen getOutput() {
	return null;
    }
}
