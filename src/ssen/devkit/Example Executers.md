`ExampleExecuter` 와 `ExampleCanvas` 는 UnitTest 로는 확인하기 어려운 실제 Console log 를 확인해야 하거나, 실제 화면에 그려지는 항목을 봐야 하는 경우 사용할 수 있다

# Console 을 통해 확인되는 Test 들을 다루기

Test 가능한 Class 는 아래와 같이 만든다

	package test {
		public class TestClass {
			[Test]
			public function testHelloWorld():void {
				trace("hello world");
			}
			
			[Test]
			public function testSum():void {
				trace(1+5);
			}
		}
	}

Test 를 실행하기 위한 실행화면은 아래와 같이 만든다

	<?xml version="1.0" encoding="utf-8"?>
	<s:Application xmlns:fx="http://ns.adobe.com/mxml/2009" xmlns:s="library://ns.adobe.com/flex/spark" xmlns:devkit="ssen.devkit.*">
	
		<s:layout>
			<s:VerticalLayout paddingTop="10" paddingBottom="10" paddingLeft="10" paddingRight="10" gap="10" horizontalAlign="left"
							  verticalAlign="top"/>
		</s:layout>
	
		<devkit:ExampleExecuter exampleClass="test.TestClass"/>
		<devkit:ExampleExecuter exampleClass="ssen.common.ds.DataConverter__Example"/>
		<devkit:ExampleExecuter exampleClass="ssen.common.ds.polygonal.Queue__Example"/>
		<devkit:ExampleExecuter exampleClass="ssen.common.ds.polygonal.Stack__Example"/>
		<devkit:ExampleExecuter exampleClass="ssen.common.ds.polygonal.Deque__Example"/>
	</s:Application>
	
`ExampleExecuter.exampleClass` 에 Test 해야할 Class 를 지정한 뒤 실행 시켜주면 `[Test]` 라는 Metadata tag 가 걸려있는 method 항목들이 버튼으로 나타나게 되고, 해당 버튼을 누르면 method 의 실행을 확인 가능하다


# 화면에 그려져야 하는 Test 들을 다루기

Test 가능한 Class 는 아래와 같이 만든다

	package ssen.uikit.graphics {
	
	import ssen.devkit.ExampleCanvas;
	
	public class TestClass extends ExampleCanvas {
		[Test]
		public function testDrawRect():void {
			// clear() 는 
			// canvas.graphics 를 모두 지우고
			// canvas 의 하위 Display 들을 모두 removeChild 시키고
			// ExampleCanvas 의 하위 IVisualElement 들을 모두 removeElement 시킨다
			clear();
			
			canvas.graphics.beginFill(0x000000);
			canvas.graphics.drawRect(10, 10, 100, 100);
			canvas.graphics.endFill();
		} 
	}

`ExampleCanvas` 에는 크게 세가지 Graphics Container 가 존재한다

1. `ExampleCanvas` 자체가 `Group` 을 상속받기 때문에 `IVisualElement` 를 `addElement()` 시킬 수 있다
1. `ExampleCanvas.canvas` 는 `SpriteVisualElement`이기 때문에 `DisplayObject` 를 `addChild()` 시키거나, `graphics` 드로잉이 가능하다
1. 그리고, `clear()` 는 이 세가지 모두를 지워준다

Test 를 실행하기 위한 실행화면은 아래와 같이 만든다

	<?xml version="1.0" encoding="utf-8"?>
	<s:Application xmlns:fx="http://ns.adobe.com/mxml/2009" xmlns:s="library://ns.adobe.com/flex/spark" xmlns:devkit="ssen.devkit.*">
		<devkit:ExampleCanvasViewer width="100%" height="100%">
			<s:ArrayList>
				<devkit:VisualElementFactory cls="test.TestClass"/>
				<devkit:VisualElementFactory cls="ssen.uikit.graphics.Easing__Example"/>
				<devkit:VisualElementFactory cls="ssen.uikit.graphics.PointMaker__Example"/>
				<devkit:VisualElementFactory cls="ssen.uikit.graphics.Gradation__Example"/>
				<devkit:VisualElementFactory cls="ssen.uikit.graphics.ColorMatrixFilter__Example"/>
			</s:ArrayList>
		</devkit:ExampleCanvasViewer>
	</s:Application> 
	
위와 같은 방식으로 작성을 하면 Class 들을 선택할 수 있는 DropDownList 와 그림이 그려질 Canvas, 그리고, `[Test]` Metadata tag 들이 버튼으로 등록되어 나타나게 된다.
