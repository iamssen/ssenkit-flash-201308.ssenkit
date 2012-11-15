# e4x 형식을 사용한 필터링

- 기본적으로 `node.list.(boolean)` 형태로 필터링 된 XMLList 를 만들어낼 수 있다.
- 지정한 list 의 하위 method 를 다룰 수 있는듯 싶다.
- 상당히 피곤하다. 왠만하면 쓰지 말자...

# 검색 방식들

	<xml>
		<a bbb="123" />
		<a ccc="223" />
		<a>
			<bb>35</bb>
			<bb cc="125">Schall</bb>
			<bb>Smith</bb>
			<bb>Schala</bb>
			<cc aa="123">55</cc>
		</a>
		<a bbb="145" />
		<a bbb="1234" />
		<bb>66</bb>
	</xml>

## node 다루기

node 의 name 을 가져오는 `name()` 을 정규식 검사를 통해 필터링 한다

	var xlist:XMLList=xml..*;
	
	trace(xlist.(name()==="bb").toXMLString());
	// 

	trace(xlist.(/bb/.test(name())).toXMLString());
	// <bb>35</bb>
	// <bb cc="125">Schall</bb>
	// <bb>Schala</bb>
	// <bb>66</bb>
	
	trace(xlist.(/a+/.test(name())).toXMLString());
	// <a bbb="123"/>
	// <a ccc="223"/>
	// <a>
	//   <bb>35</bb>
	//   <bb cc="125">Schall</bb>
	//   <aa>Smith</aa>
	//   <bb>Schala</bb>
	//   <cc aa="123">55</cc>
	// </a>
	// <aa>Smith</aa>
	// <a bbb="145"/>
	// <a bbb="1234"/>

문제는 `xlist.(boolean)` 을 기초로 하는듯 보이는데도 불구하고, `name()==="bbb"` 는 제대로 작동되지 않는다는 것이다.

> 정규식 필터링이 구지 필요없는 경우엔
> 단순하게 `xlist..bb` 를 통해 가져오는게 좋을듯 싶다

node value 의 경우는 `toString()` 을 정규식 검사를 통해 필터링 한다 
	
	var xlist:XMLList=xml.a.bb;
	
	trace(xlist.(/Sch.*?/.test(toString())).toXMLString());
	// <bb cc="125">Schall</bb>
	// <bb>Schala</bb>

## attribute 다루기

attribute 의 이름을 가져오는 방식은 없다. 그래서, 특정 attribute 의 이름으로 검색하는데는 문제가 약간 있는듯...

	var xlist:XMLList=xml.a;
	
	trace(xlist.attribute("bbb").toXMLString());
	// 123
	// 145
	// 1234
	
문제는 node 단위로 가져오는게 아니라는 것

attribute value 의 경우에는 `attributes()` 를 사용한다.

	var xlist:XMLList=xml["a"].*;
	
	trace(xlist.(/12.*?/.test(attributes())).toXMLString());
	// <bb cc="125">Schall</bb>
	// <cc aa="123">55</cc>
	
	xlist=xml["a"][2].cc;
	trace(xlist.(@aa == "123").toXMLString());
	// <cc aa="123">55</cc>
	
