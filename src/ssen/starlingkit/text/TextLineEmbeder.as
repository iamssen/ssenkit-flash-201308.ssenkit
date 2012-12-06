package ssen.starlingkit.text {
import flash.text.engine.TextLine;

public class TextLineEmbeder {
	public var createdTextLines:Function;
	
	public function createTextLines(line:TextLine):void {
		var tl:TextImage=new TextImage(line);
		
		tl.x=int(line.x);
		tl.y=int(line.y - line.ascent);
		
		createdTextLines(tl);
	}
}
}

import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.sampler.getSize;
import flash.text.engine.TextLine;

import starling.display.Image;
import starling.textures.Texture;

class TextImage extends Image {
	private var bitmap:BitmapData;
	
	public function TextImage(line:TextLine) {
		super(convertTextLineToTexture(line));
	}
	
	public function setTextLine(line:flash.text.engine.TextLine):void {
		disposeBitmap();
		texture=convertTextLineToTexture(line);
	}
	
	protected function convertTextLineToTexture(line:flash.text.engine.TextLine):Texture {
		var mat:Matrix=new Matrix;
		mat.translate(0, line.ascent);
		
		bitmap=new BitmapData(line.width, line.height, true, 0x00000000);
		bitmap.draw(line, mat);
		
		return Texture.fromBitmapData(bitmap);
	}
	
	protected function disposeBitmap():void {
		if (bitmap !== null) {
			bitmap.dispose();
			bitmap=null;
		}
	}
	
	/** @inheritDoc */
	override public function dispose():void {
		super.dispose();
		disposeBitmap();
	}
}
