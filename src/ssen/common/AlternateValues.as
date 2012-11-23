package ssen.common {

/** 공백 값들을 대치 해주는 기능들 */
public class AlternateValues {
	/**
	 * null 이나 undefined 인 경우 기본값으로 대치해준다
	 * @param value 체크할 값
	 * @param defaultValue 대치할 값
	 */
	public static function nullTo(value:*, defaultValue:*):* {
		if (value === null || value === undefined) {
			return defaultValue;
		}
		
		return value;
	}
	
	/**
	 * null 이나 undefined 인 경우, 혹은 문자열 이더라도 공백인 경우 기본값으로 바꿔준다
	 * @param value 체크할 값
	 * @param defaultValue 대치할 값
	 * @param checkSpaces 공백문자들로만 이루어진 경우를 위해 공백문자를 제거하고 테스트 할지 여부
	 */
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
	
	/**
	 * null 이나 undefined 인 경우, 혹은 숫자 이더라도 NaN 일 경우 기본값으로 바꿔준다
	 * @param value 체크할 값
	 * @param defaultValue 대치할 값
	 */
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
