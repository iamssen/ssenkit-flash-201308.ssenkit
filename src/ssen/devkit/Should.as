package ssen.devkit {
import avmplus.getQualifiedClassName;

import ssen.common.StringUtils;

public class Should {
	public static function equal(value:*, isEqual:*, strict:Boolean=false):void {
		if (strict && value === isEqual) {
		} else if (value == isEqual) {
		} else {
			throw e('{0} isn\'t equal {1}', value, isEqual);
		}
	}

	public static function typeis(value:*, type:Class):void {
		if (value is type) {
		} else {
			throw e('{0} isn\'t {1}', value, getQualifiedClassName(type));
		}
	}

	public static function exist(value:*):void {
		if (value === null || value === undefined) {
			throw e('{0} isn\'t exist', value);
		}
	}

	public static function above(value:Number, than:Number):void {
		if (value <= than) {
			throw e('{0} isn\'t above than {1}', value, than);
		}
	}

	public static function below(value:Number, than:Number):void {
		if (value >= than) {
			throw e('{0} isn\'t below than {1}', value, than);
		}
	}

	public static function within(value:Number, min:Number, max:Number):void {
		if (value < min || value > max) {
			throw e('{0} isn\'t within {1}, {2}', value, min, max);
		}
	}

	public static function match(value:String, match:RegExp):void {
		if (!match.test(value)) {
			throw e('{0} isn\'t matched {1}', value, match.source);
		}
	}

	private static function e(format:String, ... args:Array):Error {
		return new Error(StringUtils.formatToString.apply(null, [format].concat(args)));
	}
}
}
