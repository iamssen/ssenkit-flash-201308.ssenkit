package ssen.uikit.graphics {
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.geom.Matrix;

import ssen.common.MathUtils;
import ssen.devkit.ExampleCanvas;

public class GraphicsDrawing__Example extends ExampleCanvas {
	[Embed(source="assets/photo1.jpg")]
	public static var TestImage:Class;
	
	[Test]
	public function useMatrixInBitmapDrawing():void {
		canvas.graphics.clear();
		
		var g:Graphics=canvas.graphics;
		var bitmap:BitmapData=new TestImage().bitmapData;
		
		// 일반 0, 0 에 100 x 100 사이즈 드로잉
		g.beginBitmapFill(bitmap);
		g.drawRect(0, 0, 100, 100);
		g.endFill();
		
		// 좌표 이동된 100 x 100 사이즈 드로잉
		g.beginBitmapFill(bitmap);
		g.drawRect(100, 0, 100, 100);
		g.endFill();
		
		var mat:Matrix=new Matrix;
		
		// 리사이즈와 포지션 이동
		mat.identity();
		// a, d 는 각각 x scale 과 y scale 을 의미한다 (목표하는 사이즈 / 소스의 사이즈) 의 공식이 필요하다
		mat.a=100 / bitmap.width;
		mat.d=100 / bitmap.height;
		mat.tx=0;
		mat.ty=100;
		
		g.beginBitmapFill(bitmap, mat);
		g.drawRect(0, 100, 100, 100);
		g.endFill();
		
		// 리사이즈, 포지션 이동, 회전 (리사이즈랑 겹치면 공식이 좀 애매해짐...)
		mat.identity();
		//		mat.a = 100/bitmap.width;
		//		mat.b = 100/bitmap.height;
		mat.tx=100;
		mat.tx=100;
		mat.rotate(MathUtils.deg2rad(90));
		
		g.beginBitmapFill(bitmap, mat);
		g.drawRect(100, 100, 1000, 1000);
		g.endFill();
	}
}
}
