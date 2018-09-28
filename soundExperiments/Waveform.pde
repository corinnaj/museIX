
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
		float prev = 0;
		for (int i = 0; i < width; i++) {
			int index = i * bufferL.length / int(width);
			float a = map((bufferL[index] + bufferR[index]) * EXTRA_SCALING, -1, 1, -height / 2, height / 2);
			// line(i, 0, i, a);
			line(i - 1, prev, i, a);
			prev = a;
		}
		popMatrix();
	}
}

void drawWaveformLine(PVector start, PVector end, UGen bead) {
	// line(start.x, start.y, end.x, end.y);
	float length = start.dist(end);
	pushMatrix();
	translate(start.x, start.y);
	rotate(end.sub(start).heading());

	if (bead == null || bead.getOuts() < 1) {
		line(0, 0, length, 0);
		popMatrix();
		return;
	}

	float height = 100;
	float[] buffer = bead.getOutBuffer(0);
	float prev = 0;
	float scale = length / buffer.length;
	for (int i = 0; i < buffer.length; i++) {
		float a = map((buffer[i]) * 2, -1, 1, -height / 2, height / 2);
		line((i - 1) * scale, prev, i * scale, a);
		prev = a;
	}

	popMatrix();
}
