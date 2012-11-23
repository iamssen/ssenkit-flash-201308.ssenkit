package ssen.devkit {
import flash.display.CapsStyle;
import flash.events.Event;
import flash.utils.describeType;

import mx.core.IVisualElement;
import mx.events.FlexEvent;
import mx.graphics.SolidColor;
import mx.graphics.SolidColorStroke;

import spark.components.Group;
import spark.core.SpriteVisualElement;
import spark.layouts.HorizontalAlign;
import spark.layouts.HorizontalLayout;
import spark.layouts.VerticalAlign;
import spark.primitives.Rect;

public class ExampleCanvas extends Group {
	public var __background:Rect;
	public var canvas:SpriteVisualElement;
	public var executers:Group;
	
	public function ExampleCanvas() {
		addEventListener(FlexEvent.CREATION_COMPLETE, init);
	}
	
	private function init(event:Event):void {
		removeEventListener(FlexEvent.CREATION_COMPLETE, init);
		
		__background=new Rect;
		__background.left=10;
		__background.right=10;
		__background.top=10;
		__background.bottom=50;
		__background.stroke=new SolidColorStroke(0xaaaaaa, 1, 1, true, "normal", CapsStyle.SQUARE);
		__background.fill=new SolidColor(0xeeeeee);
		addElementAt(__background, 0);
		
		canvas=new SpriteVisualElement;
		canvas.x=10;
		canvas.y=10;
		addElementAt(canvas, 1);
		
		var layout:HorizontalLayout=new HorizontalLayout;
		layout.horizontalAlign=HorizontalAlign.CENTER;
		layout.verticalAlign=VerticalAlign.MIDDLE;
		
		executers=new Group;
		executers.bottom=0;
		executers.percentWidth=100;
		executers.height=50;
		executers.layout=layout;
		addElementAt(executers, 2);
		
		var script:XML=describeType(this);
		var methods:XMLList=script..metadata.(@name == "Test");
		var method:XML;
		
		var btn:ExampleExecuterButton;
		
		var f:int=-1;
		var fmax:int=methods.length();
		
		while (++f < fmax) {
			method=methods[f].parent();
			
			if (method.name().localName === "method") {
				btn=new ExampleExecuterButton;
				btn.target=this;
				btn.method=method.@name;
				executers.addElement(btn);
			}
		}
	}
	
	protected function clear():void {
		canvas.graphics.clear();
		
		var f:int=canvas.numChildren;
		while (--f >= 0) {
			canvas.removeChildAt(f);
		}
		
		var el:IVisualElement;
		
		f=numElements;
		while (--f >= 0) {
			el=getElementAt(f);
			
			if (el === __background || el === canvas || el === executers) {
			} else {
				removeElement(el);
			}
		}
	}
}
}
