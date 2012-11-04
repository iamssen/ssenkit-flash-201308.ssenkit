package ssen.mvc {
import flash.display.Stage;
import flash.events.IEventDispatcher;

public interface IContextView extends IEventDispatcher {
	function initialContext(parentContext:IContext=null):void;

	function get contextInitialized():Boolean;

	function get stage():Stage;
}
}
