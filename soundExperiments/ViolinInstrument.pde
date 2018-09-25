class ViolinInstrument extends SampleBasedInstrument {

	ViolinInstrument(AudioContext ac) {
		super(ac);
	}

	@Override String getBasePath() {
		return "violin/violin_1_forte_arco-normal/";
	}

	@Override  String[] getSampleNames() {
    return new String[] {
      "B5.mp3",
      "A5.mp3",
      "G5.mp3",
      "F5.mp3",
      "E5.mp3",
      "D5.mp3",
      "C5.mp3",
      "B4.mp3",
      "A4.mp3",
      "G4.mp3",
      "F4.mp3",
      "E4.mp3",
      "D4.mp3",
      "C4.mp3",
      "B3.mp3",
      "A3.mp3",
      "G3.mp3"
    };
  }
  
	@Override String getIconName() {
		return "violin";
	}
}
