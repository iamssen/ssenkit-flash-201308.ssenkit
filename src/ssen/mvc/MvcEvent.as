package ssen.mvc {
import flash.events.Event;

public class MvcEvent extends Event {
	public static const DECONSTRUCT_CONTEXT:String="deconstructContext";

	public function MvcEvent(type:String) {
		super(type);
	}

	override public function clone():Event {
		return new MvcEvent(type);
	}
}
}
