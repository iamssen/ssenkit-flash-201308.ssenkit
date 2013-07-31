package ssen.displaykit.forms {
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	import spark.components.ComboBox;
	import spark.events.IndexChangeEvent;

	public class ComboBoxControl extends UIComponentControl {
		private var component:ComboBox;

		public var restrict:String;
		public var maxChars:int;

		public function ComboBoxControl(component:ComboBox) {
			this.component=component;
			super(component);
		}

		public function get comboBox():ComboBox {
			return component;
		}

		override protected function doStart():void {
			component.restrict=restrict;
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

			component.dataProvider=null;
			component=null;
		}

		//=========================================================
		// 
		//=========================================================
		private function startValueControl():void {
			component.addEventListener(IndexChangeEvent.CHANGE, indexChange, false, 0, true);
			component.addEventListener("dataProviderChanged", dataProviderChanged, false, 0, true);
		}

		private function stopValueControl():void {
			component.removeEventListener(IndexChangeEvent.CHANGE, indexChange);
			component.removeEventListener("dataProviderChanged", dataProviderChanged);
		}

		private function dataProviderChanged(event:Event):void {
			if (!component.focusEnabled && _cache === component.selectedItem) {
				_cache=component.selectedItem;
				dispatchFormValueChange();
			}

			dispatchFormValueChange();
		}

		private function indexChange(event:IndexChangeEvent):void {
			if (!component.focusEnabled && _cache === component.selectedItem) {
				_cache=component.selectedItem;
				dispatchFormValueChange();
			}

			dispatchFormValueChange();
		}

		override protected function clearValue():void {
			component.selectedIndex=-1;
			_cache="";
		}

		//=========================================================
		// type control
		//=========================================================
		private var _cache:String;

		private function startTypeControl():void {
			_cache=component.selectedItem;

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
			component.selectedItem=_cache;
		}

		private function commitValue():void {
			_cache=component.selectedItem;
			dispatchFormValueChange();
		}
	}
}
