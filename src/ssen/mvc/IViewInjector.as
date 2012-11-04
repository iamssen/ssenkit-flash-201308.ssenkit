package ssen.mvc {
import ssen.common.IDisposable;

public interface IViewInjector extends IDisposable {
	function mapView(viewClass:Class, mediatorClass:Class=null):void;

	function unmapView(viewClass:Class):void;

	function hasMapping(view:*):Boolean;

	function injectInto(view:Object):void;
}
}
