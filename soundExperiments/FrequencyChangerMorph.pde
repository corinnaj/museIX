
class FrequencyChangerShape extends CircleShape {
	float MIN_LOG_FREQUENCY = log(20);
	float MAX_LOG_FREQUENCY = log(8000);
	float WIDTH_FREQUENCY = 10;

	boolean showFrequency = false;
	float logFrequency = log(440);

	FrequencyChangerShape() {
		super(60);
	}

	void setLogFrequency(float f) {
		logFrequency = constrain(f, MIN_LOG_FREQUENCY, MAX_LOG_FREQUENCY);
	}

	float getLogFrequency() {
		return logFrequency;
	}

	@Override
	void draw(Style style) {
		super.draw(style);

		if (showFrequency) {
			float width = (WIDTH_FREQUENCY + radius) * 2;
			arc(0, 0, width, width, 0, map(logFrequency, MIN_LOG_FREQUENCY, MAX_LOG_FREQUENCY, 0, 2 * PI));
		}
	}
}

abstract class FrequencyChangerNode extends AudioNode {
	boolean active = false;

	PVector lastMousePos = new PVector();

	Glide frequency;

	FrequencyChangerNode(Glide frequency) {
		super(new FrequencyChangerShape(), new Style());

		this.frequency = frequency;
	}

	@Override
	void mouseLongPress(MouseEvent event) {
		super.mouseLongPress(event);

		cancelMoving();
		active = true;
		grabMouseFocus();
		lastMousePos.set(event.x, event.y);
		((FrequencyChangerShape) shape).showFrequency = true;
		style.fillColor(#0000ff);
	}

	@Override
	void mouseMove(MouseEvent event) {
		super.mouseMove(event);

		if (!active)
			return;

		FrequencyChangerShape freqShape = (FrequencyChangerShape) shape;

		freqShape.setLogFrequency(freqShape.getLogFrequency() + (event.y - lastMousePos.y) * 0.01);
		frequency.setValue(exp(freqShape.getLogFrequency()));
		lastMousePos.set(event.x, event.y);
	}

	@Override
	void mouseRelease(MouseEvent event) {
		super.mouseRelease(event);

		active = false;
		releaseMouseFocus();
		((FrequencyChangerShape) shape).showFrequency = false;
		style.fillColor(#000099);
	}
}

abstract class AudioNode extends Node {
	AudioNode(Shape shape, Style style) {
		super(shape, style, new Style());
	}

	abstract UGen getOutput();
	abstract void addInput(AudioNode node);
}

class WaveGeneratorNode extends FrequencyChangerNode {
	UGen wavePlayer;

	WaveGeneratorNode(AudioContext ac) {
		super(new Glide(ac, 440));
		wavePlayer = new WavePlayer(ac, frequency, Buffer.SINE);
	}

	@Override
	void addInput(AudioNode node) {
		// TODO
	}

	@Override
	UGen getOutput() {
		return wavePlayer;
	}
}
