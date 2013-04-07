# Form Control

## 추가적으로 필요한 기능들

1. tooltip control
	- 기본 tooltip string 지정
	- spot tooltip string ( 한 3초 정도 보여주다 마는 기능 )

## 밖으로 떨어져 나간 기능들

1. style 지정은 그냥 design 상에서 지정
1. read only 는 그냥 스타일 수동 지정 + editable false + 바인딩으로 처리

## FormControl 의 역할

1. state 일관화 ( skin, errorTip, enabled 등등의 처리를 일괄적으로 )
2. tab key 컨트롤 ( index 방식이 아닌, prev, next 직접 처리 )
3. ~~초기값 컨트롤~~ 필요없을 듯...

그 외의 경우는 편의에 따라서 내부적으로 확장한다

- 외부적으로 컨트롤 가능한 기능들
	- setState(state : String, message : String = null) : void
	- currentState : String
		- normal // 값을 유지한다
		- disabled  // 값을 지워버린다
		- error (message 필요) // 값을 유지한다
	- openErrorMessage() : void
	- closeErrorMessage() : void // FormLabel 이 사용한다
	- hasErrorMessage : Boolean
	- errorMessage : Vector.<Error>
	- nextTabControl : FormControl
	- prevTabControl : FormControl
	- nextTabControlFunction : Function() : FormControl // 다음 focus item 을 판정해야 하거나, list editor 처럼 신규 아이템 추가 후 focus 를 줘야 할때 사용
	- prevTabControlFunction : Function() : FormControl
	- dispatch(FormControlEvent.ERROR_MESSAGE_CHANGED)
	- dispatch(FormControlEvent.VALUE_CHANGED)
	- dispatch(FormControlEvent.STATE_CHANGED)
	
sample code
	
	var control : IFormControl = new InputControl(view.input);
	
	// FormControl 을 청취하는 FormLabel
	var label : FormLabel = new FormLabel;
	label.setFormControl(control);
	
	// tab control
	control.prevTabComponent = view.title;
	control.nextTabComponentFunction = function():IFocusManagerComponent {
		return bool ? view.file : view.submit;
	}
	
	// error listener
	control.addEventListener(FormControlEvent.CHANGE_ERROR_MESSAGE, function(event:FormControlEvent):void {
		// 에러가 생길시 상시 보여주게 되는 에러 메세지에 대한 대응
		if (event.control.errorString !== null) {
			view.label.text = event.control.errorString;
		} else {
			view.label.text = "";
		}
	});
	
	control.addEventListener(FormControlEvent.SHOW_ERROR_MESSAGE, function(event:FormControlEvent):void {
		// FormLabel 과 같이 연계되어 발생되는 이벤트 보여주기 경우에 대한 대응
		if (event.control.errorString !== null) {
			view.tip.text = event.control.errors.join("\n");
		} else {
			view.tip.text = "";
		}
	});
	
	control.addEventListener(FormControlEvent.HIDE_ERROR_MESSAGE, function(event:FormControlEvent):void {
		// FormLabel 과 같이 연계되어 발생되는 이벤트 보여주기 경우에 대한 대응
		view.tip.text = "";
	});
	
	// value listener
	control.addEventListener(FormControlEvent.VALUE_CHANGED, function(event:FormControlEvent):void {
		event.control.errorString = (validator.validate(event.control.value)) ? "validate error" : null;
	});
	
	// control 을 파괴한다
	control.dispose();
	control = null;
	label.dispose();
	label = null;
	
	
- 내부적으로 구현하는게 좋을 기능들
	- user interaction
	- skin control
	
- FormLabel 
	- targetFormControl : FormControl

- EditableTextFormControl
	- 값에 대한 인터렉션... clone, restore, fix 등
		- input text 에서 편집 시작시에는 clone 을 통해서 원 데이터를 보존
		- 편집 중 esc 를 누르면 원 데이터로 복구
		- 포커스가 나가거나 하면 fix 를 통해 값을 적용하고, 알림