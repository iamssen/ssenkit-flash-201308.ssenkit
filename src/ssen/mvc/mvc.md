# 필요한 기능들

- command chaining
- packet control // datakit 의 기능으로 분류
	- IServiceToken
		- `result`
		- `fault`
		- `disconnect`

	

# Inject 가능한 기본 요소들

- `[IInjector]`
- `[IEventBus]`
- `[IContextView]` 
- `[ICommandMap]`
- `[IViewOuterBridge]`
- `[IViewInjector]`
- `[CallLater]`

# 의존성을 주입받는 Instance 의 동작

- `IDependent` 의존성 주입 완료 이후에 알림을 받고 싶다면 해당 interface 를 구현한다
- `eventBus.addEventListener(MvcEvent.DECONSTRUCT_CONTEXT)` Context 가 종료되는 상황을 알고 싶다면 해당 이벤트를 청취한다 

# 보여줘야 하는 내용들

- 구현 할 항목들
	- `Context`
	- `IDependent`
	- `ICommand`
		- `ICommandChain`
	- `IMediator`
	- `MvcEvent`

- 기초적으로 사용 가능한 항목들	
	- `CallLater`
	- `IInjector`
	- `IEventBus`
		- `DispatchTo`
	- `IContextView`
	- `ICommandMap`
	- `IViewOuterBridge`
	- `IViewInjector`

- 그다지 신경 안써도 되는 항목들
	- `IContext`
	- `IContextViewInjector`
	- `IViewCatcher`

- 저수준 항목들
	- `ContextBase`
