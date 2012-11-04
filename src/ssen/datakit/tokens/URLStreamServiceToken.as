package ssen.datakit.tokens {
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLStream;

public class URLStreamServiceToken implements IServiceToken {
	private var _stream:URLStream;
	private var _result:Function;
	private var _fault:Function;

	public function setStream(stream:URLStream):void {
		clearStream();

		_stream=stream;

		addEvents();
	}

	private function addEvents():void {
		_stream.addEventListener(Event.COMPLETE, completeHandler, false, 0, true);
		_stream.addEventListener(IOErrorEvent.IO_ERROR, errorHandler, false, 0, true);
		_stream.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler, false, 0, true);
	}

	private function removeEvents():void {
		_stream.removeEventListener(Event.COMPLETE, completeHandler);
		_stream.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
		_stream.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorHandler);
	}

	private function clearStream():void {
		if (_stream) {
			try {
				removeEvents();
				_stream.close();
			} catch (error:Error) {
				trace("URLStreamServiceToken.clearStream()", error);
			} finally {
				_stream=null;
			}
		}
	}

	private function errorHandler(event:ErrorEvent):void {
		if (_fault !== null) {
			_fault(getError(event));
		}

		dispose();
	}

	private function completeHandler(event:Event):void {
		if (_result !== null) {
			_result(getResult(_stream));
		}

		dispose();
	}

	protected function getResult(stream:URLStream):* {
		return stream;
	}

	protected function getError(event:ErrorEvent):* {
		return event;
	}

	public function get result():Function {
		return _result;
	}

	public function set result(value:Function):void {
		_result=result;
	}

	public function get fault():Function {
		return _fault;
	}

	public function set fault(value:Function):void {
		_fault=value;
	}

	public function disconnect():void {
		dispose();
	}

	public function dispose():void {
		clearStream();
		_result=null;
		_fault=null;
	}
}
}
