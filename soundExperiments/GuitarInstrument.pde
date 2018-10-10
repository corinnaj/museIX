class GuitarInstrument extends SampleBasedInstrument {

	GuitarInstrument(AudioContext ac) {
		super(ac);
	}

	@Override String getBasePath() {
		return "guitar/";
	}

	@Override int baseNoteIndex() {
		return 20;
	}

	@Override String[] getSampleNames() {
		return new String[] {
			"guitar_E2_very-long_forte_normal.mp3",
			"guitar_F2_very-long_forte_normal.mp3",
			"guitar_Fs2_very-long_forte_normal.mp3",
			"guitar_G2_very-long_forte_normal.mp3",
			"guitar_Gs2_very-long_forte_normal.mp3",
			"guitar_A2_very-long_forte_normal.mp3",
			"guitar_As2_very-long_forte_normal.mp3",
			"guitar_B2_very-long_forte_normal.mp3",
			"guitar_C3_very-long_forte_normal.mp3",
			"guitar_Cs3_very-long_forte_normal.mp3",
			"guitar_D3_very-long_forte_normal.mp3",
			"guitar_Ds3_very-long_forte_normal.mp3",
			"guitar_E3_very-long_forte_normal.mp3",
			"guitar_F3_very-long_forte_normal.mp3",
			"guitar_Fs3_very-long_forte_normal.mp3",
			"guitar_G3_very-long_forte_normal.mp3",
			"guitar_Gs3_very-long_forte_normal.mp3",
			"guitar_A3_very-long_forte_normal.mp3",
			"guitar_As3_very-long_forte_normal.mp3",
			"guitar_B3_very-long_forte_normal.mp3",
			"guitar_C4_very-long_forte_normal.mp3",
			"guitar_Cs4_very-long_forte_normal.mp3",
			"guitar_D4_very-long_forte_normal.mp3",
			"guitar_Ds4_very-long_forte_normal.mp3",
			"guitar_E4_very-long_forte_normal.mp3",
			"guitar_F4_very-long_forte_normal.mp3",
			"guitar_Fs4_very-long_forte_normal.mp3",
			"guitar_G4_very-long_forte_normal.mp3",
			"guitar_Gs4_very-long_forte_normal.mp3",
			"guitar_A4_very-long_forte_normal.mp3",
			"guitar_As4_very-long_forte_normal.mp3",
			"guitar_B4_very-long_forte_normal.mp3",
			null, // C5
			null, // Cs5
			"guitar_D5_very-long_forte_normal.mp3",
			"guitar_Ds5_very-long_forte_normal.mp3",
			"guitar_E5_very-long_forte_normal.mp3",
			"guitar_G5_very-long_forte_normal.mp3",
			"guitar_Gs5_very-long_forte_normal.mp3",
		};
	}

	@Override String getIconName() {
		return "guitar";
	}
}
