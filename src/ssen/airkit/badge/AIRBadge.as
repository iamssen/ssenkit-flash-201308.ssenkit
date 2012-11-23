package ssen.airkit.badge {
import flash.display.Loader;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.net.URLRequest;
import flash.net.URLStream;
import flash.utils.getTimer;

import mx.rpc.Responder;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.http.HTTPService;

import ssen.common.IDisposable;

/** app 의 state check 를 완료했음 */
[Event(name="init", type="flash.events.Event")]
[DefaultProperty("updateURL")]

/** AIR Badge Service, minimum stage size 217*140px */
final public class AIRBadge extends EventDispatcher implements IDisposable {
	/* *********************************************************************
	 * settings
	 ********************************************************************* */
	/** air update xml 의 web 경로 */
	public var updateURL:String;
	
	/** badge 상에서 update 가능시에 install 시킬 것인지 여부 */
	public var badgeUpdateInstall:Boolean=false;
	
	/* *********************************************************************
	 * info
	 ********************************************************************* */
	// 어플리케이션 아이디
	private var _appId:String;
	
	// 제작자 아이디
	private var _pubId:String;
	
	// air 설치 파일의 web 경로
	private var _url:String;
	
	// 최소 air runtime version
	private var _minRuntimeVersion:String;
	
	// service state
	private var _state:AIRBadgeState;
	
	// update 될 버전 
	private var _updateVersion:String;
	
	private var _error:Error;
	
	/* *********************************************************************
	 * utils
	 ********************************************************************* */
	private var _loader:Loader;
	
	private var _air:Object;
	
	private var _stream:URLStream;
	
	
	public function AIRBadge(updateURL:String=null, badgeUpdateInstall:Boolean=false) {
		this.updateURL=updateURL;
		this.badgeUpdateInstall=badgeUpdateInstall;
	}
	
	/** air runtime 의 설치 상태 */
	public function get state():AIRBadgeState {
		return _state;
	}
	
	/** air runtime 에러 */
	public function get error():Error {
		return _error;
	}
	
	/** 초기화 */
	public function check():void {
		var service:HTTPService=new HTTPService();
		service.url=updateURL;
		service.useProxy=false;
		service.send({noCache: getTimer()}).addResponder(new Responder(updateInfoResult, updateInfoFault));
	}
	
	/* *********************************************************************
	 * step 1 : update xml catch and air.swf download
	 ********************************************************************* */
	private function updateInfoResult(event:ResultEvent):void {
		var update:Object=event.result.update;
		
		if (update.version == undefined) {
			_updateVersion=update.versionNumber;
		} else {
			_updateVersion=update.version;
		}
		
		_url=update.url;
		_appId=update.appId;
		_pubId=update.pubId;
		_minRuntimeVersion=update.runtimeVersion;
		
		_loader=new Loader;
		_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, airLoaded);
		_loader.load(new URLRequest("http://airdownload.adobe.com/air/browserapi/air.swf"));
	}
	
	public function dispose():void {
		if (_loader != null) {
			_loader.unloadAndStop();
		}
	}
	
	private function updateInfoFault(event:FaultEvent):void {
		_state=AIRBadgeState.ERROR;
		_error=AIRBadgeError.INVALID_UPDATE_URL;
		dispatchInit();
	}
	
	private function airLoaded(event:Event):void {
		_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, airLoaded);
		_air=_loader.content;
		
		stateCheck();
	}
	
	private function dispatchInit():void {
		dispatchEvent(new Event(Event.INIT));
	}
	
	/* *********************************************************************
	 * step 2 : runtime and app version check
	 ********************************************************************* */
	private function stateCheck():void {
		switch (getStatus()) {
			case "installed":
				getApplicationVersion(reciveAppVersion);
				break;
			case "available":
				_state=AIRBadgeState.READY_INSTALL_RUNTIME;
				dispatchInit();
				break;
			case "unavailable":
				_state=AIRBadgeState.ERROR;
				_error=AIRBadgeError.INVALID_UPDATE_URL;
				dispatchInit();
				break;
		}
	}
	
	private function reciveAppVersion(version:String):void {
		if (version == null || version == "") {
			_state=AIRBadgeState.READY_INSTALL_APPLICATION;
		} else if (badgeUpdateInstall && _updateVersion != version) {
			_state=AIRBadgeState.READY_INSTALL_APPLICATION;
		} else {
			_state=AIRBadgeState.READY_LAUNCH;
		}
		
		dispatchInit();
	}
	
	
	/* *********************************************************************
	 * air.swf api
	 ********************************************************************* */
	private function checkNullState():void {
		if (_state == null) {
			throw AIRBadgeError.STATE_NOT_CHECKED;
		}
	}
	
	/** air runtime 설치 상태 */
	private function getStatus():String {
		return _air.getStatus();
	}
	
	/** air application 을 실행한다 (!!!! 보안 : click 내에서 이루어져야 함) */
	public function launchApplication(arguments:Array=null):void {
		checkNullState();
		try {
			var args:Array=createArguments(arguments);
			_air.launchApplication(_appId, _pubId, args);
		} catch (e:Error) {
			throw AIRBadgeError.INVALID_ARGUMENT;
		}
	}
	
	private function createArguments(arguments:Array):Array {
		if (arguments == null) {
			arguments=["launchFromBrowser"];
		} else if (arguments.indexOf("launchFromBrowser") < 0) {
			arguments.push("launchFromBrowser");
		}
		return arguments;
	}
	
	/** air application 을 설치 한다 */
	public function installApplication(arguments:Array=null):void {
		checkNullState();
		_air.installApplication(_url, _minRuntimeVersion, createArguments(arguments));
	}
	
	/** air application 의 버전을 확인한다 */
	private function getApplicationVersion(callback:Function):void {
		_air.getApplicationVersion(_appId, _pubId, callback);
	}
}
}
