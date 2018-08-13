
class Desktop extends App {
	WebsocketServer ws;
	AudioContext ac;

	Desktop(PApplet applet) {
		super();

		Style s = new Style();

		ws = new WebsocketServer(applet, 8025, "/museix");

		ac = new AudioContext();

		Sequencer sequencer = new Sequencer(ac);

		world.addMorph(new SequencerMorph(sequencer));

		AudioNode wave1 = (AudioNode) new WaveGeneratorNode(ac).setPosition(500, 700).addTo(world);
		AudioNode wave2 = (AudioNode) new WaveGeneratorNode(ac).setPosition(700, 700).addTo(world);
		AudioNode echo = (AudioNode) new EchoNode(ac).setPosition(500, 500).addTo(world);
		AudioNode output = (AudioNode) new OutputNode(ac).setPosition(width / 2, height / 2).addTo(world);

		echo.addInput(wave1);
		echo.addInput(wave2);
		// echo.addInput(sequencer.out);

		output.addInput(echo);

		ac.start();

		new Morph(new WaveformShape(ac.out, 400, 100), s).setPosition(100, 400).addTo(world);
	}
}

