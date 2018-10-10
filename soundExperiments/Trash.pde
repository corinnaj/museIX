
class TrashNode extends AudioNode {
	TrashNode(AudioContext ac) {
		super(ac, new SVGShape(loadShape("icons/trash.svg")), new Style().hasStroke(false).fillColor(#cccccc));
	}

	@Override void addInput(final AudioNode node) {
		getWorld().addPostFrameCallback(new Callback() {
			public void run() {
				node.delete();
			}
		});
	}

	@Override void removeInput(AudioNode node) {}

	@Override AudioNodeOutputType getOutputType() {
		return AudioNodeOutputType.NONE;
	}

	@Override UGen getOutput() {
		return null;
	}

	@Override void mousePress(MorphMouseEvent event) {
		// dont start dragging
	}
}
