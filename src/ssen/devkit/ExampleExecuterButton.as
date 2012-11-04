package ssen.devkit {
import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.getQualifiedClassName;

import spark.components.Button;

public class ExampleExecuterButton extends Button {
	private var _method:String;

	public var target:Object;

	public function get method():String {
		return _method;
	}

	public function set method(value:String):void {
		_method=value;
		label=value;
	}

	public function ExampleExecuterButton() {
		addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
	}

	private function addedToStageHandler(event:Event):void {
		removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		addEventListener(MouseEvent.CLICK, executeMethod);
		addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
	}

	private function removedFromStageHandler(event:Event):void {
		removeEventListener(MouseEvent.CLICK, executeMethod);
		removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);

		target=null;
		method=null;
	}

	private function executeMethod(event:MouseEvent):void {
		trace("--------------------------------------------------------------------");
		trace("---- " + getQualifiedClassName(target) + "#" + method + "()");
		trace("--------------------------------------------------------------------");
		target[method]();
	}
}
}
