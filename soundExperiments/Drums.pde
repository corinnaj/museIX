
class DrumsSequencerCell extends Morph {
	static final color ACTIVE_COLOR = #77b517;

	boolean active;

	int row;
	int tick;
	ExtendedSequencerInstrumentInputNode input;

	DrumsSequencerCell(float width, float height, ExtendedSequencerInstrumentInputNode input, int row, int tick) {
		super(new RectangleShape(width, height), new Style()
				.strokeColor(#999999)
				.hasStroke(true)
				.fillColor(ACTIVE_COLOR));
		this.row = row;
		this.tick = tick;
		this.input = input;
		this.active = input.steps[row][tick];
		updateColor();
	}

	void mousePress(MouseEvent event) {
		active = !active;
		input.steps[row][tick] = active;
		updateColor();
	}

	void updateColor() {
		if (active)
			style.hasFill(true);
		else
			style.hasFill(false);
	}

	void setSize(float width, float height) {
		((RectangleShape) shape).setSize(width, height);
	}
}

class DrumsSequencer extends Morph {
	static final int WIDTH = 800;
	static final int HEIGHT = 500;

	final String[] SAMPLES = {
		"Perc",
		"Shaker",
		"Snare",
		"Kick 2",
		"Hihat O",
		"Hihat Cl",
		"Clap",
		"Kick"
	};

	static final int BEATS_PER_MEASURE = 4;
	int measures = 4;

	static final int TEXT_WIDTH = 100;
	static final int BUTTON_HEIGHT = 64;

	ExtendedSequencerInstrumentInputNode input;

	DrumsSequencer(ExtendedSequencerInstrumentInputNode input) {
		super(new RectangleShape(WIDTH, HEIGHT), new Style().fillColor(#333333));

		this.input = input;
		measures = input.steps[0].length / BEATS_PER_MEASURE;

		constructPanel();
	}

	void constructPanel() {
		removeAllMorphs();

		int n_ticks = BEATS_PER_MEASURE * measures;
		float cell_width = (WIDTH - TEXT_WIDTH) / (float) n_ticks;
		float cell_height = (HEIGHT - BUTTON_HEIGHT) / SAMPLES.length;

		for (int row = 0; row < SAMPLES.length; row++) {
			addMorph(new Morph(new TextShape(SAMPLES[row]), new Style())
					.setPosition(cell_width * 0.1, (row + 0.5) * cell_height));

			for (int tick = 0; tick < n_ticks; tick++) {
				addMorph(new DrumsSequencerCell(cell_width, cell_height, input, row, tick)
						.setPosition(TEXT_WIDTH + tick * cell_width, row * cell_height));
			}
		}

		addMorph(new IconButtonMorph(
			"add",
			#00ff00,
			new ButtonMorphListener() {
				@Override public void buttonPressed() {
					DrumsSequencer.this.addMeasure();
				}
			}).setPosition(BUTTON_HEIGHT, HEIGHT - BUTTON_HEIGHT / 2));

		addMorph(new IconButtonMorph(
			"remove",
			#ff0000,
			new ButtonMorphListener() {
				@Override public void buttonPressed() {
					DrumsSequencer.this.removeMeasure();
				}
			}).setPosition(BUTTON_HEIGHT * 2, HEIGHT - BUTTON_HEIGHT / 2));

		addMorph(new IconButtonMorph(
			"close",
			#ffffff,
			new ButtonMorphListener() {
				@Override public void buttonPressed() {
					DrumsSequencer.this.delete();
				}
			}).setPosition(BUTTON_HEIGHT * 3, HEIGHT - BUTTON_HEIGHT / 2));
	}

	void addMeasure() {
		measures++;
		input.addMeasure();
		constructPanel();
	}

	void removeMeasure() {
		measures--;
		input.removeMeasure();
		constructPanel();
	}

	@Override void fullDraw() {
		super.fullDraw();

		pushMatrix();
		float line_height = HEIGHT - BUTTON_HEIGHT;

		translate(position.x, position.y);
		float incr = (WIDTH - TEXT_WIDTH) / (float) measures;
		stroke(#cccccc);
		strokeWeight(4.0);
		for (float x = TEXT_WIDTH; x < WIDTH; x += incr) {
			line(x, 0, x, line_height);
		}

		int n_ticks = BEATS_PER_MEASURE * measures;
		float cell_width = (WIDTH - TEXT_WIDTH) / n_ticks;
		float now = (float) input.clock.getSubTickNow();
		float x = TEXT_WIDTH + (((int) now) % n_ticks + (now - floor(now))) * cell_width;
		stroke(#ff0000);
		line(x, 0, x, line_height);
		popMatrix();
	}
}

class ExtendedDrumsInstrument extends SampleBasedInstrument {

	ExtendedDrumsInstrument(AudioContext ac) {
		super(ac);
	}

	@Override String getBasePath() {
		return "OpenPathMusic44V1/";
	}

	@Override String getIconName() {
		return "drums";
	}

	@Override String[] getSampleNames() {
		return new String[] {
			"cowbell-large-open.wav",
			"shaker.wav",
			"drum-snare-tap.wav",
			"drum-bass-hi-1.wav",
			"cymbal-hihat-open-stick-1.wav",
			"cymbal-hihat-foot-1.wav",
			"drum-snare-rim.wav",
			"drum-bass-lo-1.wav"
		};
	}
}


class ExtendedSequencerInstrumentInputNode extends InstrumentInputNode {
	Shape icon;
	Style iconStyle;

	static final int VELOCITY = 200;
	static final int TICKS_PER_BEAT = 4;
	static final int N_TRACKS = 8;

	int measures = 2;
	boolean[][] steps;

	Clock clock;

	public ExtendedSequencerInstrumentInputNode(AudioContext ac, UGen interval) {
		super(ac, new CircleShape(64), new Style().fillColor(Theme.CONTROLLER_COLOR));

		clock = new Clock(ac, interval);
		clock.setTicksPerBeat(TICKS_PER_BEAT);
		ac.out.addDependent(clock);

		icon = new SVGShape(loadShape("icons/sequencer.svg"));
		iconStyle = new Style().hasStroke(false).fillColor(Theme.ICON_COLOR);

		int n_steps = TICKS_PER_BEAT * measures;
		steps = new boolean[N_TRACKS][TICKS_PER_BEAT * measures];
		steps[3][1] = true;
		steps[3][3] = true;
		steps[3][5] = true;
		steps[3][7] = true;
		steps[4][0] = true;

		Bead sequencer = new Bead () {
			public void messageReceived(Bead message)
			{
				int n_steps = TICKS_PER_BEAT * measures;
				int tick = ((Clock) message).getInt();
				for (int i = 0; i < N_TRACKS; i++) {
					if (steps[i][tick % n_steps]) {
						noteOff(Integer.toString(i), VELOCITY);
						noteOn(Integer.toString(i), i, VELOCITY);
					} else {
						noteOff(Integer.toString(i), VELOCITY);
					}
				}
			}
		};
		clock.addMessageListener(sequencer);
	}

	void addMeasure() {
		measures++;
		boolean[][] new_steps = new boolean[N_TRACKS][TICKS_PER_BEAT * measures];
		for (int row = 0; row < N_TRACKS; row++) {
			for (int i = 0; i < TICKS_PER_BEAT * (measures - 1); i++) {
				new_steps[row][i] = steps[row][i];
			}
		}
		steps = new_steps;
	}

	void removeMeasure() {
		measures--;
		boolean[][] new_steps = new boolean[N_TRACKS][TICKS_PER_BEAT * measures];
		for (int row = 0; row < N_TRACKS; row++) {
			for (int i = 0; i < TICKS_PER_BEAT * measures; i++) {
				new_steps[row][i] = steps[row][i];
			}
		}
		steps = new_steps;
	}

	@Override void draw() {
		super.draw();
		shape.translateToCenterOfRotation(-1);
		icon.draw(iconStyle);
		shape.translateToCenterOfRotation(1);
	}

	int lastX;
	int lastY;
	@Override void mousePress(MouseEvent event) {
		super.mousePress(event);
		lastX = event.x;
		lastY = event.y;
	}
	@Override void mouseRelease(MouseEvent event) {
		super.mouseRelease(event);
		if (lastX != event.x || lastY != event.y)
			return;
		getWorld().addMorph(new DrumsSequencer(this).setPosition(position));
	}
}
