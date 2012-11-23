package ssen.airkit.connection {


/** WebConnection.send option */
public class SendTo {
	/** AIR 로만 메세지 보내기 */
	public static const AIR_ONLY:SendTo=new SendTo("airOnly");
	
	/** AIR 와 Web 모두 메세지 보내기 */
	public static const AIR_AND_WEB:SendTo=new SendTo("airAndWeb");
	
	/** Web 으로만 보내기 */
	public static const WEB_ONLY:SendTo=new SendTo("webOnly");
	private var _annotation:String;
	
	public function SendTo(annotation:String="") {
		_annotation=annotation;
	}
	
	public function get annotation():String {
		return _annotation;
	}

}
}
