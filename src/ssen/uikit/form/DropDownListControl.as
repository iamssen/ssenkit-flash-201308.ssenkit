package ssen.uikit.form {
	import flash.events.Event;

	import spark.components.DropDownList;
	import spark.events.IndexChangeEvent;

	public class DropDownListControl extends UIComponentControl {
		protected var component:DropDownList;

		public function DropDownListControl(component:DropDownList) {
			this.component=component;
			super(component);
		}

		public function get dropDownList():DropDownList {
			return component;
		}

		override protected function doStart():void {
			startValueControl();
		}

		override protected function doStop():void {
			stopValueControl();
		}

		override public function dispose():void {
			if (state !== FormControlState.NONE) {
				stopValueControl();
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
			dispatchFormValueChange();
		}

		private function indexChange(event:IndexChangeEvent):void {
			dispatchFormValueChange();
		}

		override protected function clearValue():void {
			component.selectedIndex=-1;
		}
	}
}
