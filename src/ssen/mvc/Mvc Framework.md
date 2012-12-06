# 보완점들

1. Display Base Context 와 Starling Base Context 간에 Event 교환 문제가 있다...
	- 결국 같은 기존 이벤트를 쓰기엔 무리가 있다.
	- 새로운 Event 단위를 만들 필요가 있다.
		- `MessageDispatcher`
		- `Message`
		- 이왕 만드는 김에 좀 더 코딩하기 단순하게 만들어볼까?
	
2. DispatchTo 에 LocalAndParent, LocalAndChildren 등의 단위가 더 필요할듯 싶다