package ssen.devkit {
import mx.binding.utils.BindingUtils;
import mx.core.IMXMLObject;

import ssen.devkit.tracers.ILogTracer;

[DefaultProperty("capture")]

/** Binding 문자열로 지정된 요소들이 변경될때마다 Log 를 남긴다 */
public class Watch implements IMXMLObject {
	/** 캡쳐 대상이 될 Bindable 문장 */
	[Bindable]
	public var capture:String;

	/** @private */
	public function initialized(document:Object, id:String):void {
		BindingUtils.bindSetter(setter, this, "capture");
	}

	private function setter(msg:String):void {
		var tracers:Vector.<ILogTracer>=new Vector.<ILogTracer>;

		var f:int=-1;
		var max:int=tracers.length;
		while (++f < max) {
			tracers[f].print(msg);
		}
	}
}
}
