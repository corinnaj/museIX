
class Desktop extends App {
	AudioContext ac;

	Desktop(PApplet applet) {
		super();

		ac = new AudioContext();
		((NodeWorldMorph) world).ac = ac;

		final Metronome metronome = (Metronome) new Metronome(ac).bottomRight(world.bottomRight().sub(30, 30));

		// final AudioNode wave = (AudioNode) new WaveGeneratorNode(ac, 200).setPosition(500, 700);
		// final AudioNode echo = (AudioNode) new EchoNode(ac).setPosition(300, 500);
		// final AudioNode gain = (AudioNode) new GainNode(ac, 0.2).setPosition(600, 550);
		final AudioNode random = (AudioNode) new RandomSequencer(ac, metronome.getClock()).setPosition(300, 500);
		final AudioNode sine = (AudioNode) new SineInstrument(ac).setPosition(500, 700);

		final AudioNode drumsInput = (AudioNode) new ExtendedSequencerInstrumentInputNode(ac, metronome.getClock()).setPosition(600, 230);
		final AudioNode drums = (AudioNode) new DrumsInstrument(ac).setPosition(800, 230);
		final AudioNode echo2 = (AudioNode) new EchoNode(ac).setPosition(1000, 300);

		final AudioNode output = (AudioNode) new OutputNode(ac).setPosition(width / 2, height / 2);

		// ((NodeWorldMorph) world).addNode(wave);
		// ((NodeWorldMorph) world).addNode(echo);
		// ((NodeWorldMorph) world).addNode(gain);
		((NodeWorldMorph) world).addNode(random);
		((NodeWorldMorph) world).addNode(sine);

		((NodeWorldMorph) world).addNode(drumsInput);
		((NodeWorldMorph) world).addNode(drums);
		((NodeWorldMorph) world).addNode(echo2);

		((NodeWorldMorph) world).addNode(output);
		((NodeWorldMorph) world).addNode(metronome);

		random.connectTo(sine);
		sine.connectTo(output);

		drumsInput.connectTo(drums);
		drums.connectTo(output);
		// echo2.connectTo(output);

		// wave.connectTo(echo);
		// echo.connectTo(gain);
		// gain.connectTo(output);

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
					RemoteInstrumentInputNode instrumentInput = new RemoteInstrumentInputNode(ac, id);
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


		((NodeWorldMorph) world).addNode((Node) new TrashNode(ac).topRight(world.topRight()));
		// new Morph(new WaveformShape(ac.out, 400, 100), new Style()).setPosition(100, 400).addTo(world);
		new AddPanelMorph(ac).addTo(world);
	}

	@Override
	WorldMorph instantiateWorld() {
		return new NodeWorldMorph();
	}
}
