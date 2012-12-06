package ssen.displaykit.form {
import ssen.common.StringUtils;

public class FormControlState {
	public static const NONE:FormControlState=new FormControlState("none");
	public static const NORMAL:FormControlState=new FormControlState("normal");
	public static const ERROR:FormControlState=new FormControlState("error");
	public static const DISABLED:FormControlState=new FormControlState("disabled");
	
	private var _name:String;
	
	public function FormControlState(name:String) {
		_name=name;
	}
	
	public function get name():String {
		return _name;
	}
	
	public static function checkState(state:FormControlState, ... controls):Boolean {
		var f:int=controls.length;
		var control:FormControl;
		
		while (--f >= 0) {
			control=controls[f];
			
			if (control.state !== state) {
				return false;
			}
		}
		
		return true;
	}
	
	public function toString():String {
		return StringUtils.formatToString('[FormControlState name="{0}"]', name);
	}

}
}
