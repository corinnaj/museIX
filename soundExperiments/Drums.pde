
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

