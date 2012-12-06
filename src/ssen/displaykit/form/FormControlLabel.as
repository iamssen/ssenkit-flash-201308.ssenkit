package ssen.displaykit.form {

import flash.events.Event;

import spark.components.supportClasses.SkinnableComponent;

[SkinState("none")]
[SkinState("normal")]
[SkinState("error")]
[SkinState("disabled")]

public class FormControlLabel extends SkinnableComponent {
	
	[Bindable]
	public var data:Object;
	
	[Bindable]
	public var required:Boolean;
	
	private var _formControl:FormControl;
	
	[Bindable(event="formControlChanged")]
	public function get formControl():FormControl {
		return _formControl;
	}
	
	public function set formControl(value:FormControl):void {
		if (_formControl !== null) {
			_formControl.removeEventListener(FormControlEvent.FORM_STATE_CHANGED, formStateChanged);
		}
		
		if (value !== null) {
			_formControl=value;
			_formControl.addEventListener(FormControlEvent.FORM_STATE_CHANGED, formStateChanged, false, 0, true);
		}
		
		invalidateSkinState();
		
		dispatchEvent(new Event("formControlChanged"));
	}
	
	private function formStateChanged(event:FormControlEvent):void {
		invalidateSkinState();
	}
	
	/** @private */
	override protected function getCurrentSkinState():String {
		if (_formControl === null) {
			return "none";
		}
		return _formControl.state.name;
	}
}
}
