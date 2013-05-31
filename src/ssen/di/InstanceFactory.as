package ssen.di {
import ssen.common.IDisposable;

public class InstanceFactory implements IDisposable {
	private var injector:SSenInjector;

	public function InstanceFactory(injector:SSenInjector) {
		this.injector=injector;
	}

	public function getInstance():* {
		throw new Error("not implemented");
	}

	protected function instanceInitialize(instance:Object):Object {
		return injector.injectInto(instance);
	}

	public function dispose():void {
		injector=null;
	}
}
}
