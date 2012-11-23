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
