
/**
 * NOTE CONVERSION UTILS
 */
int indexOfName(String name)  {
	switch (name) {
		case "A":
			return 0;
		case "A#":
		case "Bb":
			return 1;
		case "B":
		case "Cb":
			return 2;
		case "C":
		case "B#":
			return 3;
		case "C#":
		case "Db":
			return 4;
		case "D":
			return 5;
		case "D#":
		case "Eb":
			return 6;
		case "E":
		case "Fb":
			return 7;
		case "F":
		case "E#":
			return 8;
		case "F#":
		case "Gb":
			return 9;
		case "G":
			return 10;
		case "G#":
		case "Ab":
			return 11;
		default:
			println("invalid note " + name + " specified");
			return 0;
	}
}

int noteToIndex(String name, int num) {
	return num * 12 + indexOfName(name) + 1;
}

float noteToFrequency(String name, int num) {
	return noteIndexToFrequency(noteToIndex(name, num));
}

float noteIndexToFrequency(int index) {
	return (float) Math.pow(2.0f, (index - 49.0f) / 12.0f) * 440.0f;
}

void testNoteToFrequency() {
	assert(noteToFrequency("A", 0) == 27.5);
	assert(noteToFrequency("A", 1) == 55.0);
	assert(noteToFrequency("A", 4) == 440.0);
	assert(noteToFrequency("A", 8) == 7040.0);
}

/**
 * UTILS FOR SCALES
 */
int[] majorScaleBasedOn(String name, int num) {
	return scale(name, num, 2, 2, 1, 2, 2, 2, 1);
}
int[] minorScaleBasedOn(String name, int num) {
	return scale(name, num, 2, 1, 2, 2, 1, 2, 2);
}
int[] dorianScaleBasedOn(String name, int num) {
	return scale(name, num, 2, 1, 2, 2, 2, 1, 2);
}
int[] bluesScaleBasedOn(String name, int num) {
	return scale(name, num, 3, 2, 1, 1, 3, 2);
}
int[] bebopMajorScaleBasedOn(String name, int num) {
	return scale(name, num, 2, 2, 1, 2, 1, 1, 2, 1);
}
int[] bebopDominantScaleBasedOn(String name, int num) {
	return scale(name, num, 2, 2, 1, 2, 2, 1, 1, 1);
}
int[] bebopMinorScaleBasedOn(String name, int num) {
	return scale(name, num, 2, 1, 2, 2, 2, 1, 1, 1);
}

int[] scale(String name, int num, int i1, int i2, int i3, int i4, int i5, int i6, int i7) {
	int b = noteToIndex(name, num);
	return new int[]{
		b,
		b + i1,
		b + i1 + i2,
		b + i1 + i2 + i3,
		b + i1 + i2 + i3 + i4,
		b + i1 + i2 + i3 + i4 + i5,
		b + i1 + i2 + i3 + i4 + i5 + i6,
		b + i1 + i2 + i3 + i4 + i5 + i6 + i7,
	};
}
int[] scale(String name, int num, int i1, int i2, int i3, int i4, int i5, int i6, int i7, int i8) {
	int b = noteToIndex(name, num);
	return new int[]{
		b,
		b + i1,
		b + i1 + i2,
		b + i1 + i2 + i3,
		b + i1 + i2 + i3 + i4,
		b + i1 + i2 + i3 + i4 + i5,
		b + i1 + i2 + i3 + i4 + i5 + i6,
		b + i1 + i2 + i3 + i4 + i5 + i6 + i7,
		b + i1 + i2 + i3 + i4 + i5 + i6 + i7 + i8,
	};
}
int[] scale(String name, int num, int i1, int i2, int i3, int i4, int i5, int i6) {
	int b = noteToIndex(name, num);
	return new int[]{
		b,
		b + i1,
		b + i1 + i2,
		b + i1 + i2 + i3,
		b + i1 + i2 + i3 + i4,
		b + i1 + i2 + i3 + i4 + i5,
		b + i1 + i2 + i3 + i4 + i5 + i6,
	};
}
