package ssen.devkit {
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.utils.getQualifiedClassName;

import mx.core.IVisualElement;

public class VisualElementFactory extends EventDispatcher {
	private var _cls:Class;

	[Bindable]
	public var label:String;

	[Bindable(event="clsChanged")]
	public function get cls():Class {
		return _cls;
	}

	public function set cls(value:Class):void {
		_cls=value;
		label=getQualifiedClassName(value);
		dispatchEvent(new Event("clsChanged"));
	}

	public function newInstance():IVisualElement {
		var el:IVisualElement=new _cls();
		el.percentWidth=100;
		el.percentHeight=100;
		return el;
	}
}
}
