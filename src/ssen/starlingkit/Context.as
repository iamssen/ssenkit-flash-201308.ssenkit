// ssen.displaykit.Context 에서 복사해와서 flash.display, flash.events 등을 starling.display, starling.events 등으로 바꿔준다
package ssen.starlingkit {
import ssen.mvc.ContextBase;
import ssen.mvc.ICallLater;
import ssen.mvc.IContext;
import ssen.mvc.IContextView;
import ssen.mvc.IContextViewInjector;
import ssen.mvc.IInjector;
import ssen.mvc.IViewCatcher;
import ssen.mvc.IViewInjector;
import ssen.mvc.IViewOuterBridge;

import starling.display.DisplayObjectContainer;
import starling.events.Event;
import starling.events.EventDispatcher;

/**
 * @see https://github.com/iamssen/SSenMvcFramework
 * @see https://github.com/iamssen/SSenMvcFramework.Basic
 * @see https://github.com/iamssen/SSenMvcFramework.Flash
 * @see https://github.com/iamssen/SSenMvcFramework.Modular
 */
public class Context extends ContextBase {
	private var _viewOpener:IViewOuterBridge;
	private var _viewCatcher:IViewCatcher;
	private var _viewInjector:IViewInjector;
	private var _callLater:CallLater;
	
	public function Context(contextView:IContextView, parentContext:IContext=null) {
		super(contextView, parentContext);
	}
	
	// =========================================================
	// initialize
	// =========================================================
	/** @private */
	final override protected function initialize():void {
		super.initialize();
		
		var contextView:DisplayObjectContainer=this.contextView as DisplayObjectContainer;
		
		// stage 가 있으면 바로 start, 아니면 added to stage 까지 지연시킴
		if (contextView.stage) {
			startupContextView();
		} else {
			contextView.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
	}
	
	// ==========================================================================================
	// dispose resources
	// ==========================================================================================
	override protected function dispose():void {
		super.dispose();
		
		_viewOpener=null;
		_viewCatcher=null;
		_viewInjector=null;
		_callLater=null;
	}
	
	// =========================================================
	// initialize context
	// =========================================================
	private function startupContextView():void {
		if (viewInjector.hasMapping(contextView)) {
			viewInjector.injectInto(contextView);
		}
		
		startup();
		
		EventDispatcher(contextView).addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
	}
	
	private function addedToStage(event:Event):void {
		EventDispatcher(contextView).removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
		startupContextView();
	}
	
	private function removedFromStage(event:Event):void {
		EventDispatcher(contextView).removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
		shutdown();
		dispose();
	}
	
	// =========================================================
	// implementation getters
	// =========================================================
	/** @see ssen.mvc.ICallLater */
	override protected function get callLater():ICallLater {
		return _callLater||=new CallLater;
	}
	
	/** @see ssen.mvc.core.IViewOpener */
	final override protected function get viewOpener():IViewOuterBridge {
		return _viewOpener||=new ImplViewOuterBridge(viewInjector, contextViewInjector);
	}
	
	/** @private */
	final override protected function get viewCatcher():IViewCatcher {
		return _viewCatcher||=new ImplViewCatcher(viewInjector, contextViewInjector, contextView);
	}
	
	/** @see ssen.mvc.core.IViewInjector */
	final override protected function get viewInjector():IViewInjector {
		return _viewInjector||=new ImplViewInjector(injector);
	}
}
}

import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;

import ssen.common.IDisposable;
import ssen.mvc.ICallLater;
import ssen.mvc.IContext;
import ssen.mvc.IContextView;
import ssen.mvc.IContextViewInjector;
import ssen.mvc.IInjector;
import ssen.mvc.IMediator;
import ssen.mvc.IViewCatcher;
import ssen.mvc.IViewInjector;
import ssen.mvc.IViewOuterBridge;

import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.events.Event;
import starling.events.EventDispatcher;

//==========================================================================================
// call later
//==========================================================================================
class CallLater implements ICallLater {
	
	[Inject]
	public function setContextView(value:IContextView):void {
		contextView=value as DisplayObjectContainer;
	}
	
	private var contextView:DisplayObjectContainer;
	private var pool:Vector.<Item>;
	private var on:Boolean;
	
	public function CallLater() {
		pool=new Vector.<Item>;
	}
	
	
	public function add(func:Function, params:Array=null):void {
		var item:Item=new Item;
		item.func=func;
		item.params=params;
		
		pool.push(item);
		
		if (!on) {
			contextView.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			on=true;
		}
	}
	
	public function dispose():void {
		contextView.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		contextView=null;
		pool=null;
	}
	
	private function enterFrameHandler(event:Event):void {
		contextView.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
		executeAll();
	}
	
	private function executeAll():void {
		on=false;
		
		if (pool.length <= 0) {
			return;
		}
		
		var item:Item;
		
		var f:int=-1;
		var fmax:int=pool.length;
		
		while (++f < fmax) {
			item=pool[f];
			item.func.apply(null, item.params);
		}
		
		pool.length=0;
	}


}

class Item {
	public var func:Function;
	public var params:Array;
}

//==========================================================================================
// view catcher
//==========================================================================================
class ImplViewCatcher implements IViewCatcher {
	private var _run:Boolean;
	private var view:DisplayObjectContainer;
	private var viewInjector:IViewInjector;
	private var contextViewInjector:IContextViewInjector;
	private var contextView:IContextView;
	
	public function ImplViewCatcher(viewInjector:IViewInjector, contextViewInjector:IContextViewInjector, contextView:IContextView) {
		this.viewInjector=viewInjector;
		this.contextViewInjector=contextViewInjector;
		this.contextView=contextView;
	}
	
	public function dispose():void {
		if (_run) {
			stop();
		}
		
		viewInjector=null;
		contextViewInjector=null;
	}
	
	public function start(view:IContextView):void {
		this.view=view as DisplayObjectContainer;
		this.view.addEventListener(Event.ADDED, added);
		
		_run=true;
	}
	
	private function added(event:Event):void {
		var view:DisplayObject=event.target as DisplayObject;
		var isChild:Boolean=isMyChild(view);
		
		if (view is IContextView && isChild) {
			var contextView:IContextView=view as IContextView;
			
			if (!contextView.contextInitialized) {
				contextViewInjector.injectInto(contextView);
			}
		} else if (viewInjector.hasMapping(view) && isChild) {
			viewInjector.injectInto(view);
		}
	}
	
	private function isMyChild(view:DisplayObject):Boolean {
		var parent:DisplayObjectContainer=view.parent;
		
		while (true) {
			if (parent is IContextView) {
				if (parent == this.contextView) {
					return true;
				} else {
					return false;
				}
			}
			
			parent=parent.parent;
			
			if (parent === null) {
				break;
			}
		}
		
		return false;
	}
	
	public function stop():void {
		view.removeEventListener(Event.ADDED, added);
		
		_run=false;
		view=null;
	}
	
	public function isRun():Boolean {
		return _run;
	}
}

//==========================================================================================
// view injector
//==========================================================================================
class ImplViewInjector implements IViewInjector {
	private var mediatorMap:Dictionary;
	private var injector:IInjector;
	
	public function ImplViewInjector(injector:IInjector) {
		this.injector=injector;
		mediatorMap=new Dictionary;
	}
	
	public function dispose():void {
		mediatorMap=null;
		injector=null;
	}
	
	public function unmapView(viewClass:Class):void {
		if (hasMapping(viewClass)) {
			delete mediatorMap[viewClass];
		}
	}
	
	public function hasMapping(view:*):Boolean {
		if (view is Class) {
			return mediatorMap[view] !== undefined;
		}
		
		return mediatorMap[view["constructor"]] !== undefined;
	}
	
	public function injectInto(view:Object):void {
		if (mediatorMap[view["constructor"]] is Class) {
			new MediatorController(injector, view as DisplayObject, mediatorMap[view["constructor"]]);
		} else {
			injector.injectInto(view);
		}
	}
	
	public function mapView(viewClass:Class, mediatorClass:Class=null):void {
		if (mediatorMap[viewClass] !== undefined) {
			throw new Error(getQualifiedClassName((viewClass) + " is mapped!!!"));
		}
		mediatorMap[viewClass]=mediatorClass;
	}
}

class MediatorController implements IDisposable {
	private var view:DisplayObject;
	private var mediator:IMediator;
	
	public function MediatorController(injector:IInjector, view:DisplayObject, mediatorClass:Class=null) {
		this.view=view;
		
		if (mediatorClass) {
			mediator=injector.instantiate(mediatorClass);
			mediator.setView(view);
			
			if (view.stage) {
				mediator.onRegister();
				view.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
			} else {
				view.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			}
		}
	}
	
	private function addedToStage(event:Event):void {
		view.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
		mediator.onRegister();
		view.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
	}
	
	private function removedFromStage(event:Event):void {
		dispose();
	}
	
	public function dispose():void {
		view.removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
		mediator.onRemove();
		mediator=null;
		view=null;
	}
}

//==========================================================================================
// view outer bridge
//==========================================================================================
class ImplViewOuterBridge implements IViewOuterBridge {
	private var viewInjector:IViewInjector;
	private var contextViewInjector:IContextViewInjector;
	
	public function ImplViewOuterBridge(viewInjector:IViewInjector, contextViewInjector:IContextViewInjector) {
		this.viewInjector=viewInjector;
		this.contextViewInjector=contextViewInjector;
	}
	
	public function dispose():void {
		viewInjector=null;
		contextViewInjector=null;
	}
	
	public function ready(view:Object):void {
		var display:DisplayObject=view as DisplayObject;
		display.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
	}
	
	private function addedToStage(event:Event):void {
		var display:DisplayObject=event.target as DisplayObject;
		display.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
		
		if (display is IContextView) {
			var contextView:IContextView=display as IContextView;
			
			if (!contextView.contextInitialized) {
				contextViewInjector.injectInto(contextView);
			}
		} else if (viewInjector.hasMapping(display)) {
			viewInjector.injectInto(display);
		}
	}
}




