/// Example
package ssen.common.date {
import de.polygonal.ds.Array2;

public class Day__Example {

	// 일년 중 몇 번째 날인지 확인
	[Test]
	public function dayOfYear():void {
		var t:Date=new Date;
		var d1:Date=new Date(t.fullYear, 0, 1);
		var day:Day=new Day(d1);

		var f:int=-1;
		var fmax:int=100;
		while (++f < fmax) {
			trace("DayTest.dayOfYear()", day, day.dayOfYear, day.weekOfMonth, day.weekOfYear);
			day=day.getNextDay();
		}
	}

	// 월 달력을 위한 2차원 XY Grid 를 만든다
	[Test]
	public function createMonthlyGrid():void {
		// 이번달의 첫째날을 찾는다
		var day:Day=new Day().getFirstDayOfMonth();

		// 이번달의 마지막날을 찾는다
		var last:Day=new Day().getLastDayOfMonth();

		// 달력의 최소 가능 그리드 7 x 4 생성
		var arr:Array2=new Array2(7, 4);

		// x index 를 요일로 맞춘다
		var x:int=day.date.day;
		var y:int=0;

		// 이번달이 아니게 될 때까지 반복
		while (day.equalMonth(last)) {
			trace("DayTest.createMonthlyGrid()", day.weekOfMonth, day.dayOfYear);
			arr.set(x, y, day);

			day=day.getNextDay();
			x++;

			if (x > 6) {
				x=0;
				y++;

				if (y + 1 > arr.getH()) {
					arr.setH(y + 1);
				}
			}

		}

		trace("DayTest.getMonthlyGrid()", arr);
	}

	// 일주일을 그리기 위한 배열을 만든다
	[Test]
	public function createWeeklyGrid():void {
		// 이번주의 첫째날을 찾는다
		var day:Day=new Day().getFirstDayOfWeek();

		// 7일치를 증가 반복
		var f:int=-1;
		var fmax:int=7;
		var arr:Vector.<Day>=new Vector.<Day>(fmax, true);

		while (++f < fmax) {
			arr[f]=day;
			day=day.getNextDay();
		}

		trace("DayExample.createWeeklyGrid()", arr);

	}
}
}
