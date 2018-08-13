
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
