package ssen.common {

/** 문자열 관련 util */
public class StringUtils {

	/** 앞뒤 공백을 없애준다 */
	public static function clearBlank(text:String):String {
		return text.replace(/^\s*|\s*$/g, "");
	}

	/** 문자가 null 혹은 공백인지 확인 */
	public static function isBlank(str:String):Boolean {
		return str === null || str === "";
	}

	/** 값들을 정해진 형식에 맞게 출력한다 */
	public static function formatToString(format:String, ... args):String {
		var f:int=args.length;
		while (--f >= 0) {
			format=format.replace(new RegExp("\\{" + f + "\\}", "g"), args[f]);
		}
		return format;
	}
}
}
