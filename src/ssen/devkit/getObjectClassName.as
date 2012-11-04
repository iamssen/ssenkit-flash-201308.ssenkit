package ssen.devkit {
import avmplus.getQualifiedClassName;

public function getObjectClassName(obj:Object):String {
	var str:String=getQualifiedClassName(obj);
	var arr:Array=str.split("::");
	if (arr.length > 1) {
		return arr[1];
	} else {
		return str;
	}
	return String(obj);
}
}
