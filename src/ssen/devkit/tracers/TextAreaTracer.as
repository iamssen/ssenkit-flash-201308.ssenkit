package ssen.devkit.tracers {
import flash.utils.getQualifiedClassName;

import spark.components.TextArea;

import ssen.common.StringUtils;

/** Text Area 에 출력 */
public class TextAreaTracer extends TextArea implements ILogTracer {
	public function log(msg:Array, hostString:String, dateString:String):void {
		var f:int=-1;
		var fmax:int=msg.length;

		var clazz:String;

		while (++f < fmax) {
			clazz=getQualifiedClassName(msg[f]);
			if (clazz == "Object" || clazz == "flash.utils::Dictionary") {
				msg[f]=JSON.stringify(msg[f]);
			}
		}

		printLog(msg.join(" "), hostString, dateString);
	}

	protected function printLog(msg:String, hostString:String, dateString:String):void {
		appendText(StringUtils.formatToString('@{0}<{1}> : {2}', hostString, dateString, msg) + "\n");
	}

	/** @inheritDoc */
	public function print(str:String):void {
		appendText(str + "\n");
	}
}
}
