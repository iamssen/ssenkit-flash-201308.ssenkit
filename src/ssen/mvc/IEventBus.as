package ssen.mvc {
import flash.events.Event;
import flash.events.IEventDispatcher;

import ssen.common.IDisposable;

public interface IEventBus extends IDisposable {
	// ---------------------------------------
	// listener
	// ---------------------------------------
	function get eventDispatcher():IEventDispatcher;

	function addEventListener(type:String, listener:Function):void;

	function removeEventListener(type:String, listener:Function):void;

	function removeEventListeners(type:String):void;

	// ---------------------------------------
	// dispatcher
	// ---------------------------------------
	function dispatchEvent(event:Event, to:String="self", penetrate:Boolean=false):void;

	// ---------------------------------------
	// chain
	// ---------------------------------------
	function get parentEventBus():IEventBus;

	function createChildEventBus():IEventBus;
}
}
