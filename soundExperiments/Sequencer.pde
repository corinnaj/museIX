
class SequencerTileMorph extends Morph {
	boolean active = false;
	int row;
	int tick;
	boolean sequence[][];

	static final color ACTIVE_COLOR = #00ffff;
	static final color INACTIVE_COLOR = #009999;

	SequencerTileMorph(boolean[][] sequence, int row, int tick) {
		super(new RectangleShape(80, 80), new Style().fillColor(INACTIVE_COLOR));

		this.row = row;
		this.tick = tick;
		this.sequence = sequence;
		this.active = sequence[row][tick];
		updateColor();
	}

	void mousePress(MouseEvent event) {
		active = !active;
		sequence[row][tick] = active;
		updateColor();
	}

	void updateColor() {
		style.fillColor(active ? ACTIVE_COLOR : INACTIVE_COLOR);
	}
}

class SequencerNode extends AudioNode {
	final static int BEATS_PER_MINUTE = 60;
	final static int TICKS_PER_BEAT = 4;

	Function output;
	Clock clock;
	Shape icon;

	boolean sequence[][] = {
		{true, false, true, false},
		{false, true, false, false},
		{false, false, false, false},
		{false, false, false, true}
	};

	int scale[] = {
		440,
		500,
		660,
		800
	};

	SequencerNode(AudioContext ac) {
		super(new CircleShape(64), new Style().fillColor(#bcf500));

		icon = new SVGShape(loadShape("icons/sequencer.svg"));

		clock = new Clock(ac, BEATS_PER_MINUTE / 60 * 1000);
		clock.setTicksPerBeat(TICKS_PER_BEAT);
		ac.out.addDependent(clock);

		// need to supply an input, even though we're not using it
		output = new Function(new Static(ac, 0)) {
			@Override float calculate() {
				int tick = clock.getInt() % TICKS_PER_BEAT;
				for (int i = 0; i < sequence.length; i++) {
					if (sequence[i][tick])
						return scale[i];
				}
				return 0;
			}
		};
	}

	@Override void addInput(AudioNode node) {}

	@Override void removeInput(AudioNode node) {}

	@Override AudioNodeOutputType getOutputType() {
		return AudioNodeOutputType.FREQUENCIES;
	}

	@Override boolean acceptsIncomingConnection(Node node) {
		return false;
	}

	@Override UGen getOutput() {
		return output;
	}

	@Override
	void draw() {
		super.draw();
		shape.translateToCenterOfRotation(-1);
		icon.draw(style);
		shape.translateToCenterOfRotation(1);
	}
}

class Sequencer {
	Gain out;

	SamplePlayer[] samplePlayers;

	String[] samples = {
		"cowbell-large-closed",
		"drum-bass-lo-1",
		"drum-snare-rim",
		"drum-tom-hi-brush",
	};

	boolean sequence[][] = {
		{false, false, false, false},
		{false, false, false, false},
		{false, false, false, false},
		{false, false, false, false}
	};

	Sequencer(AudioContext ac) {
		Clock clock = new Clock(ac, 1000);
		clock.setTicksPerBeat(4);
		ac.out.addDependent(clock);

		out = new Gain(ac, 1, 0.4);

		try {  
			samplePlayers = new  SamplePlayer[samples.length];
			for (int i = 0; i < samples.length; i++) {
				samplePlayers[i] = new SamplePlayer(ac, new Sample(sketchPath("") + "OpenPathMusic44V1/" + samples[i] + ".wav"));
				samplePlayers[i].setKillOnEnd(false);
				out.addInput(samplePlayers[i]);
			}
		} catch(Exception e) {
			println("Exception while attempting to load sample!");
			e.printStackTrace();
			exit();
		}

		Bead sequencer = new Bead () {
			public void messageReceived(Bead message)
			{
				int tick = ((Clock) message).getInt();
				for (int i = 0; i < sequence.length; i++) {
					if (sequence[i][tick % 4]) {
						samplePlayers[i].setToLoopStart();
						samplePlayers[i].start();
					}
				}
			}
		};
		clock.addMessageListener(sequencer);
	}
}

class SequencerMorph extends Morph {
	static final int TEXT_WIDTH = 80;
	static final int TILE_SIZE = 80;

	SequencerMorph(Sequencer sequencer) {
		super(new RectangleShape(TEXT_WIDTH + sequencer.sequence[0].length * TILE_SIZE, TILE_SIZE * sequencer.sequence.length), new Style().hasFill(false));

		for (int row = 0; row < sequencer.sequence.length; row++) {
			addMorph(new Morph(new TextShape(sequencer.samples[row]), new Style()).setPosition(0, row * TILE_SIZE));

			for (int tick = 0; tick < sequencer.sequence[row].length; tick++) {
				addMorph(new SequencerTileMorph(sequencer.sequence, row, tick)
						.setPosition(TEXT_WIDTH + tick * TILE_SIZE, row * TILE_SIZE));
			}
		}
	}
}
