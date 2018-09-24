
class Desktop extends App {
	AudioContext ac;

	Desktop(PApplet applet) {
		super();

		Style s = new Style();

		ac = new AudioContext();

		final AudioNode wave = (AudioNode) new WaveGeneratorNode(ac).setPosition(500, 700);
		final AudioNode echo = (AudioNode) new EchoNode(ac).setPosition(500, 500);
		final AudioNode output = (AudioNode) new OutputNode(ac).setPosition(width / 2, height / 2);

		final AudioNode drumsInput = (AudioNode) new ExtendedSequencerInstrumentInputNode(ac).setPosition(600, 300);
		final AudioNode drums = (AudioNode) new ExtendedDrumsInstrument(ac).setPosition(800, 300);

		((NodeWorldMorph) world).addNode(wave);
		((NodeWorldMorph) world).addNode(echo);
		((NodeWorldMorph) world).addNode(output);

		((NodeWorldMorph) world).addNode(drumsInput);
		((NodeWorldMorph) world).addNode(drums);

		drumsInput.connectTo(drums);
		drums.connectTo(output);

		wave.connectTo(echo);
		// echo.connectTo(output);

		ac.start();

		communication.setListener(new CommunicationListener() {
				@Override void instrumentRemoved(String id) {
					for (Morph morph : world.submorphs) {
						if (morph instanceof RemoteInstrumentInputNode &&
								((RemoteInstrumentInputNode) morph).id == id) {
							morph.delete();
						}
					}
				}

				@Override InstrumentListener instrumentJoined(String id) {
					RemoteInstrumentInputNode instrumentInput = new RemoteInstrumentInputNode(id);
					instrumentInput.setPosition(600, 400);
					((NodeWorldMorph) world).addNode(instrumentInput);

					DrumsInstrument instrument = new DrumsInstrument(ac);
					instrument.setPosition(800, 400);
					((NodeWorldMorph) world).addNode(instrument);

					instrumentInput.connectTo(instrument);
					instrument.connectTo(output);
					return instrumentInput.createListener();
				}
		});

		new Morph(new WaveformShape(ac.out, 400, 100), s).setPosition(100, 400).addTo(world);
		new AddPanelMorph(ac).addTo(world);

		// new DrumsSequencer().addTo(world);
	}

	@Override
	WorldMorph instantiateWorld() {
		return new NodeWorldMorph();
	}
}
