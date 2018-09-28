
class AddPanelMorph extends Morph {
	AddPanelMorph(final AudioContext ac) {
		super(new RectangleShape(200, 200), new Style().fillColor(Theme.BACKGROUND_COLOR));

		Style s = new Style().hasStroke(false).fillColor(#cccccc);

		Morph buttons[] = new Morph[]{
			new ButtonMorph(new SVGShape(loadShape("icons/echo.svg")), s, new ButtonMorphListener() {
				void buttonPressed() { add(new EchoNode(ac)); }
			}),
			new ButtonMorph(new SVGShape(loadShape("icons/speaker.svg")), s, new ButtonMorphListener() {
				void buttonPressed() { add(new GainNode(ac)); }
			}),
			new ButtonMorph(new SVGShape(loadShape("icons/sine-wave.svg")), s, new ButtonMorphListener() {
				void buttonPressed() { add(new WaveGeneratorNode(ac)); }
			}),
			new ButtonMorph(new SVGShape(loadShape("icons/filter.svg")), s, new ButtonMorphListener() {
				void buttonPressed() { add(new LowpassFilterNode(ac)); }
			}),
			new ButtonMorph(new SVGShape(loadShape("icons/sequencer.svg")), s, new ButtonMorphListener() {
				void buttonPressed() { add(new SequencerInstrumentInputNode(ac)); }
			}),
			new ButtonMorph(new SVGShape(loadShape("icons/drums.svg")), s, new ButtonMorphListener() {
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

		node.setPosition(world.centerTop().add(new PVector(0, 200)));

		world.addNode(node);
	}
}
