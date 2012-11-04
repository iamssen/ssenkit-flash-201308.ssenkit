package ssen.mvc {
import flash.display.Stage;
import flash.events.IEventDispatcher;


/** @see ssen.mvc.ondisplay.Context */
public class ContextBase implements IContext {
	private var _contextView:IContextView;
	private var _parentContext:IContext;

	public function ContextBase(contextView:IContextView, parentContext:IContext=null) {
		_parentContext=parentContext;
		_contextView=contextView;

		initialize();
	}

	/** @private */
	protected function initialize():void {
		injector.mapValue(IInjector, injector);
		injector.mapValue(IEventDispatcher, eventBus.eventDispatcher);
		injector.mapValue(IEventBus, eventBus);
		injector.mapValue(IContextView, contextView);
		injector.mapValue(ICommandMap, commandMap);
		injector.mapValue(IViewOuterBridge, viewOpener);
		injector.mapValue(IViewInjector, viewInjector);
		injector.mapSingleton(CallLater);

		mapDependency();

		viewCatcher.start(contextView);
	}

	protected function mapDependency():void {
	}

	protected function startup():void {
	}

	protected function shutdown():void {
	}

	protected function dispose():void {
		eventBus.dispatchEvent(new MvcEvent(MvcEvent.DECONSTRUCT_CONTEXT));

		viewCatcher.stop();

		eventBus.dispose();
		injector.dispose();
		viewCatcher.dispose();
		viewInjector.dispose();
		contextViewInjector.dispose();
		commandMap.dispose();
		viewOpener.dispose();

		_contextView=null;
		_parentContext=null;
	}

	//==========================================================================================
	// 
	//==========================================================================================
	/** @see ssen.mvc.core.IContextView */
	final protected function get contextView():IContextView {
		return _contextView;
	}

	/** @private */
	final protected function get parentContext():IContext {
		return _parentContext;
	}

	protected function get stage():Stage {
		throw new Error("not implemented");
	}

	public function get eventBus():IEventBus {
		throw new Error("not implemented");
	}

	public function get injector():IInjector {
		throw new Error("not implemented");
	}

	protected function get viewCatcher():IViewCatcher {
		throw new Error("not implemented");
	}

	protected function get viewOpener():IViewOuterBridge {
		throw new Error("not implemented");
	}

	protected function get viewInjector():IViewInjector {
		throw new Error("not implemented");
	}

	protected function get contextViewInjector():IContextViewInjector {
		throw new Error("not implemented");
	}

	public function get commandMap():ICommandMap {
		throw new Error("not implemented");
	}
}
}
