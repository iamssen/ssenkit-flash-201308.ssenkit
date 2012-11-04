package ssen.devkit {
import flash.system.Capabilities;

import mx.formatters.DateFormatter;
import ssen.devkit.tracers.ILogTracer;


public class Log {
	internal static var formatter:DateFormatter;

	private static var _tracers:Vector.<ILogTracer>;

	private static function get tracers():Vector.<ILogTracer> {
		if (_tracers === null) {
			_tracers=new Vector.<ILogTracer>;
		}

		return _tracers;
	}

	private static function get enabled():Boolean {
		return Capabilities.isDebugger;
	}

	public static function print(host:Object, ... msg:Array):void {
		if (!enabled) {
			return;
		}

		if (tracers.length === 0) {
			return;
		}

		if (!formatter) {
			formatter=new DateFormatter;
			formatter.formatString="LL:NN:SS";
		}
		var hostString:String=getObjectClassName(host);
		var dateString:String=formatter.format(new Date);

		var f:int=tracers.length;
		while (--f >= 0) {
			tracers[f].log(msg, hostString, dateString);
		}
	}

	public static function addTracer(tracer:ILogTracer):void {
		if (!enabled) {
			return;
		}

		if (tracers.indexOf(tracer) === -1) {
			tracers.push(tracer);
		}
	}

	public static function removeTracer(tracer:ILogTracer):void {
		if (!enabled) {
			return;
		}

		var i:int=tracers.indexOf(tracer);
		if (i > -1) {
			tracers.splice(i, 1);
		}
	}
}
}
