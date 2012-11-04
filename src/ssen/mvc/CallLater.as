package ssen.mvc {
import flash.events.Event;

/** 1frame 지연시켜서 실행시킬 function 들을 관리 */
public class CallLater {
	/** @private */
	[Inject]
	public var contextView:IContextView;

	private var queue:Vector.<Item>;
	private var on:Boolean;

	public function CallLater() {
		queue=new Vector.<Item>;
	}

	/**
	 * 지연 실행시킬 function 을 추가한다
	 * @param func 지연 실행시킬 function
	 * @param params 인자 항목
	 */
	public function add(func:Function, params:Array=null):void {
		var item:Item=new Item;
		item.func=func;
		item.params=params;

		queue.push(item);

		if (!on) {
			contextView.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			on=true;
		}
	}

	private function enterFrameHandler(event:Event):void {
		contextView.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		executeAll();
	}

	private function executeAll():void {
		on=false;

		if (queue.length <= 0) {
			return;
		}

		var item:Item;

		var f:int=-1;
		var fmax:int=queue.length;

		while (++f < fmax) {
			item=queue[f];
			item.func.apply(null, item.params);
		}

		queue.length=0;
	}
}
}

class Item {
	public var func:Function;
	public var params:Array;
}
