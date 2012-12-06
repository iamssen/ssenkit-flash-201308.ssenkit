# Form Container 제작

Form 형태의 Table 구성을 편하게 하기 위해서 만들 필요가 있다...

과연 어떻게 구현해야 할지는 미지수.

Table 형태는 그냥 분리시키는게 더 좋을지도 애매... 문제는 percentage 기반의 동적 사이즈 조절일듯 싶다.

## 목표로 하는 코드 스타일

	<form:FormContainer width="100%" height="100%" graphicsRenderer="foo.renderers.FormContainerRenderer">
		<!-- 일반적인 직렬형 배치 -->
		<form:FormContainerRow height="40">
			<form:FormContainerHeaderCell width="45" horizontalAlign="center" verticalAlign="middle">
				<form:FormLabel text="xxx" />
			</form:FormContainerHeaderCell>
			<form:FormContainerDataCell width="25%">
				<s:TextInput />
			</form:FormContainerDataCell>
		</form:FormContainerRow>
		<!-- 특수한 경우의 header 한 개에, 여러 data cell 이 배치될 경우 -->
		<form:FormContainerRow height="40">
			<form:FormContainerHeaderCell width="45">
				<form:FormLabel text="xxx" />
			</form:FormContainerHeaderCell>
			<form:FormContainerDataCell width="25%">
				<s:Group width="100%" height="100%">
					<s:layout>
						<s:VerticalLayout />
					</s:layout>
					<s:TextInput />
					<form:FormContainerHorizontalLine />
					<s:TextInput />
					<form:FormContainerHorizontalLine />
					<s:TextInput />
				</s:Group>
			</form:FormContainerDataCell>
		</form:FormContainerRow>
	</form:FormContainer>
	
	// form container 의 height 는 지정할 수 없다. 무시하고 자동계산된다
	// form container row 의 height 는 percent 로 입력할 수 없다
	// form container 는 row 와 cell 들을 읽어들여서 container width 에 대입해서 각 rect 들을 계산해낸다
	// 하위의 cell 들은 form container 를 읽어들여서 하위의 구성물들을 addChild 시켜준다 
	// 하위의 cell 들은 하위의 구성물들의 percentWidth, width 등을 읽어들여서 rect 에 맞게 배치해준다
	
	// graphics update 가 이루어지는 시점들
	// form container 의 width 가 변경될 때 (percent 에 의해서건, 수치 입력에 의해서건)
	// form container row 의 height 가 변경될 때
	// form container row 의 includeInLayout 옵션이 변경될 때
	// form container cell 의 width 옵션이 변경될 때
	
	// 단순 cell 의 정렬만이 이루어질 경우
	// form container cell 의 vertical, horizontal align 옵션들이 변경될 때 
	
	interface GraphicsRenderer extends IDeconstructable {
		function draw(component:String, part:String, 
							canvas:Sprite, state:String,
									x:Number, y:Number, width:Number, height:Number, 
											option:Object = null):void;
	}
