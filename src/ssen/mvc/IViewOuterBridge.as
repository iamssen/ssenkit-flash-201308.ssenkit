package ssen.mvc {
import ssen.common.IDisposable;

public interface IViewOuterBridge extends IDisposable {
	function ready(view:Object):void;
}
}
