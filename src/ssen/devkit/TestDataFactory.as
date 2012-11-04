package ssen.devkit {
import gs.easing.Back;
import gs.easing.Bounce;
import gs.easing.Circ;
import gs.easing.Cubic;
import gs.easing.Elastic;
import gs.easing.Expo;
import gs.easing.Linear;
import gs.easing.Quad;
import gs.easing.Quart;
import gs.easing.Quint;
import gs.easing.Sine;

import ssen.common.MathUtils;

/** 테스트용으로 사용할 데이터를 만든다 */
public class TestDataFactory {

	/** 스크롤 테스트에 사용할 장문의 글을 만든다 */
	public static function getLongText(minLines:int=10, maxLines:int=500, minWords:int=10, maxWords:int=300):String {
		var str:String="START\n";
		var rand:int=MathUtils.rand(minLines, maxLines);
		var f:int=-1;
		var a:String;
		var i:int;
		while (++f < rand) {
			i=MathUtils.rand(minWords, maxWords);
			a="";
			while (--i >= 0) {
				a+="A";
			}
			str+=f + a + "X\n";
		}
		str+="END";
		return str;
	}

	public static function getRandomEaseFunction():Function {
		var eases:Vector.<Function>=new <Function>[Linear.easeNone, Back.easeIn, Back.easeInOut, Back.easeOut, Bounce.easeIn,
												   Bounce.easeInOut, Bounce.easeOut, Circ.easeIn, Circ.easeInOut, Circ.easeOut,
												   Cubic.easeIn, Cubic.easeInOut, Cubic.easeOut, Elastic.easeIn, Elastic.easeInOut,
												   Elastic.easeOut, Expo.easeIn, Expo.easeInOut, Expo.easeOut, Quad.easeIn, Quad.easeInOut,
												   Quad.easeOut, Quart.easeIn, Quart.easeInOut, Quart.easeOut, Quint.easeIn,
												   Quint.easeInOut, Quint.easeOut, Sine.easeIn, Sine.easeInOut, Sine.easeOut];
		return eases[MathUtils.rand(0, eases.length - 1)];
	}
}
}
