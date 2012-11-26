package ssen.airkit.badge {


final public class AIRBadgeState {
	/** 런타임이 설치가 되어 있지 않으므로, 설치를 진행 할 수 있음 */
	public static const READY_INSTALL_RUNTIME:AIRBadgeState=new AIRBadgeState("런타임이 설치가 되어 있지 않으므로, 설치를 진행 할 수 있음");
	
	/** 런타임은 설치가 되어 있고, 어플리케이션이 설치되어 있지 않거나, 업데이트가 있음 */
	public static const READY_INSTALL_APPLICATION:AIRBadgeState=new AIRBadgeState("런타임은 설치가 되어 있고, 어플리케이션이 설치되어 있지 않거나, 업데이트가 있음");
	
	/** 실행 가능함 */
	public static const READY_LAUNCH:AIRBadgeState=new AIRBadgeState("실행 가능함");
	
	/** 에러가 발생했음 */
	public static const ERROR:AIRBadgeState=new AIRBadgeState("에러 발생!!!");
	
	private var _annotation:String;
	
	private static var pids:int=0;
	private var pid:int;
	
	public function AIRBadgeState(annotation:String="") {
		_annotation=annotation;
		
		pid=pids;
		pids++;
	}
	
	public function get annotation():String {
		return _annotation;
	}
	
	public function equal(state:AIRBadgeState):Boolean {
		return state.pid === pid;
	}

}
}
