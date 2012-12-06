package ssen.displaykit.form {
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.geom.Rectangle;

import mx.core.UIComponent;
import mx.managers.IFocusManagerComponent;

import ssen.common.StringUtils;

[Event(name="formStateChanged", type="ssen.displaykit.form.FormControlEvent")]
[Event(name="formValueChanged", type="ssen.displaykit.form.FormControlEvent")]

public class UIComponentControl extends EventDispatcher implements FormControl {
	
	protected var tabControl:UIComponentTabControlSupport;
	
	private var _enabled:Boolean;
	private var _errorString:String;
	private var _component:UIComponent;
	private var _state:FormControlState;
	private var _stateChanged:Function;
	private var _valueChanged:Function;
	private var _controlsChanged:Function;
	private var _listenControls:Vector.<ListenControl>;
	
	public function UIComponentControl(component:UIComponent) {
		_component=component;
		init();
	}
	
	private function init():void {
		tabControl=new UIComponentTabControlSupport;
		
		_listenControls=new Vector.<ListenControl>;
		
		_state=FormControlState.NONE;
		
		_enabled=_component.enabled;
		_errorString=_component.errorString;
		
		_component.enabled=false;
		_component.errorString=null;
	}
	
	//=========================================================
	// 
	//=========================================================
	/** @inheritDoc */
	public function start():void {
		if (_state === FormControlState.NONE) {
			startTabControl();
			startEnabledControl();
			startErrorControl();
			startControlListener();
			
			doStart();
			
			refreshState();
		}
	}
	
	/** @inheritDoc */
	public function stop():void {
		if (_state !== FormControlState.NONE) {
			stopTabControl();
			stopEnabledControl();
			stopErrorControl();
			stopControlListener();
			
			doStop();
			
			_state=FormControlState.NONE;
			dispatchFormStateChange();
		}
	}
	
	protected function doStart():void {
	}
	
	protected function doStop():void {
	}
	
	/** @inheritDoc */
	public function dispose():void {
		if (_state !== FormControlState.NONE) {
			stopTabControl();
			stopEnabledControl();
			stopErrorControl();
			stopControlListener();
		}
		
		tabControl.dispose();
		
		tabControl=null;
		_component=null;
		
		_listenControls=null;
		
		_controlsChanged=null;
		_valueChanged=null;
		_stateChanged=null;
	}
	
	//=========================================================
	// tab control
	//=========================================================
	protected function startTabControl():void {
		tabControl.control=this;
		tabControl.focusManager=_component.focusManager;
		tabControl.component=_component;
		tabControl.start();
	}
	
	protected function stopTabControl():void {
		if (tabControl) {
			tabControl.stop();
		}
	}
	
	//=========================================================
	// listen controls
	//=========================================================
	public function listenFormControl(control:FormControl, listenStateChanged:Boolean=true, listenValueChanged:Boolean=true):void {
		var listenControl:ListenControl;
		var finded:Boolean=false;
		
		if (_listenControls.length > 0) {
			var f:int=_listenControls.length;
			while (--f >= 0) {
				listenControl=_listenControls[f];
				
				if (listenControl.control === control) {
					listenControl.listenStateChanged=listenStateChanged;
					listenControl.listenValueChanged=listenValueChanged;
					
					if (_state !== FormControlState.NONE) {
						listenControl.startListener(controlChangedHandler);
					}
					
					finded=true;
					
					break;
				}
			}
		}
		
		if (!finded) {
			listenControl=new ListenControl;
			listenControl.control=control;
			listenControl.listenStateChanged=listenStateChanged;
			listenControl.listenValueChanged=listenValueChanged;
			
			_listenControls.push(listenControl);
		}
		
		if (_state !== FormControlState.NONE) {
			listenControl.startListener(controlChangedHandler);
		}
	}
	
	public function unlistenFormControl(control:FormControl):void {
		if (_listenControls.length === 0) {
			return;
		}
		
		var f:int=-1;
		var fmax:int=_listenControls.length;
		
		var listenControl:ListenControl;
		
		while (++f < fmax) {
			listenControl=_listenControls[f];
			
			if (listenControl.control === control) {
				if (_state !== FormControlState.NONE) {
					listenControl.stopListener(controlChangedHandler);
				}
				
				_listenControls.splice(f, 1);
				
				return;
			}
		}
	}
	
	protected function startControlListener():void {
		if (_listenControls.length === 0) {
			return;
		}
		
		var f:int=-1;
		var fmax:int=_listenControls.length;
		
		while (++f < fmax) {
			_listenControls[f].startListener(controlChangedHandler);
		}
	}
	
	protected function stopControlListener():void {
		if (_listenControls.length === 0) {
			return;
		}
		
		var f:int=-1;
		var fmax:int=_listenControls.length;
		
		while (++f < fmax) {
			_listenControls[f].stopListener(controlChangedHandler);
		}
	}
	
	private function controlChangedHandler(event:FormControlEvent):void {
		if (_controlsChanged !== null) {
			_controlsChanged();
		}
	}
	
	/** @inheritDoc */
	public function get controlsChanged():Function {
		return _controlsChanged;
	}
	
	/** @inheritDoc */
	public function set controlsChanged(value:Function):void {
		_controlsChanged=value;
	}
	
	/** @inheritDoc */
	public function get stateChanged():Function {
		return _stateChanged;
	}
	
	/** @inheritDoc */
	public function set stateChanged(value:Function):void {
		_stateChanged=value;
	}
	
	/** @inheritDoc */
	public function get valueChanged():Function {
		return _valueChanged;
	}
	
	/** @inheritDoc */
	public function set valueChanged(value:Function):void {
		_valueChanged=value;
	}
	
	//=========================================================
	// control state
	//=========================================================
	/** @inheritDoc */
	public function get state():FormControlState {
		return _state;
	}
	
	protected function refreshState():void {
		var state:FormControlState;
		
		if (enabled) {
			state=StringUtils.isBlank(errorString) ? FormControlState.NORMAL : FormControlState.ERROR;
		} else {
			state=FormControlState.DISABLED;
		}
		
		if (state === FormControlState.DISABLED) {
			if (!StringUtils.isBlank(errorString)) {
				errorString=null;
			}
			
			clearValue();
		}
		
		if (state !== _state) {
			_state=state;
			
			dispatchFormStateChange();
		}
	}
	
	protected function clearValue():void {
	}
	
	protected function getComponentRect():Rectangle {
		return new Rectangle(_component.x, _component.y, _component.width, _component.height);
	}
	
	//=========================================================
	// control enabled
	//=========================================================
	protected function startEnabledControl():void {
		_component.addEventListener("enabledChanged", enabledChanged, false, 0, true);
		_component.enabled=_enabled;
	}
	
	protected function stopEnabledControl():void {
		_component.removeEventListener("enabledChanged", enabledChanged);
		_enabled=_component.enabled;
		_component.enabled=false;
	}
	
	private function enabledChanged(event:Event):void {
		refreshState();
		
		if (_component is IFocusManagerComponent && _component.focusManager.getFocus() === _component) {
			_component.focusManager.setFocus(_component as IFocusManagerComponent);
		}
	}
	
	/** @inheritDoc */
	public function get enabled():Boolean {
		return _component.enabled;
	}
	
	/** @inheritDoc */
	public function set enabled(value:Boolean):void {
		if (_state === FormControlState.NONE) {
			_enabled=value;
		} else {
			_component.enabled=value;
		}
	}
	
	//=========================================================
	// control error
	//=========================================================
	protected function startErrorControl():void {
		_component.addEventListener("errorStringChanged", errorStringChanged, false, 0, true);
		_component.errorString=_errorString;
	}
	
	protected function stopErrorControl():void {
		_component.removeEventListener("errorStringChanged", errorStringChanged);
		_errorString=_component.errorString;
		_component.errorString=null;
	}
	
	private function errorStringChanged(event:Event):void {
		refreshState();
	}
	
	/** @inheritDoc */
	public function get errorString():String {
		return _component.errorString;
	}
	
	/** @inheritDoc */
	public function set errorString(value:String):void {
		if (_state === FormControlState.NONE) {
			_errorString=value;
		} else {
			_component.errorString=value;
		}
	}
	
	//=========================================================
	// tab control
	//=========================================================
	/** @inheritDoc */
	public function get tabComponent():IFocusManagerComponent {
		return _component as IFocusManagerComponent;
	}
	
	/** @inheritDoc */
	public function get nextTabControl():FormControl {
		return tabControl.nextTabControl;
	}
	
	/** @inheritDoc */
	public function set nextTabControl(value:FormControl):void {
		tabControl.nextTabControl=value;
	}
	
	/** @inheritDoc */
	public function get nextTabComponentFunction():Function {
		return tabControl.nextTabComponentFunction;
	}
	
	/** @inheritDoc */
	public function set nextTabComponentFunction(value:Function):void {
		tabControl.nextTabComponentFunction=value;
	}
	
	/** @inheritDoc */
	public function get prevTabControl():FormControl {
		return tabControl.prevTabControl;
	}
	
	/** @inheritDoc */
	public function set prevTabControl(value:FormControl):void {
		tabControl.prevTabControl=value;
	}
	
	/** @inheritDoc */
	public function get prevTabComponentFunction():Function {
		return tabControl.prevTabComponentFunction;
	}
	
	/** @inheritDoc */
	public function set prevTabComponentFunction(value:Function):void {
		tabControl.prevTabComponentFunction=value;
	}
	
	//=========================================================
	// dispatches
	//=========================================================
	final protected function dispatchFormValueChange():void {
		if (_valueChanged !== null) {
			_valueChanged();
		}
		dispatchEvent(new FormControlEvent(FormControlEvent.FORM_VALUE_CHANGED, this));
	}
	
	final protected function dispatchFormStateChange():void {
		if (_stateChanged !== null) {
			_stateChanged();
		}
		dispatchEvent(new FormControlEvent(FormControlEvent.FORM_STATE_CHANGED, this));
	}
}
}
import ssen.displaykit.form.FormControl;
import ssen.displaykit.form.FormControlEvent;

class ListenControl {
	public var control:FormControl;
	public var listenStateChanged:Boolean;
	public var listenValueChanged:Boolean;
	
	public function startListener(listener:Function):void {
		stopListener(listener);
		
		if (listenStateChanged) {
			control.addEventListener(FormControlEvent.FORM_STATE_CHANGED, listener, false, 0, true);
		}
		
		if (listenValueChanged) {
			control.addEventListener(FormControlEvent.FORM_VALUE_CHANGED, listener, false, 0, true);
		}
	}
	
	public function stopListener(listener:Function):void {
		control.removeEventListener(FormControlEvent.FORM_STATE_CHANGED, listener);
		control.removeEventListener(FormControlEvent.FORM_VALUE_CHANGED, listener);
	}
}
