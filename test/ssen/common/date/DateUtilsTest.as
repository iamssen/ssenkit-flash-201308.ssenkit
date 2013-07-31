package ssen.common.date {
import ssen.devkit.Should;

public class DateUtilsTest {

	[Test]
	public function getLastDay():void {
		Should.equal(DateUtils.getLastDay(1990, 0), 31);
		Should.equal(DateUtils.getLastDay(1990, 1), 28);
		Should.equal(DateUtils.getLastDay(1990, 2), 31);
		Should.equal(DateUtils.getLastDay(1990, 3), 30);
		Should.equal(DateUtils.getLastDay(1990, 4), 31);
		Should.equal(DateUtils.getLastDay(1990, 5), 30);
		Should.equal(DateUtils.getLastDay(1990, 6), 31);
		Should.equal(DateUtils.getLastDay(1990, 7), 31);
		Should.equal(DateUtils.getLastDay(1990, 8), 30);
		Should.equal(DateUtils.getLastDay(1990, 9), 31);
		Should.equal(DateUtils.getLastDay(1990, 10), 30);
		Should.equal(DateUtils.getLastDay(1990, 11), 31);

		Should.equal(DateUtils.getLastDay(2013, 0), 31);
		Should.equal(DateUtils.getLastDay(2013, 1), 28);
		Should.equal(DateUtils.getLastDay(2013, 2), 31);
		Should.equal(DateUtils.getLastDay(2013, 3), 30);
		Should.equal(DateUtils.getLastDay(2013, 4), 31);
		Should.equal(DateUtils.getLastDay(2013, 5), 30);
		Should.equal(DateUtils.getLastDay(2013, 6), 31);
		Should.equal(DateUtils.getLastDay(2013, 7), 31);
		Should.equal(DateUtils.getLastDay(2013, 8), 30);
		Should.equal(DateUtils.getLastDay(2013, 9), 31);
		Should.equal(DateUtils.getLastDay(2013, 10), 30);
		Should.equal(DateUtils.getLastDay(2013, 11), 31);
	}
}
}
