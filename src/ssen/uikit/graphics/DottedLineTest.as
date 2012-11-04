package ssen.uikit.graphics {
import spark.core.SpriteVisualElement;

public class DottedLineTest extends SpriteVisualElement {
	public function DottedLineTest() {
		addChild(DottedLine.create(10, 10, 300, 10, 0x000000, 2, 4, 2));
	}
}
}
