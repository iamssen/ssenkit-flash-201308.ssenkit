package ssen.common.ds {
import de.polygonal.ds.Itr;

public class ArrayedItr implements Itr {
	private var _arr:Array;
	private var _f:int=-1;

	public function ArrayedItr(arr:Array) {
		this._arr=arr;
		_f=-1;
	}

	public function hasNext():Boolean {
		return _f + 1 < _arr.length;
	}

	public function next():Object {
		_f++;
		return _arr[_f];
	}

	public function remove():void {
		_arr[_f]=null;
	}

	public function reset():Itr {
		return new ArrayedItr(_arr);
	}
}
}
