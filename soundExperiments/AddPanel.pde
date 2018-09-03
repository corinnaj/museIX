
/*class AddAudioNode<T extends AudioNode> extends Morph {
	NodeWorldMorph world;
	AudioContext ac;

	AddAudioNode(PShape shape, AudioContext ac, NodeWorldMorph world) {
		super(new SVGShape(shape), new Style());
		this.world = world;
		this.ac = ac;
	}

	@Override
	void mousePress(MouseEvent event) {
		world.addNode(new T(ac));
	}
}*/

class AddPanelMorph extends Morph {
	AddPanelMorph(final AudioContext ac) {
		super(new RectangleShape(200, 200), new Style());

		Style s = new Style();
		Morph buttons[] = new Morph[]{
			new ButtonMorph(new SVGShape(loadShape("icons/echo.svg")), s, new ButtonMorphListener() {
				void buttonPressed() { add(new EchoNode(ac)); }
			}),
			new ButtonMorph(new SVGShape(loadShape("icons/sine-wave.svg")), s, new ButtonMorphListener() {
				void buttonPressed() { add(new WaveGeneratorNode(ac)); }
			}),
			new ButtonMorph(new SVGShape(loadShape("icons/filter.svg")), s, new ButtonMorphListener() {
				void buttonPressed() { add(new LowpassFilterNode(ac)); }
			}),
			/*new ButtonMorph(new SVGShape(loadShape("icons/sequencer.svg")), s, new ButtonMorphListener() {
				void buttonPressed() { add(new SequencerNode(ac)); }
			}),*/
			new ButtonMorph(new SVGShape(loadShape("icons/sequencer.svg")), s, new ButtonMorphListener() {
				void buttonPressed() { add(new SequencerInstrumentInputNode(ac)); }
			}),
			new ButtonMorph(new SVGShape(loadShape("icons/instrument.svg")), s, new ButtonMorphListener() {
				void buttonPressed() { add(new DrumsInstrument(ac)); }
			}),
			new ButtonMorph(new SVGShape(loadShape("icons/sine-wave.svg")), s, new ButtonMorphListener() {
				void buttonPressed() { add(new SineInstrument(ac)); }
			}),
			new ButtonMorph(new SVGShape(loadShape("icons/violin.svg")), s, new ButtonMorphListener() {
				void buttonPressed() { add(new ViolinInstrument(ac)); }
			}),
		};

		for (int i = 0; i < buttons.length; i++) {
			buttons[i].addTo(this).setPosition(128 * i, 0);
		}

		((RectangleShape) shape).setSize(buttons.length * 128, 128);
	}

	void add(AudioNode node) {
		NodeWorldMorph world = (NodeWorldMorph) getWorld();

		node.setPosition(world.center());

		world.addNode(node);
	}
}

