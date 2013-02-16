Encoding Test

# ASDoc

## Ant Task

**build.properties**

	global.sdk=/Data/settings/flex_sdk_4.6.0.23201B
	global.exe.asdoc=${global.sdk}/bin/asdoc
	global.exe.compc=${global.sdk}/bin/compc
	global.lib=${global.sdk}/frameworks/libs
	global.debug.player=/Applications/Flash Player Debugger.app
	project.src=src
	project.lib=lib
	project.example=../SSenMvcFramework.ASDoc/src
	output.asdoc=bin/asdoc
	output.swf=bin
	output.swc=bin

**build.ant**
	
	<project name="ssen mvc framework build" default="create asdoc">
		<property file="build.properties" />
	
		<taskdef resource="flexTasks.tasks" classpath="${global.sdk}/ant/lib/flexTasks.jar" />
	
		<target name="create asdoc">
			<delete dir="${output.asdoc}" failOnError="false" includeEmptyDirs="true" />
			<mkdir dir="${output.asdoc}" />
	
			<exec executable="${global.exe.asdoc}">
				<arg line='-source-path ${project.src}' />
				<arg line='-examples-path ${project.example}' />
				<arg line='-doc-sources ${project.src}/ssen' />
				<arg line="-library-path ${project.lib}" />
				<arg line="-library-path ${global.lib}/player/11.3" />
				<arg line="-library-path ${global.lib}" />
				<arg line='-window-title "SSen MVC Framework ASDoc"' />
				<arg line='-main-title "SSen MVC Framework ASDoc"' />
				<arg line='-output ${output.asdoc}' />
			</exec>
		</target>
	</project>
	
## ASDoc Parameters

- `-keep-xml=true` xml 파일을 삭제하지 않고 남긴다

## ASDoc Tags

[ASDoc Tags]

- `@private` 문서 상에 요소가 나타나지 않게 한다.
- `@inheritDoc` 상속 관계에 있는 class 나 구현 관계에 있는 interface 의 주석을 사용한다.
- `@see ${reference}` 해당 요소에 대한 참조를 추가한다. [ASDoc Reference Selector]
- `@includeExample ${file}` 예제 코드를 추가한다. (includeExample 로 불러오는 file 은 utf-8 이면 한글이 깨진다. euc-kr 로 해야한다.)
- `@param ${parameter name} ${description}` method 의 parameter 를 설명한다.
- `@throws ${package.errors.ErrorClass} ${description}` 실행시 발생 가능한 Error 를 설명한다.
- `@return ${description}` method 의 return value 를 설명한다.

[ASDoc Reference Selector]

- resource selector 
	- `@see http://ssen.name ${description}` website
	- `@see example.html ${description}` local file
- api selector
	- class and class members
		- `@see #variable ${description}`
		- `@see #method() ${description}`
		- `@see #event:change ${description}`
		- `@see #style:paddingLeft ${description}`
		- `@see #effect:creationCompleteEffect ${description}`
		- `@see Class#variable ${description}`
		- `@see Class#method() ${description}`
		- `@see Class#event:change ${description}`
		- `@see Class#style:paddingLeft ${description}`
		- `@see Class#effect:creationCompleteEffect ${description}`
		- `@see fl.test.Class#variable ${description}`
		- `@see fl.test.Class#method() ${description}`
		- `@see fl.test.Class#event:change ${description}`
		- `@see fl.test.Class#style:paddingLeft ${description}`
		- `@see fl.test.Class#effect:creationCompleteEffect ${description}`
	- package members
		- `@see fl.test.#variable ${description}`
		- `@see fl.test.#metod() ${description}`
	
[ASDoc Tags]:http://help.adobe.com/en_US/flex/using/WSd0ded3821e0d52fe1e63e3d11c2f44bc36-7ff6.html
[ASDoc Reference Selector]:http://help.adobe.com/en_US/flex/using/WSd0ded3821e0d52fe1e63e3d11c2f44bc36-7ff8.html