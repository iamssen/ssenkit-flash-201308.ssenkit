망할 수학 공부의 목표는?

1. 수학적 기호들을 코드로 해석해낼 수 있다
1. 여러 수학적 연산에 필요한 공식들을 알 수 있다
1. 수식의 정리를 통해서 필요한 값들을 역산해낼 수 있다

# 수학 기호의 코드화

- ![](http://www.forkosh.com/mathtex.cgi?{a}^{2}) `Math.pow(a, 2)`
- ![](http://www.forkosh.com/mathtex.cgi?a=\sqrt{2}) `Math.sqrt(2)`
					 

# 방정식

## 계산 우선순위

1. 괄호 (5 + 4) * 5 = 9 * 5 = 45
1. 지수 4 * 3<sup>2</sup> = 4 * 9 = 36
1. 곱셈, 나눗셈 5 + 4 * 3 = 5 + 12 = 17
1. %
1. 더하기, 빼기

## 덧셈과 곱셈의 성질

교환법칙

	a + b = b + a
	a * b = b * a

결합법칙

	(a + b) + c = a + (b + c)
	(a * b) * c = a * (b * c)

분배법칙

	a * (b + c) = (a * b) + (a * c)
	(b + c) * a = (b * a) + (c * a)

## 등식의 성질

	if (a == b)   
		a + c = b + c
		a - c = b - c   
		a * c = b * c
		
		if (c !== 0) // c 가 0 이 아니라면   
			a / c = b / c
			
## 곱셈표 생략 규정

`2abc` 는 `2 * a * b * c` 와 같다.

`2abc + 45abc = 47abc` 와 같이 하나의 단위로서 연산이 가능하다

- `10 * x + 5 * x - 35 = x + 7`
	- `10x + 5x - 35 = x + 7`
		- `10x + 5x - x = 7 + 35` 이항 성질은 **양변에 x 를 빼고, 35 를 더한다는 개념이 된다**
			- `14x = 42`
				- `x = 42 / 14 = 3`

## 이항 성질

이항 성질은 기본적으로 등식의 성질을 이용한다.

- `x + 3 = 5` 이와 같은 등식이 있다면
	- `x + 3 - 3 = 5 - 3` 과 같이 이항 할 수를 양변에서 빼주고
		- `x = 5 - 3` 과 같은 식으로 이항이 완료되게 된다. 

사칙 연산의 이항은 아래와 같다.

- 덧셈, 뺄셈 이항
	- `x - 3 = 5`
		- `x = 5 + 3`
		
- 곱셈, 나눗셈 이항
	- `x = y * z`
		- `x / y = z` 곱하기는 나누기의 분모로 이항된다
		- `x / z = y`
			- `z = x / y` 분자는 분자로 이항된다
			- `x = y * z` 분모는 곱하기로 이항된다
	- `a / bx = c`
		- `bx = a / c`
			- `x = a / bc` 곱하기는 반대편 분모의 곱하기로 이항된다

## 일차방정식 예제들

- `3x + 2 = 5`
	- `3x = 5 - 2` + 2 를 우변으로 이항
		- `3 * x = 3` 3x 는 3 * x
			- `x = 3 / 3` * 3 을 우변으로 이항
				- `x = 1`
				- `(3 * 1) + 2 = 5` 로 증명
	
- `3x - 2 = 5x + 4`
	- `3x - 5x = 4 + 2` - 2 를 우변으로 이항, + 5x 를 좌변으로 이항
		- `-2x = 6`
			- `-2 * x = 6`
				- `x = 6 / -2`
					- `x = -3`
					- `(3 * -3) - 2 = -11`, `(5 * -3) + 4 = -11` 로 증명
	
- `4x + 2 = 10`
	- `4 * x = 8`
		- `x = 8 / 4`
			- `x = 2`
			- `(4 * 2) + 2 = 10` 으로 증명

- `2x + 2 = 3x - 1`
	- `2x - 3x = -1 - 2`
		- `-1 * x = -3`
			- `x = -3 / -1`
				- `x = 3`
				- `(2 * 3) + 2 = 8`, `(3 * 3) - 1 = 8` 로 증명 
				
- `2(x - 2) + 3 = 5x - 1`
	- `(2 * (x - 2)) + 3 = 5x - 1` 2(x - 2) 은 2x - 4 로 각 항에 곱해줄 수 있다 
		- `2x - 4 + 3 = 5x - 1`
			- `2x - 5x = -1 + 4 - 3` 5x 를 좌변으로 이항, - 4 + 3 을 우변으로 이항
				- `-3x = 0`
					- `x = 0`
					- `(2 * (0 - 2)) + 3 = -1`, `(5 * 0) - 1 = -1` 로 증명

- `2(x - 2) + 1 = -5`
	- `2x - 4 = -6`
		- `2x = -2`
			- `x = -2 / 2`
				- `x = -1`
				- `(2 * (-1 - 2)) + 1 = -5` 로 증명
				
- `(1 / 3)x + (5 / 6) = (7 / 2)`
	- `(1 / 3)x = (42 / 12) - (10 / 12)`
		- `(1 / 3)x = (42 - 10) / 12`
			- `(1 / 3)x = 32 / 12`
				- `x = (32 / 12) / (1 / 3)`
					- `x = 8`
					- `((1 / 3) * 8) + (5 / 6) = 3.5`, `7 / 2 = 3.5` 로 증명
					
- `0.2(x + 1) - 1 = 1.2`
	- `0.2x + 0.2 - 1 = 1.2`
		- `0.2 * x = 1.2 - 0.2 + 1`
			- `0.2 * x = 2`
				- `x = 2 / 0.2`
					- `x = 10`
					- `(0.2 * (10 + 1)) - 1 = 1.200000000002` 로 증명
						

## 문제풀이 "이야기로 쉽게 배우는 대수학" 81 page

1. 시속 30마일로 몇 시간을 가야 3000마일을 갈 수 있을까?
	- `30 * x = 3000`
		- `x = 3000 / 30`
			- `x = 100`
			
1. 서로 100마일 떨어진 거리에서 두 사람이 시속 30마일, 20마일의 속도로 출발했을때, 만나게 되는데 걸리는 시간은?
	- `x(30 + 20) = 100`
		- `x = 100 / 50`
			- `x = 2`

1. 위와 같은 문제에서 두 사람의 속도를 v1, v2 라고 했을때의 계산
	- `x(v1 + v2) = 100`
		- `x = 100 / (v1 + v2)`
		- `function (v1, v2) : x { return 100 / (v1 + v2) }` 수로 떨어지지 않는 계산식 형태의 값은 함수로 정의가 가능할 것 같다
		
1. 48달러를 벌기 위해 일할 때, 힘든 일은 시간 당 12달러를, 쉬운 일은 시간 당 6달러를 벌 수 있다. 48달러를 벌 수 있는 모든 경우를 쓴다면?
	- 힘든 일 시급 `x = 12`, 쉬운 일 시급 `y = 6`, 힘든 일 실행 `a`, 쉬운 일 실행 `b`
		- `b = (48 - ax) / y`
			- `a = 0`, `b = 8`
			- `a = 1`, `b = 6`
			- `a = 2`, `b = 4`
			- `a = 3`, `b = 2`
			- `a = 4`, `b = 0`

1. cd 가격이 12달러, 피자는 6달러, 한 달 용돈은 60 달러 일때 구입 가능한 경우 모두는?
	- cd `x = 12`, 피자 `y = 6`, cd 구입 `a`, 피자 구입 `b`
		- `b = (60 - ax) / y`
			- `a = 0`, `b = 10`
			- `a = 1`, `b = 8`
			- `a = 2`, `b = 6`
			- `a = 3`, `b = 4`
			- `a = 4`, `b = 2`
			- `a = 5`, `b = 0`
			
1. 한 농부는 닭과 말을 키우고 있고, 모든 다리의 총 합은 88개, 날개는 40개, 말과 닭은 몇 마리?
	- 닭의 수 `40 / 2 = 20` 닭의 총 다리 수는 40...
		- `말다리들 = 88 - 40 = 48`
			- `48 / 4 = 12`
			- 증명 말의 수 `x = 12`, 닭의 수 `y = 20`
				- `x4 + y2 = 88`
					- `48 + 40 = 88`
					
1. 도로 엘름과 메이플에 나무 18그루를 심는데, 엘름에 메이플보다 두 배의 나무를 심고 싶다. 몇 개씩 심어야 하는가?
	- `x(2 + 1) = 18`
		- `x = 18 / 3`
		 - `x = 6` 엘름 12 그루, 메이플 6그루
		 
1. 어떤 책의 1장과 2장의 페이지를 합하면 65페이지가 나온다. 그런데 1장이 2장보다 다섯 페이지가 많다. 각각 몇 페이지?
	- `2x + 5 = 65`
		- `2x = 60`
			- `x = 30` 30, 35
			
1. 연속 된 두 수를 더하면 63이 된다. 어떤 수들인가?
	- `2x + 1 = 63`
		- `2x = 62`
			- `x = 31` 31, 32
			
1. 연속 된 세 수를 더하면 75가 된다. 어떤 수들인가?
	- `3x + 3 = 75`
		- `3x = 72`
			- `x = 24` 24, 25, 26
			
1. TJ 가 JR 보다 타이핑이 두 배 빠르다. 모두 600 페이지를 작성했을때 각각 몇 페이지 씩 작성했는가?
	- `x(2 + 1) = 600`
		- `x = 600 / 3`
			- `x = 200` 400, 200
			
1. 서로 660마일 떨어져 있는 도시를 다니는 비행기가 있다. 비행기는 시속 200 마일이지만, 바람의 속도로 3시간이 걸렸다. 바람은 시속 몇 마일?
	- `3(x + 200) = 660`
		- `3x + 600 = 660`
			- `3x = 60`
				- `x = 20`
				
1. 90피트 길이의 철조망이 있고, 길이 2 / 폭 1 의 직사각형 모양의 울타리를 치려고 한다. 길이와 폭은 얼마?
	- `2x(2 + 1) = 90`
		- `2x = 90 / 3`
			- `2x = 30`
				= `x = 15` 길이 30, 폭 15
				
1. 슈는 프레드 보다 3년 더 일했다. 둘의 경력을 합하면 15년. 슈의 경력은?
	- `2x + 3 = 15`
		- `2x = 12`
			- `x = 6` 9년, 6년

1. 청구된 보험금에서 250 달러를 공제 후, 금액의 80% 를 지불한다. 1000 달러를 청구하면 얼마를 받는가?
	- `(1000 - 250) * 0.8 = 600` ????
			
1. 도시 인구가 현재 4,600 명인데, 매년 200명씩 증가. 인구가 두배가 되려면 몇 년이 걸리나?
	- `4600 + 200x = 9200`
		- `200x = 4600`
			- `x = 4600 / 200`
				- `x = 23`



# 분수

## 분수의 계산

- ![](http://www.forkosh.com/mathtex.cgi?\frac{a}{b}\times\frac{c}{d}=\frac{ac}{bd}) 곱하기는 분자끼리, 분모끼리 곱한다
- ![](http://www.forkosh.com/mathtex.cgi?\frac{a}{b}+\frac{c}{b}=\frac{a+c}{b}) 분모가 같다면 분자끼리 더한다
- ![](http://www.forkosh.com/mathtex.cgi?\frac{a}{b}+\frac{c}{d}=\frac{ad}{bd}+\frac{bc}{bd}=\frac{ad+bc}{bd}) 분자, 분모가 모두 다르다면, 분자, 분모에 상대방 분모를 곱해서 같게 만든 다음 결합한다
- ![](http://www.forkosh.com/mathtex.cgi?\frac{a}{b}-\frac{c}{d}=\frac{ad}{bd}-\frac{bc}{bd}=\frac{ad-bc}{bd})
- ![](http://www.forkosh.com/mathtex.cgi?\frac{\frac{a}{b}}{\frac{c}{d}}=\frac{\frac{a}{b}\times\frac{d}{c}}{\frac{c}{d}\times\frac{d}{c}}=\frac{\frac{ad}{cb}}{\frac{cb}{cb}}=\frac{\frac{ad}{cb}}{1}=\frac{ad}{cb}) 복합 분수는 **분모의 역수** 를 분모와 분자에 곱해줘서 정리할 수 있다 ![](http://www.forkosh.com/mathtex.cgi?\frac{\frac{3}{6}}{\frac{3}{4}}=\frac{\frac{3}{6}\times\frac{4}{3}}{\frac{3}{4}\times\frac{4}{3}}=\frac{\frac{12}{18}}{\frac{12}{12}}=\frac{\frac{12}{18}}{1}=\frac{12}{18})
- ![](http://www.forkosh.com/mathtex.cgi?\frac{ac}{bc}=\frac{a}{b}) 약분, 같은 값으로 나누든 곱하든 분수의 비율엔 변화가 없다
- ![](http://www.forkosh.com/mathtex.cgi?\frac{-a}{-b}=\frac{a}{b}) 분자에 같은 값을 곱하면 같다는 성질에서, ![](http://www.forkosh.com/mathtex.cgi?\frac{-1}{-1}=1) 이다
- ![](http://www.forkosh.com/mathtex.cgi?\frac{-a}{b}=-\frac{a}{b}) 
- ![](http://www.forkosh.com/mathtex.cgi?\frac{a}{-b}=-\frac{a}{b}) 
- ![](http://www.forkosh.com/mathtex.cgi?-\frac{-a}{-b}=-\frac{a}{b})
- 예제들 중 분모는 모두 0 이 아니어야 함

## 문제풀이 "이야기로 쉽게 배우는 대수학" 127 page

이거 왜... 책의 해답들이 죄다 틀린 답이냐?

1. `4x = 36`
	- `x = 36 / 4`
	
1. `3x = 8`
	- `x = 8 / 3`
	
1. `24x = 60`
	- `x = 60 / 24`
	
1. `5x + 10 = 6`
	- `5x = 6 - 10`
		- `x = (6 - 10) / 5`
		
1. `ax = b`
	- `x = b / a`
	
1. `ax - b = c`
	- `ax = c + b`
		- `x = (c + b) / a`
		
1. `ax + b = cx + d`
	- `ax - cx = d - b`
		- `x(a - c) = d - b`
			- `x = (d - b) / (a - c)`

1. `ax / b = c`
	- `ax = cb`
		- `x = cb / a`

1. `a / bx = c`
	- `bx = a / c`
		- `x = a / bc` 
		
1. `(ax / b) + (cx / d) = e`
	- `(axd + cxb) / bd = e` 
		- `axd + cxb = ebd`
			- `x * (ad + cb) = ebd`
				- `x = ebd / (ad + cb)`
				
1. `(a / bx) + (c / d) = e`
	- `a / bx = e - (c / d)`
		- `bx = a / (e - (c / d))`
			- `x = a / ((e - (c / d)) * b)`

## 문제풀이 "이야기로 쉽게 배우는 대수학" 135 page

1. 합성세제를 살 때 12온스 짜리를 1.16달러, 16온스 짜리를 1.4달러에 사는 것 중 더 나은것은?
	- 기준을 맞추기 위해 **1 온스 당 달러**를 구한다 `(1.4 / 16)` 그런 다음 상대편 기준 온스에 맞게 곱해준다 `(1.4 / 16) * 12`
	- `(1.4 / 16) * 12 = 1.049`달러가 1.16 달러보다 더 싸다
	
1. 세전 수입을 y 라고 하고, 정부에서 세금으로 ![](http://www.forkosh.com/mathtex.cgi?\frac{1}{4}y-10)만큼 떼어갔을때, 세후 수입이 280만 달러라면 세전 수입은 얼마?
	- `y - ((1 / 4)y - 10) = 280`
		- `y - (y / 4) - 10 = 280`
			- `y - (y / 4) = 270`
				- `(4y / 4) - (y / 4) = 270`
					- `(4y - y) / 4 = 270`
						- `3y / 4 = 270`
							- `3y = 270 * 4`
								- `y = 1080 / 3 = 360`
								
1. 응원하는 팀이 처음 20경기 중 60% 를 승리했다. 남은 경기가 10경기라면 몇 경기를 이겨야 승률이 65% 가 되는가?
	- 최종 승리할 경기 30경기의 65% - 지난 승리한 경기 20경기의 60% `percentage / value * 100`
		- `((20 + 10) * 65 / 100) - (20 * 60 / 100) = 7.5`
	
1. 어떤 야구선수가 500타석, 타율 0.290 일때, 대략 남은 16타석에서 타율을 0.300 으로 만들기 위해서는 안타를 몇 개 더 쳐야 하나?
	- 최종 타율 516타석의 30% - 지난 타율 500타석의 29% `percentage / value * 100`
		- `((500 + 16) * 30 / 100) - (500 * 29 / 100) = 9.8`
	
1. 혼합액 10갤런은 70%는 용액A, 30%는 용액B 이다. 용액 B 비율을 42% 로 증가시키려면 B 를 얼마나 더 넣어야 하나?
	- 용액B 의 30% 를 추가적 12% 증가시킴 `percentage / value * 100`, `value * (1 + add percentage / 100)` 을 합성
		- `(10 * 30 / 100) * (1 + 12 / 100) = 3.36`
		
1. 부모 나이가 아이보다 25살 많다면 아이가 몇 살 때 부모 나이가 아이보다 2배 많아지는가?
	- `x + 25 = 2x`
		- `x - 2x = -25`
			- `-x = -25`
				- `x = 25`
	- 세배는?
		- `x + 25 = 3x`
			- `x - 3x = -25`
				- `-2x = -25`
					- `x = 12.5`

1. 고속도로에서는 일반도로보다 두배 빠르다. 하지만, 고속도로에 들어가고 나오는데 15분이 걸린다. 얼마 이상의 거리를 가야 고속도로로 이득을 볼 수 있는가?
	

# 지수법칙

## 제곱과 제곱근
 
- ![](http://www.forkosh.com/mathtex.cgi?{a}^{2}=2)
- ![](http://www.forkosh.com/mathtex.cgi?a=\sqrt{2})

## 지수의 연산

- a<sup>m</sup>+a<sup>n</sup>=a<sup>m+n</sup>
- (a<sup>m</sup>)<sup>n</sup> = a<sup>mn</sup>
- (ab)<sup>n</sup> = a<sup>n</sup>b<sup>n</sup>


# 곱셈공식

- (a + b)<sup>2</sup> = a<sup>2</sup> + 2ab + b<sup>2</sup> `Math.pow(a + b, 2) = Math.pow(a, 2) + (2 * a * b) + Math.pow(b, 2)`
- (a - b)<sup>2</sup> = a<sup>2</sup> - 2ab + b<sup>2</sup>
- (a + b)(a - b) = a<sup>2</sup> - b<sup>2</sup>
- (a + b + c)<sup>2</sup> = a<sup>2</sup> + b<sup>2</sup> + c<sup>2</sup> + 2ab + 2bc + 2ca
- (x + a)(x + b) = x<sup>2</sup> + (a + b)x + ab
- (a + b)<sup>3</sup> = a<sup>3</sup> + 3a<sup>2</sup>b + 3ab<sup>2</sup> + b<sup>3</sup>
- (a - b)<sup>3</sup> = a<sup>3</sup> - 3a<sup>2</sup>b + 3ab<sup>2</sup> - b<sup>3</sup>
- (a + b)(a<sup>2</sup> - ab + b<sup>2</sup>) = a<sup>3</sup> + b<sup>3</sup>
- (a - b)(a<sup>2</sup> + ab + b<sup>2</sup>) = a<sup>3</sup> - b<sup>3</sup>
- (a + b + c)(a<sup>2</sup> + b<sup>2</sup> + c<sup>2</sup> - ab - bc - ca) = a<sup>3</sup> + b<sup>3</sup> + c<sup>3</sup> - abc
- (x + a)(x + b)(x + c) = x<sup>3</sup> + (a + b + c)x<sup>2</sup> + (ab + bc + ca)x + abc

- a<sup>2</sup> + b<sup>2</sup> = (a + b)<sup>2</sup> - 2ab
- a<sup>2</sup> + b<sup>2</sup> + c<sup>2</sup> = (a + b + c)<sup>2</sup> - 2(ab + bc + ca)
 
 





