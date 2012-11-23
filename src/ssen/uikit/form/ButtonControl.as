package ssen.uikit.form {
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.ui.Keyboard;

import spark.components.Button;

public class ButtonControl extends UIComponentControl {
	private var component:Button;
	
	public function get button():Button {
		return component;
	}
	
	public function ButtonControl(component:Button) {
		this.component=component;
		super(component);
	}
	
	override protected function doStart():void {
		startKeyControl();
		component.buttonMode=true;
	}
	
	override protected function doStop():void {
		stopKeyControl();
		component.buttonMode=false;
	}
	
	override public function dispose():void {
		if (state !== FormControlState.NONE) {
			stopKeyControl();
		}
		
		super.dispose();
		
		component=null;
	}
	
	//=========================================================
	// 
	//=========================================================
	private function startKeyControl():void {
		component.addEventListener(KeyboardEvent.KEY_UP, keyUp, false, 0, true);
	}
	
	private function keyUp(event:KeyboardEvent):void {
		if (event.keyCode == Keyboard.ENTER) {
			component.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
		}
	}
	
	private function stopKeyControl():void {
		component.removeEventListener(KeyboardEvent.KEY_UP, keyUp);
	}
}
}
