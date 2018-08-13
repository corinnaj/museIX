
class WaveformShape extends RectangleShape {
	static final float EXTRA_SCALING = 2;
	UGen bead;

	WaveformShape(UGen bead, float width, float height) {
		super(width, height);
		this.bead = bead;
	}

	void draw(Style style) {
		style.apply();
		assert(bead.getOuts() == 2);

		float[] bufferL = bead.getOutBuffer(0);
		float[] bufferR = bead.getOutBuffer(1);

		pushMatrix();
		translate(0, height / 2);
		for (int i = 0; i < width; i++) {
			int index = i * bufferL.length / int(width);
			float a = map((bufferL[index] + bufferR[index]) * EXTRA_SCALING, -1, 1, -height / 2, height / 2);
			line(i, 0, i, a);
		}
		popMatrix();
	}
}

