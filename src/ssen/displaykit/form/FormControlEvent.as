package ssen.displaykit.form {
import flash.events.Event;

public class FormControlEvent extends Event {
	public static const FORM_VALUE_CHANGED:String="formValueChanged";
	public static const FORM_STATE_CHANGED:String="formStateChanged";
	private var _control:FormControl;
	
	public function FormControlEvent(type:String, control:FormControl=null) {
		super(type);
		
		_control=control;
	}
	
	public function get control():FormControl {
		return _control;
	}
	
	override public function clone():Event {
		return new FormControlEvent(type, control);
	}
	
	override public function toString():String {
		return formatToString("FormControlEvent", "type", "control");
	}
}
}
