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

	//@Override String[] getSampleNames() {
	//	return new String[] {
	//		"G3.mp3",
	//		"Gs3.mp3",
	//		"A3.mp3",
	//		//As3
	//		"B3.mp3",
	//		"C4.mp3",
	//		"Cs4.mp3",
	//		"D4.mp3",
	//		"Ds4.mp3",
	//		"E4.mp3",
	//		//Es4
	//		"F4.mp3",
	//		"Fs4.mp3",
	//		"G4.mp3",
	//		"Gs4.mp3",
	//		"A4.mp3",
	//		"As4.mp3",
	//		"B4.mp3",
	//		"C5.mp3",
	//		"Cs5.mp3",
	//		"D5.mp3",
	//		"Ds5.mp3",
	//		"E5.mp3",
	//		//Es5
	//		"F5.mp3",
	//		"Fs5.mp3",
	//		"G5.mp3",
	//		"Gs5.mp3",
	//		"A5.mp3",
	//		"As5.mp3",
	//		"B5.mp3",
	//		"C6.mp3",
	//		"Cs6.mp3",
	//		"D6.mp3",
	//		"Ds6.mp3",
	//		"E6.mp3",
	//		//Es6
	//		"F6.mp3",
	//		"Fs6.mp3",
	//		"G6.mp3",
	//		"Gs6.mp3",
	//		"A6.mp3",
	//		"As6.mp3",
	//		"B6.mp3",
	//		"C7.mp3",
	//		"Cs7.mp3",
	//		"D7.mp3",
	//		"Ds7.mp3",
	//		"E7.mp3",
	//		//Es7
	//		"F7.mp3",
	//		"Fs7.mp3",
	//		"G7.mp3"
	//	};
	//}

	@Override String getIconName() {
		return "violin";
	}
}
