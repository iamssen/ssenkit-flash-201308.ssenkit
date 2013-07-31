package ssen.common {
import flash.utils.setTimeout;

public class AsyncTest {

	[Test]
	public function whilst(done:Function):void {
		var data:Array=["a", "aa", "aaa", "aaaa", "aaaaa", "aaaaaa", "aaaaaaa", "aaaaaaaa", "aaaaaaaaa"];

		var f:int=-1;
		var fmax:int=data.length;

		function test():Boolean {
			return ++f < fmax;
		}

		function task(next:Function):void {
			setTimeout(function():void {
				var str:String=data[f];
				next(null, str.length);
			}, 100);
		}

		function complete(error:Error=null, values:Array=null):void {
			var f:int=-1;
			var fmax:int=values.length;
			var error:Error=null;
			while (++f < fmax) {
				if (f + 1 !== values[f]) {
					error=new Error(StringUtils.formatToString("not equal {0}, {1}", f + 1, values[f]));
				}
			}
			done(error);
		}

		Async.whilst(test, task, complete);
	}

	[Test]
	public function times(done:Function):void {
		var data:Array=["a", "aa", "aaa", "aaaa", "aaaaa", "aaaaaa", "aaaaaaa", "aaaaaaaa", "aaaaaaaaa"];

		function task(i:int, next:Function):void {
			setTimeout(function():void {
				var str:String=data[i];
				next(null, str.length);
			}, 100);
		}

		function complete(error:Error=null, values:Array=null):void {
			var f:int=-1;
			var fmax:int=values.length;
			var error:Error=null;
			while (++f < fmax) {
				if (f + 1 !== values[f]) {
					error=new Error(StringUtils.formatToString("not equal {0}, {1}", f + 1, values[f]));
				}
			}
			done(error);
		}

		Async.times(data.length, task, complete);
	}

	[Test]
	public function timesSeries(done:Function):void {
		var data:Array=["a", "aa", "aaa", "aaaa", "aaaaa", "aaaaaa", "aaaaaaa", "aaaaaaaa", "aaaaaaaaa"];

		function task(i:int, next:Function):void {
			setTimeout(function():void {
				var str:String=data[i];
				next(null, str.length);
			}, 100);
		}

		function complete(error:Error=null, values:Array=null):void {
			var f:int=-1;
			var fmax:int=values.length;
			var error:Error=null;
			while (++f < fmax) {
				if (f + 1 !== values[f]) {
					error=new Error(StringUtils.formatToString("not equal {0}, {1}", f + 1, values[f]));
				}
			}
			done(error);
		}

		Async.timesSeries(data.length, task, complete);
	}

	[Test]
	public function waterfall(done:Function):void {
		function a(callback:Function):void {
			setTimeout(function():void {
				callback(null, 1, 2);
			}, 100);
		}

		function b(a1:int, a2:int, callback:Function):void {
			setTimeout(function():void {
				callback(null, a1, a2, 3, 4);
			}, 100);
		}

		function c(a1:int, a2:int, b1:int, b2:int, callback:Function):void {
			setTimeout(function():void {
				callback(null, a1, a2, b1, b2, 5, 6, 7, 8, 9);
			}, 100);
		}

		function complete(error:Error=null, values:Array=null):void {
			var f:int=-1;
			var fmax:int=values.length;
			var error:Error=null;
			while (++f < fmax) {
				if (f + 1 !== values[f]) {
					error=new Error(StringUtils.formatToString("not equal {0}, {1}", f + 1, values[f]));
				}
			}
			done(error);
		}

		Async.waterfall(new <Function>[a, b, c], complete);
	}

	[Test]
	public function series(done:Function):void {
		var tasks:Object={};

		tasks.one=function(callback:Function):void {
			setTimeout(function():void {
				callback(null, 1);
			}, 100);
		};
		tasks.two=function(callback:Function):void {
			setTimeout(function():void {
				callback(null, 2);
			}, 100);
		};
		tasks.three=function(callback:Function):void {
			setTimeout(function():void {
				callback(null, 3);
			}, 100);
		};

		function complete(error:Error=null, values:Object=null):void {
			var error:Error=null;
			if (values.one !== 1 && values.two !== 2 && values.three !== 3) {
				error=new Error(StringUtils.formatToString("not equal one={0} two={1} three={2}", values.one, values.two, values.three));
			}
			done(error);
		}

		Async.series(tasks, complete);
	}

	[Test]
	public function parallel(done:Function):void {
		var tasks:Object={};

		tasks.one=function(callback:Function):void {
			setTimeout(function():void {
				callback(null, 1);
			}, 100);
		};
		tasks.two=function(callback:Function):void {
			setTimeout(function():void {
				callback(null, 2);
			}, 100);
		};
		tasks.three=function(callback:Function):void {
			setTimeout(function():void {
				callback(null, 3);
			}, 100);
		};

		function complete(error:Error=null, values:Object=null):void {
			var error:Error=null;
			if (values.one !== 1 && values.two !== 2 && values.three !== 3) {
				error=new Error(StringUtils.formatToString("not equal one={0} two={1} three={2}", values.one, values.two, values.three));
			}
			done(error);
		}

		Async.parallel(tasks, complete);
	}

	[Test]
	public function parallelLimit(done:Function):void {
		var tasks:Object={};

		tasks.one=function(callback:Function):void {
			setTimeout(function():void {
				callback(null, 1);
			}, 100);
		};
		tasks.two=function(callback:Function):void {
			setTimeout(function():void {
				callback(null, 2);
			}, 100);
		};
		tasks.three=function(callback:Function):void {
			setTimeout(function():void {
				callback(null, 3);
			}, 100);
		};

		tasks.four=function(callback:Function):void {
			setTimeout(function():void {
				callback(null, 4);
			}, 100);
		};
		tasks.five=function(callback:Function):void {
			setTimeout(function():void {
				callback(null, 5);
			}, 100);
		};
		tasks.six=function(callback:Function):void {
			setTimeout(function():void {
				callback(null, 6);
			}, 100);
		};

		tasks.seven=function(callback:Function):void {
			setTimeout(function():void {
				callback(null, 7);
			}, 100);
		};

		function complete(error:Error=null, values:Object=null):void {
			var error:Error=null;
			if (values.one !== 1 && values.two !== 2 && values.three !== 3) {
				error=new Error(StringUtils.formatToString("not equal one={0} two={1} three={2} four={3} five={4} six={5} seven={6}", values.one, values.two, values.three,
														   values.four, values.five, values.six, values.seven));
			}
			done(error);
		}

		Async.parallelLimit(tasks, 3, complete);
	}

}
}
