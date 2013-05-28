package ssen.common {
import flash.utils.Dictionary;

public class AsyncUnitGatherer implements IDisposable {

	private var _callback:Function;
	private var _cnt:int;
	private var _resultCnt:int;
	private var _faultCnt:int;
	private var _arr:Vector.<UnitResponder>;
	private var _ids:Dictionary;

	public function AsyncUnitGatherer(callback:Function) {
		_callback=callback;
		_cnt=0;
		_resultCnt=0;
		_faultCnt=0;
		_arr=new Vector.<UnitResponder>;
		_ids=new Dictionary;
	}

	public function add(id:String, unit:IAsyncUnit):void {
		if (_ids[id] !== undefined) {
			throw new Error("don't add same id");
		}

		_cnt++;
		_ids[id]=_arr.push(new UnitResponder(unit, complete)) - 1;
	}

	private function complete(result:Boolean):void {
		_cnt--;

		if (result) {
			_resultCnt++;
		} else {
			_faultCnt++;
		}

		if (_cnt === 0) {
			_callback(_resultCnt, _faultCnt, this);
		}
	}

	public function getResult(id:String):* {
		return _arr[_ids[id]].getResult();
	}

	public function getFault(id:String):* {
		return _arr[_ids[id]].getFault();
	}

	/** @inheritDoc */
	public function dispose():void {
		var f:int=_arr.length;
		while (--f >= 0) {
			_arr[f].dispose();
		}

		_callback=null;
		_arr=null;
		_ids=null;
	}
}
}
import ssen.common.IAsyncUnit;
import ssen.common.IDisposable;

class UnitResponder implements IDisposable {
	private var _callback:Function;
	private var _result:*;
	private var _fault:*;

	public function UnitResponder(unit:IAsyncUnit, callback:Function) {
		unit.result=result;
		unit.fault=fault;

		_callback=callback;
	}

	private function result(value:*):void {
		_result=value;
		_callback(true);
	}

	private function fault(value:*):void {
		_fault=value;
		_callback(false);
	}

	public function getResult():* {
		return _result;
	}

	public function getFault():* {
		return _fault;
	}

	/** @inheritDoc */
	public function dispose():void {
		_callback=null;
		_result=null;
		_fault=null;
	}
}
