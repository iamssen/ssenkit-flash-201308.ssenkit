package ssen.devkit.tracers {
import flash.utils.getQualifiedClassName;

import ssen.common.StringUtils;

/** Console 에 기본 trace 를 사용해서 출력 */
public class ConsoleTracer implements ILogTracer {
	/** @inheritDoc */
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

	/** @private */
	protected function printLog(msg:String, hostString:String, dateString:String):void {
		trace(StringUtils.formatToString('@{0}<{1}> : {2}', hostString, dateString, msg));
	}

	/** @inheritDoc */
	public function print(str:String):void {
		trace(str);
	}
}
}
