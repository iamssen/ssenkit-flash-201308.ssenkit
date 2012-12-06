package ssen.displaykit.form {
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;

import spark.components.TextInput;
import spark.events.TextOperationEvent;

public class TextInputControl extends UIComponentControl implements FormControl {
	protected var component:TextInput;
	
	public var restrict:String;
	public var maxChars:int;
	
	public function TextInputControl(component:TextInput) {
		this.component=component;
		super(component);
	}
	
	public function get textInput():TextInput {
		return component;
	}
	
	override protected function doStart():void {
		component.restrict=restrict;
		component.maxChars=maxChars;
		
		startTypeControl();
		startValueControl();
	}
	
	override protected function doStop():void {
		stopTypeControl();
		stopValueControl();
	}
	
	override public function dispose():void {
		if (state !== FormControlState.NONE) {
			stopTypeControl();
			stopValueControl();
		}
		
		super.dispose();
		
		component=null;
	}
	
	//=========================================================
	// 
	//=========================================================
	private function startValueControl():void {
		component.addEventListener(TextOperationEvent.CHANGE, textChangeForValueControl, false, 0, true);
	}
	
	private function stopValueControl():void {
		component.removeEventListener(TextOperationEvent.CHANGE, textChangeForValueControl);
	}
	
	private function textChangeForValueControl(event:TextOperationEvent):void {
		if (!component.focusEnabled && _cache === component.text) {
			_cache=component.text;
			dispatchFormValueChange();
		}
	}
	
	override protected function clearValue():void {
		component.text="";
		_cache="";
	}
	
	//=========================================================
	// type control
	//=========================================================
	private var _cache:String;
	
	private function startTypeControl():void {
		_cache=component.text;
		
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
		component.text=_cache;
	}
	
	private function commitValue():void {
		_cache=component.text;
		dispatchFormValueChange();
	}


}
}
