package ssen.uikit.text {

public interface IFont {
	function get fontFamily():String;
	function get fontLookup():String;
	function equal(font:IFont):Boolean;
}
}
