class ViolinInstrument extends SampleBasedInstrument {

	ViolinInstrument(AudioContext ac) {
		super(ac);
	}

	@Override String getBasePath() {
		return "violin/violin_1_forte_arco-normal/";
	}

	@Override String[] getSampleNames() {
		return new String[] {
			"E5.mp3",
			"A4.mp3",
			"D4.mp3",
			"G5.mp3"
		};
	}

	@Override String getIconName() {
		return "violin";
	}
}
