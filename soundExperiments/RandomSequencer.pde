
class RandomSequencer extends InstrumentInputNode {
	static final float INTERVAL_MS = 1000;
	static final int VELOCITY = 50;
	static final int TICKS_PER_BEAT = 4;

	Clock clock;
	int lastId = 0;

	RandomSequencer(AudioContext ac, UGen interval) {
		super(new CircleShape(64), new  Style().fillColor(Theme.CONTROLLER_COLOR));
		clock = new Clock(ac, interval);
		clock.setTicksPerBeat(TICKS_PER_BEAT);
		ac.out.addDependent(clock);

		final int[] scale = bebopMinorScaleBasedOn("C", 4);

		Bead sequencer = new Bead () {
			public void messageReceived(Bead message)
			{
				noteOff(Integer.toString(lastId), VELOCITY);
				lastId = (lastId + 1) % 100;
				noteOn(Integer.toString(lastId), scale[(int) (Math.random() * scale.length)], VELOCITY);
			}
		};
		clock.addMessageListener(sequencer);
	}
}

