AIR Application 의 Update 및 Install 을 담당하는 Badge 를 만드는데 필요한 유틸

기본적으로 AIR Application Updater 의 `update.xml` 을 동일하게 사용해서 체크하게 된다. (보통 html 상에서 param 을 통해 패스 하는 경우가 많지만, 합리적인 구성을 위해서 update.xml 을 이용하도록 되어 있음)

# Setting

- `updateURL` AIR Application Updater 의 `update.xml` 을 동일하게 사용한다.
- `installInBadge` update, install 가능시에 Badge 상에서 install 시킬지 여부

# 중요 제한 사항들

- `app.xml` 의 `allowBrowserInvocation` 옵션 활성화가 안되어 있으면 browser 를 통한 실행이 되지 않는다
- browser 상에서 install 또는 launch 시 전달하는 `arguments` 는 배열 형태이지만, 내부 항목들의 적합성 문제가 민감하다. 실행이 비정상인 상황에서는 인코딩 또는 길이 등을 체크해보는 것이 좋다. 

# 작업 순서

	var badge:AIRBadge = new AIRBadge;
	
	// 셋팅
	badge.updateURL="http://foo.com/update.xml";
	badge.installInBadge=true;
	
	// 실행
	badge.addEventListener(Event.INIT, badgeInitialized);
	badge.check();

	// 확인
	function badgeInitialized(event:Event):void {
		if (badge.state.equal(AIRBadgeState.READY_LAUNCH)) {
			// 업데이트 가능 내역이 없으니 실행할 수 있다는 메세지 출력
			trace("실행이 가능함");
			
			// 보안 문제로 인해서 Click Context 내에서 이루어져야 한다
			addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void {}
				badge.launchApplication(["arg", "arg"]);
			});
			
		} else if (badge.state.equal(READY_INSTALL_RUNTIME) || badge.state.equal(READY_INSTALL_APPLICATION)) {
			// 설치 가능하다는 메세지 출력
			trace("설치가 가능함");
			
			addEventListener(MouseEvent.CLICK, function(event:MouseEvent):void {}
				badge.installApplication(["arg", "arg"]);
			});
			
		} else {
			// 실행 불가능 하다는 에러 메세지 출력
			trace(badge.error);
		}
	}

Browser Invocation 은 기본 Invocation 과 마찬가지로 실행되어 있더라도 다시 전달이 가능하다.

Web 상의 특정 파일을 실행하고 싶은 경우라면 argument 에 파일의 url 을 전달해서 AIR 에서 다운로드 받은 다음, 다운로드 받은 파일을 실행하는 형태의 구성 역시 가능할듯 싶다.