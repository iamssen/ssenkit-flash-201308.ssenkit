# Invalidation 구조

- <http://help.adobe.com/en_US/flex/using/WS460ee381960520ad-2811830c121e9107ecb-7fff.html>
- invalidateDisplayList() --> updateDisplayList()
- invalidateProperties() --> commitProperties()
- invalidateSize() --> measure()
- invalidateSkinState() --> commitProperties(), getCurrentSkinState()
- [invalidate 원론](http://blog.jidolstar.com/511)

# Skinnable Component 에서 [SkinPart] 들이 모두 들어오는 시점

1. `FlexEvent.PREINITIALIZE` 
1. `getStyle("skinStyle")`
1. `partAdded`
1. `FlexEvent.INITIALIZE` 이 시점부터 [SkinPart] 들이 존재한다
1. `FlexEvent.CREATION_COMPLETE`
1. `Event.ADDED_TO_STAGE`

SkinnableComponent

	package test.display {
	
		import flash.events.Event;
	
		import mx.events.FlexEvent;
	
		import spark.components.Button;
		import spark.components.TextInput;
		import spark.components.supportClasses.SkinnableComponent;
	
		import ssen.common.EventUtils;
	
		public class CreationCompleteTestView extends SkinnableComponent {
	
			[SkinPart]
			public var btn:Button;
	
			[SkinPart]
			public var txt:TextInput;
	
			public function CreationCompleteTestView() {
				EventUtils.addEventListenerOnce(this, FlexEvent.INITIALIZE, checkSkinPart);
				EventUtils.addEventListenerOnce(this, FlexEvent.CREATION_COMPLETE, checkSkinPart);
				EventUtils.addEventListenerOnce(this, Event.ADDED_TO_STAGE, checkSkinPart);
				EventUtils.addEventListenerOnce(this, FlexEvent.PREINITIALIZE, checkSkinPart);
				EventUtils.addEventListenerOnce(this, FlexEvent.APPLICATION_COMPLETE, checkSkinPart);
			}
	
			public function readComponents():void {
				trace("CreationCompleteTestView.readComponents", btn, txt);
			}
	
			override public function getStyle(styleProp:String):* {
				if (styleProp === "skinClass" && !Boolean(super.getStyle(styleProp))) {
					trace("CreationCompleteTestView.getStyle", styleProp);
					return CreationCompleteTestViewSkin;
				}
	
				return super.getStyle(styleProp);
			}
	
			private function checkSkinPart(event:Event):void {
				trace("CreationCompleteTestView.checkSkinPart", event.type, btn, txt);
			}
	
			override protected function partAdded(partName:String, instance:Object):void {
				super.partAdded(partName, instance);
	
				trace("CreationCompleteTestView.partAdded", partName, instance, btn, txt);
			}
	
			override protected function partRemoved(partName:String, instance:Object):void {
				super.partRemoved(partName, instance);
	
				trace("CreationCompleteTestView.partRemoved", partName, instance, btn, txt);
			}
	
		}
	}
	
Skin

	<?xml version="1.0" encoding="utf-8"?>
	<s:Skin xmlns:fx="http://ns.adobe.com/mxml/2009" xmlns:s="library://ns.adobe.com/flex/spark"
			xmlns:mx="library://ns.adobe.com/flex/mx">
		<!-- host component -->
		<fx:Metadata>
			[HostComponent("test.display.CreationCompleteTestView")]
		</fx:Metadata>
	
		<s:layout>
			<s:HorizontalLayout paddingTop="0" paddingBottom="0" paddingLeft="0" paddingRight="0" gap="5"
								horizontalAlign="left" verticalAlign="top"/>
	
		</s:layout>
	
		<s:TextInput id="txt"/>
		<s:Button id="btn"/>
	</s:Skin>
	
작동 결과

	CreationCompleteTestView.checkSkinPart preinitialize null null
	CreationCompleteTestView.getStyle skinClass
	CreationCompleteTestView.partAdded txt test0.ApplicationSkin2._ApplicationSkin_Group1.contentGroup.skinPartTestView.CreationCompleteTestViewSkin9.txt null test0.ApplicationSkin2._ApplicationSkin_Group1.contentGroup.skinPartTestView.CreationCompleteTestViewSkin9.txt
	CreationCompleteTestView.partAdded btn test0.ApplicationSkin2._ApplicationSkin_Group1.contentGroup.skinPartTestView.CreationCompleteTestViewSkin9.btn test0.ApplicationSkin2._ApplicationSkin_Group1.contentGroup.skinPartTestView.CreationCompleteTestViewSkin9.btn test0.ApplicationSkin2._ApplicationSkin_Group1.contentGroup.skinPartTestView.CreationCompleteTestViewSkin9.txt
	CreationCompleteTestView.checkSkinPart initialize test0.ApplicationSkin2._ApplicationSkin_Group1.contentGroup.skinPartTestView.CreationCompleteTestViewSkin9.btn test0.ApplicationSkin2._ApplicationSkin_Group1.contentGroup.skinPartTestView.CreationCompleteTestViewSkin9.txt
	[Event type="initialize" bubbles=false cancelable=false eventPhase=2]
	CreationCompleteTestView.getStyle skinClass
	CreationCompleteTestView.checkSkinPart creationComplete test0.ApplicationSkin2._ApplicationSkin_Group1.contentGroup.skinPartTestView.CreationCompleteTestViewSkin9.btn test0.ApplicationSkin2._ApplicationSkin_Group1.contentGroup.skinPartTestView.CreationCompleteTestViewSkin9.txt
	CreationCompleteTestView.checkSkinPart addedToStage test0.ApplicationSkin2._ApplicationSkin_Group1.contentGroup.skinPartTestView.CreationCompleteTestViewSkin9.btn test0.ApplicationSkin2._ApplicationSkin_Group1.contentGroup.skinPartTestView.CreationCompleteTestViewSkin9.txt