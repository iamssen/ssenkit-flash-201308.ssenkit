package ssen.devkit {

import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Shape;

import ssen.common.MathUtils;

/** 테스트용으로 사용할 디스플레이를 만든다 */
public class TestDisplayObjectFactory {

	/** 스크롤 테스트에 사용할 큰 박스를 만든다 */
	public static function getLineBox(minWidth:int=600, maxWidth:int=4500, minHeight:int=600, maxHeight:int=4500):DisplayObject {
		var s:Shape=new Shape();
		var g:Graphics=s.graphics;
		var w:int=MathUtils.rand(minWidth, maxWidth);
		var h:int=MathUtils.rand(minHeight, maxHeight);
		g.beginFill(MathUtils.rand(0x000000, 0xffffff));
		g.drawRect(0, 0, w, h);
		g.endFill();
		g.beginFill(0xC5D5FC);
		g.drawRect(0, 0, w, 10);
		g.drawRect(0, 10, 10, h - 20);
		g.drawRect(w - 10, 10, 10, h - 20);
		g.drawRect(0, h - 10, w, 10);
		g.endFill();

		return s;
	}
}
}
