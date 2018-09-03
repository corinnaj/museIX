
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

		// FIXME make a decision here
		if (true || showFrequency) {
			float width = (WIDTH_FREQUENCY + radius) * 2;
			arc(0, 0, width, width, 0, map(logFrequency, MIN_LOG_FREQUENCY, MAX_LOG_FREQUENCY, 0, 2 * PI));
		}
	}
}

abstract class FrequencyChangerNode extends AudioNode {
	static final color ACTIVE_COLOR = #5D8C9C;
	static final color INACTIVE_COLOR = #517F8F;
	boolean active = false;

	PVector lastMousePos = new PVector();

	Glide frequency;

	FrequencyChangerNode(Glide frequency) {
		super(new FrequencyChangerShape(), new Style());

		this.frequency = frequency;
		updateColor();
	}

	@Override
	void mouseLongPress(MouseEvent event) {
		super.mouseLongPress(event);

		cancelMoving();
		active = true;
		grabMouseFocus();
		lastMousePos.set(event.x, event.y);
		((FrequencyChangerShape) shape).showFrequency = true;
		updateColor();
	}

	void updateColor() {
		style.fillColor(active ? ACTIVE_COLOR : INACTIVE_COLOR);
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
		updateColor();
	}
}

class WaveGeneratorNode extends FrequencyChangerNode {
	WavePlayer wavePlayer;
	Gain gain;
	Shape icon;

	WaveGeneratorNode(AudioContext ac) {
		super(new Glide(ac, 440));
		wavePlayer = new WavePlayer(ac, frequency, Buffer.SINE);
		gain = new Gain(ac, 1, 0.3);
		gain.addInput(wavePlayer);
		icon = new SVGShape(loadShape("icons/sine-wave.svg"));
	}

	@Override
	void addInput(AudioNode node) {
		cutAllIncomingConnections();

		wavePlayer.setFrequency(node.getOutput());
	}

	@Override
	void removeInput(AudioNode node) {
		wavePlayer.setFrequency(frequency);
	}

	@Override
	UGen getOutput() {
		return gain;
	}

	@Override
	void draw() {
		super.draw();
		shape.translateToCenterOfRotation(-1);
		icon.draw(style);
		shape.translateToCenterOfRotation(1);
	}

	@Override boolean acceptsIncomingConnection(Node node) {
		return ((AudioNode) node).getOutputType() == AudioNodeOutputType.FREQUENCIES;
	}

	@Override
	AudioNodeOutputType getOutputType() {
		return AudioNodeOutputType.WAVES;
	}
}
