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
		if (!_callLater) {
			_callLater=new CallLater;
			_callLater.setContextView(contextView);
		}
		return _callLater;
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
import flash.utils.describeType;
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

import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.display.Stage;
import starling.events.Event;
import starling.events.EventDispatcher;

class CallLater implements ICallLater {
	
	private var contextView:DisplayObjectContainer;
	private var pool:Vector.<Item>;
	private var on:Boolean;
	
	public function CallLater() {
		pool=new Vector.<Item>;
	}
	
	public function setContextView(value:IContextView):void {
		contextView=value as DisplayObjectContainer;
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
	
	public function has(func:Function):Boolean {
		var f:int=pool.length;
		var item:Item;
		while (--f >= 0) {
			item=pool[f];
			if (item.func === func) {
				return true;
			}
		}
		
		return false;
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
	private var stage:Stage;
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
		this.stage=view.getStage() as Stage;
		this.view.addEventListener(Event.ADDED, added);
		this.stage.addEventListener(Event.ADDED, globalAdded);
		
		_run=true;
	}
	
	private function globalAdded(event:Event):void {
		var view:DisplayObject=event.target as DisplayObject;
		
		if (viewInjector.hasMapping(view, true)) {
			viewInjector.injectInto(view);
		}
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
		stage.removeEventListener(Event.ADDED, globalAdded);
		
		_run=false;
		view=null;
		stage=null;
	}
	
	public function isRun():Boolean {
		return _run;
	}
}

//==========================================================================================
// view injector
//==========================================================================================
class ImplViewInjector implements IViewInjector {
	private var globalMediatorMap:Dictionary;
	private var mediatorMap:Dictionary;
	private var injector:IInjector;
	
	public function ImplViewInjector(injector:IInjector) {
		this.injector=injector;
		mediatorMap=new Dictionary;
		globalMediatorMap=new Dictionary;
	}
	
	public function dispose():void {
		globalMediatorMap=null;
		mediatorMap=null;
		injector=null;
	}
	
	public function unmapView(viewClass:Class, global:Boolean=false):void {
		if (global) {
			if (globalMediatorMap[viewClass] !== undefined) {
				delete globalMediatorMap[viewClass];
			}
		} else {
			if (mediatorMap[viewClass] !== undefined) {
				delete mediatorMap[viewClass];
			}
		}
	}
	
	public function hasMapping(view:*, global:Boolean=false):Boolean {
		if (global) {
			if (view is Class) {
				return globalMediatorMap[view] !== undefined;
			}
			
			return globalMediatorMap[view["constructor"]] !== undefined;
		} else {
			if (view is Class) {
				return mediatorMap[view] !== undefined;
			}
			
			return mediatorMap[view["constructor"]] !== undefined;
		}
	}
	
	public function injectInto(view:Object):void {
		if (mediatorMap[view["constructor"]] is Class) {
			new MediatorController(injector, view as DisplayObject, mediatorMap[view["constructor"]]);
		} else {
			injector.injectInto(view);
		}
	}
	
	public function mapView(viewClass:Class, mediatorClass:Class=null, global:Boolean=false):void {
		if (global) {
			if (globalMediatorMap[viewClass] !== undefined) {
				throw new Error(getQualifiedClassName(viewClass) + " is mapped!!!");
			}
			globalMediatorMap[viewClass]=mediatorClass;
		} else {
			if (mediatorMap[viewClass] !== undefined) {
				throw new Error(getQualifiedClassName(viewClass) + " is mapped!!!");
			}
			mediatorMap[viewClass]=mediatorClass;
		}
	}
}

class MediatorController implements IDisposable {
	private var view:DisplayObject;
	private var mediator:IMediator;
	private var wireDisposer:IDisposable;
	
	public function MediatorController(injector:IInjector, view:DisplayObject, mediatorClass:Class=null) {
		this.view=view;
		
		if (mediatorClass) {
			mediator=injector.instantiate(mediatorClass);
			mediator.setView(view);
			
			wireDisposer=methodWiring(view, mediator);
			
			if (view.stage) {
				mediator.onRegister();
				view.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
			} else {
				view.addEventListener(Event.ADDED_TO_STAGE, addedToStage);
			}
		}
	}
	
	private function methodWiring(view:Object, mediator:Object):IDisposable {
		var x:XML=describeType(view);
		var list:XMLList=x..metadata.(@name == "Wire");
		var variable:XML;
		var name:String;
		var disposer:ViewWireDisposer;
		
		var f:int=-1;
		var fmax:int=list.length();
		
		if (fmax > 0) {
			disposer=new ViewWireDisposer;
			disposer.view=view;
			
			while (++f < fmax) {
				variable=list[f].parent();
				
				if (variable.name() == "variable" && variable.@type == "Function") {
					name=variable.@name;
					
					if (mediator[name] !== undefined && typeof mediator[name] === "function") {
						view[name]=mediator[name];
						disposer.list.push(name);
					}
				}
			}
		}
		
		return disposer;
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
		if (wireDisposer) {
			wireDisposer.dispose();
		}
		view.removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
		mediator.onRemove();
		wireDisposer=null;
		mediator=null;
		view=null;
	}
}

class ViewWireDisposer implements IDisposable {
	public var view:Object;
	public var list:Vector.<String>=new Vector.<String>;
	
	public function dispose():void {
		var f:int=list.length;
		while (--f >= 0) {
			view[list[f]]=null;
		}
		view=null;
		list=null;
	}
}