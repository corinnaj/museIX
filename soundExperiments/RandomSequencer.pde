
class RandomSequencer extends InstrumentInputNode {
	static final float INTERVAL_MS = 1000;
	static final int VELOCITY = 5;

	int noteLength = 2;

	Clock clock;
	int lastId = 0;

	RandomSequencer(AudioContext ac, Clock clock) {
		super(ac, new CircleShape(64), new  Style().fillColor(Theme.CONTROLLER_COLOR));

		final int[] scale = minorScaleBasedOn("C", 2);

		Bead sequencer = new Bead () {
			public void messageReceived(Bead message)
			{
				int tick = ((Clock) message).getInt();
				if (tick % noteLength != 0) {
					noteOff(Integer.toString(lastId), VELOCITY);
				}

				if (tick % noteLength == 0) {
					lastId = (lastId + 1) % 100;
					noteOn(Integer.toString(lastId), scale[(int) (Math.random() * scale.length)], VELOCITY);
				}
			}
		};
		clock.addMessageListener(sequencer);
	}
}

