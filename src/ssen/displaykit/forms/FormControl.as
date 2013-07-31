package ssen.displaykit.forms {
import flash.events.IEventDispatcher;

import mx.managers.IFocusManagerComponent;

import ssen.common.IDisposable;

public interface FormControl extends IEventDispatcher, IDisposable {
	//=========================================================
	// tab control
	//=========================================================
	function get tabComponent():IFocusManagerComponent;
	function get nextTabControl():FormControl;
	function set nextTabControl(value:FormControl):void;
	function get prevTabControl():FormControl;
	function set prevTabControl(value:FormControl):void;
	function get nextTabComponentFunction():Function;
	function set nextTabComponentFunction(value:Function):void;
	function get prevTabComponentFunction():Function;
	function set prevTabComponentFunction(value:Function):void;
	
	//=========================================================
	// 
	//=========================================================
	function start():void;
	function stop():void;
	
	//=========================================================
	// 
	//=========================================================
	function listenFormControl(control:FormControl, listenStateChanged:Boolean=true, listenValueChanged:Boolean=true):void;
	function unlistenFormControl(control:FormControl):void;
	function get controlsChanged():Function;
	function set controlsChanged(value:Function):void;
	function get stateChanged():Function;
	function set stateChanged(value:Function):void;
	function get valueChanged():Function;
	function set valueChanged(value:Function):void;
	
	//=========================================================
	// 
	//=========================================================
	function get state():FormControlState;
	
	function get enabled():Boolean;
	function set enabled(value:Boolean):void;
	function get errorString():String;
	function set errorString(value:String):void;
}
}
