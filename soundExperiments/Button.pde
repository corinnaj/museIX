
interface ButtonMorphListener {
	void buttonPressed();
}

class ButtonMorph extends Morph {
	ButtonMorphListener listener;

	ButtonMorph(Shape shape, Style style, ButtonMorphListener listener) {
		super(shape, style);
		this.listener = listener;
	}

	@Override void mousePress(MorphMouseEvent event) {
		listener.buttonPressed();
	}
}

class IconButtonMorph extends ButtonMorph {
	IconButtonMorph(String iconName, color col, ButtonMorphListener listener) {
		super(new SVGShape(loadShape("icons/" + iconName +  ".svg"), 0.3),
				new Style()
					.fillColor(col)
					.hasStroke(false),
				listener);
	}
}
