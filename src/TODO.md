# 만들어야 할 것들

## Python SWC Build Script

`python swc.py build.xml` 과 같은 형태의 실행을 통해서 swc 파일을 빌드하도록 자동화 해주는 script 를 만든다

	<xml>
		<build type="swc" to="ssenkit.swc">
			<libraries>
				<swc>d:/flex-framework/frameworks/playerglobal.swc</swc>
				<swc>ssenkit/lib/ds.swc</swc>
				<src>f:/library/tweenlite</src>
			</libraries>
			<imports>
				<src>ssenkit/src</src>
			</imports>
		</build>
		
		<build type="swc" to="ssenkit.air.swc">
			<libraries>
				<swc>d:/flex-framework/frameworks/air/playerglobal.swc</swc>
				<swc>ssenkit/lib/ds.swc</swc>
				<src>f:/library/tweenlite</src>
			</libraries>
			<imports>
				<src>ssenkit/src</src>
				<src>ssenairkit/src</src>
			</imports>
		</build>
	</xml> 
	
위와 같은 형태로 xml 을 정의하면 되고, src 내에서 `__Example` 로 기재된 파일들은 배제시켜준다.

# 정리해야 하는 과거 자료들

## Common

1. (ssen.common) 각 종 유틸들
	- examples.math : snippet 으로 정리
	- 각 종, 수학, 기하학, 움직임 등에 대한 알고리즘들을 모두 여기에 정리... 
		- 수학식 정리 뿐만이 아니라, 수학으로 할 수 있는 일들에 대한 정리 역시 같이 한다 (이게 가장 중요)
		- 무엇을 할 수 있는가? 그리고, 그에 대한 해답... 

1. (ssen.common) Worker 관련 유틸들

## UIKit
1. (ssen.uikit.graphics)
	- DrawTrianglesExample : snippet 으로 전환
	- DrawMatrixExample : library 로 전환, 문서화 
	- examples.math : 알고리즘 문서화, snippet 으로 전환
	
## github.recipe.node.js 예제들 정리하기

꽤 좋은 것들이 많잖아...;;;

# 이벤트와 렌더링의 명시적인 결합과 분할

- 스크롤바에 대한 케이스를 명시적으로 코드로 정리해보자… 이벤트가 들어가는 시점들과 렌더링이 이루어지는 시점들을 코드 블럭으로 만들어서 명시적으로 정리해놓으면 언젠가는 쓸모가 클거다
- 현재 대시보드 프로젝트의 터치 이벤트들과 Data 로드 프로그레스, 에러 드로잉 처리, MVC 모듈구조, 이벤트 구조 등 여러 복잡한 조건식들을 명시적으로 정리해보자
