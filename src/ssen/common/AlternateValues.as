package ssen.common {

/** 공백 값들을 대치 해주는 기능들 */
public class AlternateValues {
//	/** null 을 
	public static function nullTo(value:*, defaultValue:*):* {
		if (value === null || value === undefined) {
			return defaultValue;
		}
		
		return value;
	}
	
	public static function blankTo(value:*, defaultValue:String, checkSpaces:Boolean=false):String {
		if (value === null || value === undefined) {
			return defaultValue;
		}
		
		var str:String=value;
		
		if (str === "") {
			return defaultValue;
		}
		
		if (checkSpaces) {
			str=StringUtils.clearBlank(str);
			
			if (str === "") {
				return defaultValue;
			}
		}
		
		return value;
	}
	
	public static function nanTo(value:*, defaultValue:Number):Number {
		if (value === null || value === undefined) {
			return defaultValue;
		}
		
		var n:Number=Number(value);
		
		if (isNaN(n)) {
			return defaultValue;
		}
		
		return value;
	}
}
}
