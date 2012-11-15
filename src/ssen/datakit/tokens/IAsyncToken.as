package ssen.datakit.tokens {
import ssen.common.IDisposable;

public interface IAsyncToken extends IDisposable {
	function get result():Function;
	function set result(value:Function):void;
	function get fault():Function;
	function set fault(value:Function):void;
	function close():void;
}
}
