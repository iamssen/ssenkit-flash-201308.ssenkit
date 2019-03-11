package ssen.drawingkit {
import flash.geom.Rectangle;

import ssen.common.StringUtils;

public class Rect {
	public var x:int;
	public var y:int;
	public var width:int;
	public var height:int;

	public function toString():String {
		return StringUtils.formatToString('[Rect x="{0}" y="{1}" width="{2}" height="{3}"]', x, y, width, height);
	}

	public function toRectangle():Rectangle {
		return new Rectangle(x, y, width, height);
	}
}
}
