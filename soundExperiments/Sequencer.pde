
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

class SequencerMorph extends Morph {
	static final int TEXT_WIDTH = 80;
	static final int TILE_SIZE = 80;

	SequencerMorph(SequencerInstrumentInputNode sequencer) {
		super(new RectangleShape(TEXT_WIDTH + sequencer.sequence[0].length * TILE_SIZE, TILE_SIZE * sequencer.sequence.length), new Style().fillColor(#111111));

		for (int row = 0; row < sequencer.sequence.length; row++) {
			addMorph(new Morph(new TextShape("0"), new Style()).setPosition(0, row * TILE_SIZE));

			for (int tick = 0; tick < sequencer.sequence[row].length; tick++) {
				addMorph(new SequencerTileMorph(sequencer.sequence, row, tick)
						.setPosition(TEXT_WIDTH + tick * TILE_SIZE, row * TILE_SIZE));
			}
		}

		addMorph(new ButtonMorph(
			new CircleShape(24),
			new Style().fillColor(#ff0000),
			new ButtonMorphListener() {
				@Override void buttonPressed() {
					SequencerMorph.this.delete();
				}
			}).setPosition(24, 24));
	}
}
