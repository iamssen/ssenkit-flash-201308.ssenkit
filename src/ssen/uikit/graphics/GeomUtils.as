package ssen.uikit.graphics {
import flash.display.DisplayObject;
import flash.geom.Rectangle;

/** 기하적 연산을 도와주는 util class */
public class GeomUtils {
	/** display object 들의 rectangle bounds 를 합쳐서 새로운 bounds 를 만들어준다 */
	public static function getDisplayObjectsBounds(displayObjects:Vector.<DisplayObject>):Rectangle {
		var f:int=0;
		var fmax:int=displayObjects.length;
		var display:DisplayObject=displayObjects[0];
		var rect:Rectangle=new Rectangle(display.x, display.y, display.width, display.height);
		while (++f < fmax) {
			display=displayObjects[f];
			rect=rect.union(new Rectangle(display.x, display.y, display.width, display.height));
		}

		return rect;
	}

	/** 기준이 되는 space 를 넘어가는 경우 resize 되어야 하는 비율을 알려준다 */
	public static function getResizeRatio(bounds:Rectangle, targetCoordinateSpace:Rectangle):Number {
		var hratio:Number=(bounds.width > targetCoordinateSpace.width) ? targetCoordinateSpace.width / bounds.width : 1;
		var vratio:Number=(bounds.height > targetCoordinateSpace.height) ? targetCoordinateSpace.height / bounds.height : 1;

		return (hratio > vratio) ? vratio : hratio;
	}
}
}
