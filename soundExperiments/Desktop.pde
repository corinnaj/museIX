
class Desktop extends App {
	AudioContext ac;

	Desktop(PApplet applet) {
		super();

		Style s = new Style();

		ac = new AudioContext();

		final AudioNode wave = (AudioNode) new WaveGeneratorNode(ac).setPosition(500, 700);
		final AudioNode echo = (AudioNode) new EchoNode(ac).setPosition(500, 500);
		final AudioNode output = (AudioNode) new OutputNode(ac).setPosition(width / 2, height / 2);
		final AudioNode sequencer = (AudioNode) new SequencerNode(ac).setPosition(400, 700);

		((NodeWorldMorph) world).addNode(wave);
		((NodeWorldMorph) world).addNode(echo);
		((NodeWorldMorph) world).addNode(output);
		((NodeWorldMorph) world).addNode(sequencer);

		sequencer.connectTo(wave);
		wave.connectTo(echo);
		// echo.connectTo(output);

		ac.start();

		// Sequencer sequencer = new Sequencer(ac);
		// world.addMorph(new SequencerMorph(sequencer));
		communication.setListener(new CommunicationListener() {
				@Override
				InstrumentListener instrumentJoined(String id) {
					InstrumentNode instrument = new SineInstrument(ac, communication, id);
					instrument.setPosition(400, 400);
					((NodeWorldMorph) world).addNode(instrument);
					instrument.connectTo(output);

					return instrument.createListener();
				}
		});

		new Morph(new WaveformShape(ac.out, 400, 100), s).setPosition(100, 400).addTo(world);
		new AddPanelMorph(ac).addTo(world);
	}

	@Override
	WorldMorph instantiateWorld() {
		return new NodeWorldMorph();
	}
}

