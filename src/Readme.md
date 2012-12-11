# Packages

- `ssen.airkit.*` AIR 플랫폼의 기술적인 특성 구현 (업데이트, 웹 설치, 웹과의 통신 등) 을 하는데 필요한 도구들 모음

- `ssen.common.date` 날짜와 시간 등을 다루는데 필요한 도구들 모음
- `ssen.common.ds` 데이터 구조 들을 다룬다

- `ssen.datakit.asyncunits` 비동기 데이터 서비스 모음
- `ssen.datakit.file` 파일을 다루는데 필요한 도구들 모음
- `ssen.datakit.http` HTTP 스펙과 통신을 다루는데 필요한 도구들 모음
- `ssen.datakit.sql` SQLite 도구들 모음
- `ssen.datakit.updownloader` File Updownloader Base Module

- `ssen.devkit.*` 개발에 필요한 잡다한 도구들

- `ssen.mvc` MVC Framework

- `ssen.uikit.chart` Flex Chart Components
- `ssen.uikit.components`  Flex Components
- `ssen.uikit.form` Flex 에서 Form 양식을 만들때, Input Component 들을 좀 더 쉽게 컨트롤 하기 위한 Helper Utils 
- `ssen.uikit.graphics` Graphics Drawing API 를 다루는데 필요한 도구들 모음
- `ssen.uikit.layouts` Flex Visual Element Container Layout 모음
- `ssen.uikit.text` Text 를 다루는데 필요한 도구들 모음


# 필요한 작업들

## Examples 파일들 분리

컴파일이 느려진다... 

## 예제 카테고리들 정리

- inbox
	- Books 각 종 책들의 요약 및 해석을 적는다


# 정리해야 하는 과거 자료들

## github.recipe.node.js 예제들 정리하기

꽤 좋은 것들이 많잖아...;;;

# 이벤트와 렌더링이 복합적으로 구성된 UI 의 코드를 정리

- 스크롤바에 대한 케이스를 명시적으로 코드로 정리해보자… 이벤트가 들어가는 시점들과 렌더링이 이루어지는 시점들을 코드 블럭으로 만들어서 명시적으로 정리해놓으면 언젠가는 쓸모가 클거다
- 현재 대시보드 프로젝트의 터치 이벤트들과 Data 로드 프로그레스, 에러 드로잉 처리, MVC 모듈구조, 이벤트 구조 등 여러 복잡한 조건식들을 명시적으로 정리해보자


# 추가적으로 작업 할 것들

- 데이터 그리드 고급화 (아무래도 더럽게 많이 쓰이니...) 문서 작성


#방향

- 수학, 알고리즘적 문제들 정리
	- 그림을 그릴 수 있는 툴이 절실하다. 손필기 형태의 메모가 많이 필요하다.
- 다른 플랫폼 접근
- 다른 언어 접근

일단은 다른 언어들에 접근해 보는게 짧고, 간단하게 접근이 가능하지 않을까 싶다.

일단은 `ssen.common`, `ssen.mvc` 에 해당하는 문제들에 접근해 보는 것이 좋겠다.

공부 순서들

1. Type 종류, Type casting 방식
1. `Console.log` 찍기
1. Array, Vector collection
	- `.length`
	- `.indexOf()`
	- `.join()`
	- `.push()`, `.pop()`
	- `.unshift()`, `.shift()`
	- `.reverse()`
	- `.sort()`