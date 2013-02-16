# 바인딩의 종류

## `{ }` 를 사용하기

	<s:Label text="{instance.property}" />
	<s:Label text="{instance.method()}" />
	
	<fx:CurrencyFormatter id="usdFormatter" precision="2" currencySymbol="$" alignSymbol="left" />
	<s:Label text="usdFormatter.format(instance.property)}" />
	

## fx:Binding

	<fx:Binding source="source.property" destination="instance.property" />

## BindingUtils

	// bindProperty() : ChangeWatcher
	// ChangeWatcher.unwatch();
	BindingUtils.bindProperty(instance, "property", source, "property");


## 양방향 링크

	<!-- t1, t2 가 동일하게 적용된다 -->
	<s:TextInput id="t1" text="@{t2.text}" />
	<s:TextInput id="t2" />


## event dispatch type 설정

	[Bindable(event="fooEvent")]
	private function get foo():String {
		return "foo";
	}
	
	private function fooChange():void {
		dispatchEvent(new Event("fooEvent"));
	}


`{this.foo}` 를 통해 바인딩

## method 연결

	public function update(value:String):void {
		trace(value);
	}
	<s:TextInput id="txt" text="setter" />
	
	// bindSetter() : ChangeWatcher
	BindingUtils.bindSetter(update, txt, "text");


`id="txt"` 가 변경될 시에 `update()` 가 호출된다.

# 바인딩 Chain 설정

참고 : <http://www.codeproject.com/KB/applications/FlexDataBindingTricks.aspx?display=Print>

## 도트 경로 사용하기

	// instance.a.b.c 가 바인딩 설정 된다.
	// 그룹 감지가 아님...
	BindingUtils.bindSetter(method, instance, ["a", "b", "c"]);

## getter method 설정

	var reciver:Function = function (host:Object):String {
		return "hello" + host["prop1"]+host["prop2"]+host["prop3"]+host["prop4"];
	}
	
	BindingUtils.bindSetter(arrayedSetter, this, {name:"prop1", getter:reciver});
	BindingUtils.bindSetter(arrayedSetter, this, {name:"prop2", getter:reciver});
	BindingUtils.bindSetter(arrayedSetter, this, {name:"prop3", getter:reciver});
	BindingUtils.bindSetter(arrayedSetter, this, {name:"prop4", getter:reciver});
	
	---
	
	private function arrayedSetter(...values):void
	{
		trace("arrayedSetter", values);
	}
	

# 바인딩 응용

## MVVM 을 위한 model - viewModel - view 의 연계 바인딩

	<?xml version="1.0" encoding="utf-8"?>
	<s:Application xmlns:fx="http://ns.adobe.com/mxml/2009"
				   xmlns:s="library://ns.adobe.com/flex/spark"
				   xmlns:mx="library://ns.adobe.com/flex/mx"
				   minWidth="955"
				   minHeight="600">
	
		<fx:Script>
			<![CDATA[
				protected function button1_clickHandler(event:MouseEvent):void
				{
					m = "ADFE:FKKEKFKF";
				}
			]]>
		</fx:Script>
	
		<fx:Declarations>
			<fx:String id="m">aaa</fx:String>
			<fx:String id="vm">hello {m}</fx:String>
		</fx:Declarations>
	
		<s:Label id="v" x="10" y="10" width="138" height="19" text="{vm}"/>
		<s:Button x="14" y="37" label="Button" click="button1_clickHandler(event)"/>
	
	</s:Application>
