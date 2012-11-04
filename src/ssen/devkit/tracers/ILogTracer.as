package ssen.devkit.tracers {

/** Log Tracer */
public interface ILogTracer {
	function log(msg:Array, hostString:String, dateString:String):void;
	function print(str:String):void;
}
}
