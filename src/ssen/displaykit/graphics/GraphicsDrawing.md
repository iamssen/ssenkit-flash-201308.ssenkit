# 사용 가능한 Draw Container

- `Shape`, `Sprite`
	- MXML Container 상에 직접 쓸 수 없다
	- 그리고, 난 뒤 size 가 자동 계산된다
	
- `SpriteVisualElement`
	- MXML Container 상에 쓸 수 있다
	- size 자동 계산이 되지 않는다 `width`, `height` 를 수동으로 지정해줘야 한다
	
# Bitmap Drawing 시 Matrix 계산

- 이동
	- `tx=100`
	- `ty=100`
	
- 크기
	- `a=canvas.width / bitmap.width` 리사이즈 해야하는 `canvas.width` 를 소스의 `bitmap.width` 로 나눈 비율치 
	- `d=canvas.height / bitmap.height`

# 3D Triangle Drawing

비트맵 Skew 등에 사용할 수 있는 Graphics 기능 이다. 

- `vertices` 삼각형을 그릴 수 있는 x 또는 y 좌표 쌍을 가지게 된다
	- 삼각형 두개를 합친 사각형 맵은 아래와 같다 
	- 0 : top left x
	- 1 : top left y
	- 2 : top right x
	- 3 : top right y
	- 4 : bottom left x
	- 5 : bottom left y
	- 6 : bottom right x
	- 7 : bottom right y 
	
- `indices` 삼각형을 그려나가는 순서 정보를 가진다. `vertices` 를 참고하는 순서를 지정하게 된다. 
	- 예를 들어 사각형을 그리는데 사용될 수 있는 `[0, 1, 2, 1, 3, 2]` 는 `vertices` 의 `[(top left 0, 1), (top right 2, 3), (bottom left 4, 5), (top right 2, 3), (bottom right 6, 7), (bottom left 4, 5)]` 의 순서로 삼각형을 맵핑하라는 의미를 지니게 된다
	
- `uvData` 삼각형의 bitmap x 또는 y 좌표를 지정한다. `vertices` 와 1 대 1 로 매치되어서, 해당 x, y 좌표와 bitmap 의 어떤 x, y 좌표를 매칭시킬지를 지정하게 된다
	- bitmap texture 의 width, height 를 비율적으로 1 로 보고, 각각 맵핑할 좌표를 맵핑한다
	
이와 같은 구성을 Skew 형태의 사각형으로 만들면 아래와 같이 된다

	// triangle setting. top left, top right, bottom left, bottom right
	var vertices : Vector.<Number> = new <Number>[0, 0, 80, 20, 0, 100, 80, 80];
	
	// tl --> tr --> dl , tr --> dr --> dl 순서로 삼각형을 그림
	var indices : Vector.<int> = new <int>[0, 1, 2, 1, 3, 2];
	
	// vertices 와 1 : 1 매치, bitmapData.width 를 1 로 취급 100분율로 bitmapData 를 맵핑
	var uvData : Vector.<Number> = new <Number>[0, 0, 1, 0, 0, 1, 1, 1];
	
	// draw
	graphics.beginBitmapFill(bitmapData, null, false, true);
	graphics.lineStyle(1, 0x000000);
	graphics.drawTriangles(vertices, indices, uvData, TriangleCulling.NONE);
	graphics.endFill();