package ssen.devkit.tracers {
import com.demonsters.debugger.MonsterDebugger;

import ssen.common.StringUtils;

/** 몬스터 디버거를 활용 */
public class MonsterDebuggerTracer extends ConsoleTracer {
	/** 레벨별 색상 */
	public var colors:Vector.<uint>=Vector.<uint>([0xc4baba, 0x393333, 0xd60000, 0x1700c6]);
	private var colorPoint:int=0;

	override protected function printLog(msg:String, hostString:String, dateString:String):void {
		MonsterDebugger.trace(hostString, StringUtils.formatToString('<{1}> : {2}', dateString, msg), "", "",
							  colors[colorPoint % colors.length]);
		colorPoint++;
	}

	override public function print(str:String):void {
		var color:uint=colors[colorPoint % colors.length];
		MonsterDebugger.trace("", str, "", "", color);
		colorPoint++;
	}
}
}
