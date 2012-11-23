package ssen.airkit.connection {
import flash.events.ErrorEvent;

public class ConnectionErrorEvent extends ErrorEvent {
	public static const CONNECT_ERROR:String = "connectError";

	public function ConnectionErrorEvent(type:String, text:String) {
		super(type, false, false, text);
	}
}
}