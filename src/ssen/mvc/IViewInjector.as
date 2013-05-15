package ssen.mvc {
import ssen.common.IDisposable;

public interface IViewInjector extends IDisposable {
	function mapView(viewClass:Class, mediatorClass:Class=null, global:Boolean = false):void;

	function unmapView(viewClass:Class, global:Boolean = false):void;

	function hasMapping(view:*, global:Boolean = false):Boolean;

	function injectInto(view:Object):void;
}
}
