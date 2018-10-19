
class Loop {
	Sample sample;
	String name;
	int bpm;

	Loop(String name, int bpm) {
		this.name = name;
		this.bpm = bpm;
	}

	Sample load() {
		if (sample != null)
			return sample;

		try {
				return new Sample(sketchPath("") + "loops/" + name);
		} catch(Exception e) {
			println("Exception while attempting to load sample!");
			e.printStackTrace();
			exit();
			return null;
		}
	}
}

Loop[] loops = {
	new Loop("Nurykabe_-_2018_10_11_seq_loop_01.mp3", 100),
	new Loop("rock-n-knock.wav", 100),
	new Loop("guitar_a4.mp3", 100),
};

class LoopNode extends AudioNode {
	SamplePlayer player;

	Loop loop;

	LoopNode(AudioContext ac, Loop loop, Metronome metronome) {
		super(ac, null, new Style().fillColor(Theme.GENERATOR_COLOR));
		shape = new WaveAudioNodeCircleShape(this, "sample");
		this.loop = loop;
		this.player = buildPlayer(loop, metronome);
	}


	protected SamplePlayer buildPlayer(Loop loop, Metronome metronome) {
		SamplePlayer player = new SamplePlayer(ac, loop.load());
		player.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
		player.setRate(new Function(metronome.getGlide()) {
				@Override public float calculate() {
					return 60000.0 / x[0] / LoopNode.this.loop.bpm;
				}
		});
		return player;
	}

	@Override void addInput(AudioNode node) {}
	@Override void removeInput(AudioNode node) {}

	@Override boolean acceptsIncomingConnection(Node node) {
		return false;
	}

	@Override AudioNodeOutputType getOutputType() {
		return AudioNodeOutputType.WAVES;
	}

	@Override UGen getOutput() {
		return player;
	}
}

class Knob extends RotatableNode {
	Knob(AudioContext ac, boolean logMode, float current, float min, float max, float increment, String icon, Style style, Glide glide)  {
		super(ac, logMode, current, min, max, increment, icon, style, glide);
	}

	@Override void mousePress(MorphMouseEvent event) {
		super.mouseLongPress(event);
	}
	@Override void mouseLongPress(MorphMouseEvent event) {}
	@Override UGen getOutput() { return null; }
	@Override void addInput(AudioNode node) {}
	@Override void removeInput(AudioNode node) {}
	@Override AudioNodeOutputType getOutputType() { return AudioNodeOutputType.NONE; }
}

class GranularSamplePlayerSettings extends Morph {
	Glide pitch;
	Glide grainInterval;
	Glide grainSize;
	Glide randomness;
	Glide randomPan;

	static final float SPACING = 150;

	GranularSamplePlayerSettings(AudioContext ac, Glide pitch, Glide grainInterval, Glide grainSize, Glide randomness, Glide randomPan) {
		super(new RectangleShape(SPACING * 6, SPACING), new Style().fillColor(#333333));

		this.pitch = pitch;
		this.grainInterval = grainInterval;
		this.grainSize = grainSize;
		this.randomness = randomness;
		this.randomPan = randomPan;

		Glide[] ugens = {pitch, grainInterval, grainSize, randomness, randomPan};
		float[][] limits = {
			{0, 2, 0.05},
			{10, 400, 1},
			{10, 1000, 1},
			{0, 1, 0.01},
			{0, 1, 0.01},
		};

		for (int i = 0; i < ugens.length; i++) {
			addMorph(new Knob(ac,
						false,
						ugens[i].getValue(),
						limits[i][0],
						limits[i][1],
						limits[i][2],
						"speaker",
						new Style().fillColor(#ff0000), ugens[i]).setPosition(i * SPACING + SPACING / 2, SPACING / 2));
		}
	}
}

class GranularLoopNode extends LoopNode {
	Glide pitch;
	Glide grainInterval;
	Glide grainSize;
	Glide randomness;
	Glide randomPan;

	GranularLoopNode(AudioContext ac, Loop loop, Metronome metronome) {
		super(ac, loop, metronome);

		// pitch
		// grain interval
		// grain size
		// randomness
		// randomPan
	}

	protected SamplePlayer buildPlayer(Loop loop, Metronome metronome) {
		GranularSamplePlayer player = new GranularSamplePlayer(ac, loop.load());

		player.setPitch(pitch = new Glide(ac, 1));
		player.setGrainSize(grainSize = new Glide(ac, 100));
		player.setGrainInterval(grainInterval = new Glide(ac, 70));
		player.setRandomness(randomness = new Glide(ac, 0));
		player.setRandomPan(randomPan = new Glide(ac, 0));

		// player.setLoopStart(new Static(ac, 100));
		// player.setLoopEnd(new Static(ac, 1000));

		player.setLoopType(SamplePlayer.LoopType.LOOP_FORWARDS);
		player.setRate(new Function(metronome.getGlide()) {
				@Override public float calculate() {
					return 60000.0 / x[0] / GranularLoopNode.this.loop.bpm;
				}
		});
		return player;
	}

	int lastX;
	int lastY;
	@Override void mousePress(MorphMouseEvent event) {
		super.mousePress(event);
		lastX = event.x;
		lastY = event.y;
	}
	@Override void mouseRelease(MorphMouseEvent event) {
		super.mouseRelease(event);
		if (lastX != event.x || lastY != event.y)
			return;
		getWorld().addMorph(new GranularSamplePlayerSettings(ac, pitch, grainInterval, grainSize, randomness, randomPan).center(center()));
	}
}
