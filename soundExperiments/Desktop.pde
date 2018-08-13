
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

		AudioNode wave = (AudioNode) new WaveGeneratorNode(ac).setPosition(700, 700).addTo(world);
		AudioNode echo = (AudioNode )new EchoNode(ac).setPosition(600, 600).addTo(world);

		echo.addInput(wave);
		// echo.addInput(sequencer.out);

		ac.out.addInput(echo.getOutput());
		ac.start();

		new Morph(new WaveformShape(ac.out, 400, 100), s).setPosition(100, 400).addTo(world);
	}
}

