package ssen.devkit.tracers {
import flash.external.ExternalInterface;

import ssen.common.StringUtils;

/** Javascript Console 이 지원되는 웹브라우저에서 로그를 본다 */
public class JavascriptConsoleTracer extends ConsoleTracer {

	override protected function printLog(msg:String, hostString:String, dateString:String):void {
		if (ExternalInterface.available) {
			ExternalInterface.call("console.log", StringUtils.formatToString('@{0}<{1}> : {2}', hostString, dateString, msg));
		}
	}

	override public function print(str:String):void {
		if (ExternalInterface.available) {
			ExternalInterface.call("console.log", str);
		}
	}

}
}
