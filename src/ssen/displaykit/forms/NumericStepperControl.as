package ssen.displaykit.forms {
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;

import spark.components.NumericStepper;

public class NumericStepperControl extends UIComponentControl {
	private var component:NumericStepper;
	
	public var minimum:int;
	public var maximum:int;
	public var maxChars:int;
	
	public function NumericStepperControl(component:NumericStepper) {
		this.component=component;
		super(component);
	}
	
	public function get numericStepper():NumericStepper {
		return component;
	}
	
	override protected function doStart():void {
		component.minimum=minimum;
		component.maximum=maximum;
		component.maxChars=maxChars;
		
		startValueControl();
		startTypeControl();
	}
	
	override protected function doStop():void {
		stopValueControl();
		stopTypeControl();
	}
	
	override public function dispose():void {
		if (state !== FormControlState.NONE) {
			stopValueControl();
			stopTypeControl();
		}
		
		super.dispose();
		
		component=null;
	}
	
	//=========================================================
	// 
	//=========================================================
	private function startValueControl():void {
		component.addEventListener(Event.CHANGE, indexChange, false, 0, true);
	}
	
	private function stopValueControl():void {
		component.removeEventListener(Event.CHANGE, indexChange);
	}
	
	private function indexChange(event:Event):void {
		if (!component.focusEnabled && _cache === component.value) {
			_cache=component.value;
			dispatchFormValueChange();
		}
		
		dispatchFormValueChange();
	}
	
	override protected function clearValue():void {
		component.value=0;
		_cache=0;
	}
	
	//=========================================================
	// type control
	//=========================================================
	private var _cache:Number;
	
	private function startTypeControl():void {
		_cache=component.value;
		
		component.addEventListener(FocusEvent.FOCUS_OUT, focusOutForTypeControl, false, 0, true);
		component.addEventListener(KeyboardEvent.KEY_DOWN, keyUpForTypeControl, false, 0, true);
	}
	
	private function stopTypeControl():void {
		component.removeEventListener(FocusEvent.FOCUS_OUT, focusOutForTypeControl);
		component.removeEventListener(KeyboardEvent.KEY_DOWN, keyUpForTypeControl);
	}
	
	private function focusOutForTypeControl(event:FocusEvent):void {
		commitValue();
	}
	
	private function keyUpForTypeControl(event:KeyboardEvent):void {
		switch (event.keyCode) {
			case Keyboard.ENTER:
				commitValue();
				break;
			case Keyboard.ESCAPE:
				restoreValue();
				break;
		}
	}
	
	private function restoreValue():void {
		component.value=_cache;
	}
	
	private function commitValue():void {
		_cache=component.value;
		dispatchFormValueChange();
	}
}
}
