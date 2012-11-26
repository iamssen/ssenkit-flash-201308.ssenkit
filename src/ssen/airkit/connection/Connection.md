`LocalConnection` 을 통해서 AIR 와 Web swf 간의 통신을 지원하다.

AIR 측은 당연히 한 개의 Connection 으로 구성해야 하고, Web 측은 다수의 Connection 구성이 가능하다.

# IConnectionConfig

AIR 와 Web 양측에서 공유하는 설정.

# Connection

`AIRConnection` 과 `WebConnection` 이라는 구현 클래스를 사용해야 한다.

기본적으로 사용 방식은 동일하고, 다만, 하위에 구현되어 있는 숨겨진 기능들이 다를 뿐이다.

- `start()` Connection 을 연다
- `stop()` Connection 을 닫는다
- `send(command:String, ...parameters:Array)` 다른 Connection 들에 메세지를 보낸다

Connection 을 열고, 닫고, 메세지를 보내는 기능들은 위의 기능들을 활용하고, 수신의 경우는 Event 를 사용한다

- `addEventListener(ConnectionEvent.RECEIVE_MESSAGE, receiveMessage)`

-------------------------

`LocalConnection` 자체가 그리 안정적인 기능성을 가졌다고 보기엔 어렵다.

가능하면 사용하지 말고, 불가피 할 경우 사용하도록 한다.

Web 에서 AIR 측으로 일방적인 메세지를 보내는 케이스는 이 `Connection` 기능 보다는 `badge` 를 사용해서 **Browser Invocation** 을 활용하는 편이 좋다.

AIR 측에서 Web 으로 메세지를 보내야 하는 경우에만 사용을 하는 편이 좋고, 에러 처리는 민감하게 해둬야 한다. 