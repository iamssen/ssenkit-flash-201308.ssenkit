package ssen.displaykit.form {
import flash.display.InteractiveObject;
import flash.events.FocusEvent;

import mx.managers.IFocusManager;
import mx.managers.IFocusManagerComponent;

import ssen.common.IDisposable;

public class UIComponentTabControlSupport implements IDisposable {
	public var control:FormControl;
	public var component:InteractiveObject;
	public var focusManager:IFocusManager;
	public var nextTabControl:FormControl;
	public var prevTabControl:FormControl;
	public var nextTabComponentFunction:Function;
	public var prevTabComponentFunction:Function;
	
	public function start():void {
		if (control === null || component === null || focusManager === null) {
			throw new Error("필수 입력 정보들이 입력되지 않았음 control, component, focusManager");
		}
		
		component.addEventListener(FocusEvent.KEY_FOCUS_CHANGE, keyFocusChange, false, 0, true);
		component.addEventListener(FocusEvent.FOCUS_IN, focusIn, false, 0, true);
	}
	
	public function stop():void {
		component.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE, keyFocusChange);
		component.removeEventListener(FocusEvent.FOCUS_IN, focusIn);
	}
	
	public function dispose():void {
		stop();
		control=null;
		component=null;
		focusManager=null;
		nextTabControl=null;
		nextTabComponentFunction=null;
		prevTabControl=null;
		prevTabComponentFunction=null;
	}
	
	protected function getNextComponent(shiftKey:Boolean):IFocusManagerComponent {
		var next:IFocusManagerComponent;
		
		if (shiftKey) {
			next=(prevTabComponentFunction !== null) ? prevTabComponentFunction() : prevTabControl.tabComponent;
		} else {
			next=(nextTabComponentFunction !== null) ? nextTabComponentFunction() : nextTabControl.tabComponent;
		}
		
		return next;
	}
	
	protected function keyFocusChange(event:FocusEvent):void {
		var next:IFocusManagerComponent=getNextComponent(event.shiftKey);
		
		if (next !== null) {
			event.preventDefault();
			event.stopImmediatePropagation();
			event.stopPropagation();
			
			focusManager.setFocus(next);
		}
	}
	
	protected function focusIn(event:FocusEvent):void {
		if (control.state === FormControlState.DISABLED) {
			var next:IFocusManagerComponent=getNextComponent(event.shiftKey);
			
			if (next !== null) {
				event.preventDefault();
				event.stopImmediatePropagation();
				event.stopPropagation();
				
				focusManager.setFocus(next);
			}
		}
	}
}
}
