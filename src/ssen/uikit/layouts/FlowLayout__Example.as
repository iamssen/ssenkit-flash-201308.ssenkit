package ssen.uikit.layouts {
import flash.display.Graphics;

import org.osmf.layout.VerticalAlign;

import spark.components.Button;
import spark.components.Group;
import spark.layouts.HorizontalAlign;

import ssen.common.MathUtils;
import ssen.devkit.ExampleCanvas;

public class FlowLayout__Example extends ExampleCanvas {
	
	[Test]
	public function testFlowLayout():void {
		clear();
		
		const W:int=500;
		const H:int=400;
		
		var g:Graphics=canvas.graphics;
		g.beginFill(0x777777);
		g.drawRect(10, 10, W, H);
		g.endFill();
		
		var layout:FlowLayout=new FlowLayout;
		layout.horizontalGap=10;
		layout.verticalGap=10;
		layout.horizontalAlign=HorizontalAlign.LEFT;
		layout.itemVerticalAlign=VerticalAlign.TOP;
		layout.paddingLeft=30;
		layout.paddingRight=0;
		layout.paddingTop=30;
		layout.paddingBottom=0;
		
		var group:Group=new Group;
		group.width=W;
		group.height=H;
		group.x=20;
		group.y=20;
		group.layout=layout;
		
		var btn:Button;
		var f:int=MathUtils.rand(3, 40);
		while (--f >= 0) {
			btn=new Button;
			btn.label=f.toString();
			btn.width=MathUtils.rand(20, 100);
			btn.height=MathUtils.rand(20, 40);
			group.addElement(btn);
		}
		
		addElement(group);
	}
	
	[Test]
	public function testFlowLayoutWithInvalidation():void {
		clear();
		
		const W:int=500;
		const H:int=400;
		
		var g:Graphics=canvas.graphics;
		g.beginFill(0x777777);
		g.drawRect(10, 10, W, H);
		g.endFill();
		
		var layout:FlowLayout=new FlowLayout;
		layout.horizontalGap=10;
		layout.verticalGap=10;
		layout.horizontalAlign=HorizontalAlign.LEFT;
		layout.itemVerticalAlign=VerticalAlign.TOP;
		
		var group:Group=new Group;
		group.width=W;
		group.height=H;
		group.x=20;
		group.y=20;
		group.layout=layout;
		
		var btn:Button;
		var f:int=MathUtils.rand(3, 40);
		while (--f >= 0) {
			btn=new Button;
			// 이와 같이 measure 시점 이후에 size 가 결정되는 경우
			// size 가 부정확해서 정렬 범위가 이상하게 작동하는 경우가 있다.
			btn.label=MathUtils.randHex(MathUtils.rand(2, 12));
			group.addElement(btn);
		}
		
		addElement(group);
		
		// 이 경우에는 size 가 결정된 이후 시점에
		// 다시 한 번 지연 호출을 통해 invalidation 시켜주면 뭔가 된다...
		callLater(group.invalidateDisplayList);
	}
}
}
