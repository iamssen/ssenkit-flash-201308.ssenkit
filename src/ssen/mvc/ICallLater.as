package ssen.mvc {
import ssen.common.IDisposable;

public interface ICallLater extends IDisposable {
	/**
	 * 지연 실행시킬 function 을 추가한다
	 * @param func 지연 실행시킬 function
	 * @param params 인자 항목
	 */
	function add(func:Function, params:Array=null):void;
}
}
