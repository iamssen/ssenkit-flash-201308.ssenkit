package ssen.mvc {
import flash.display.DisplayObjectContainer;
import flash.events.Event;

/**
 * @see https://github.com/iamssen/SSenMvcFramework
 * @see https://github.com/iamssen/SSenMvcFramework.Basic
 * @see https://github.com/iamssen/SSenMvcFramework.Flash
 * @see https://github.com/iamssen/SSenMvcFramework.Modular
 */
public class Context extends ContextBase {
	private var _dispatcher:IEventBus;
	private var _injector:IInjector;
	private var _viewOpener:IViewOuterBridge;
	private var _viewCatcher:IViewCatcher;
	private var _viewInjector:IViewInjector;
	private var _contextViewInjector:IContextViewInjector;
	private var _commandMap:ICommandMap;

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

		_dispatcher=null;
		_injector=null;
		_viewCatcher=null;
		_viewInjector=null;
		_contextViewInjector=null;
	}

	// =========================================================
	// initialize context
	// =========================================================
	private function startupContextView():void {
		if (viewInjector.hasMapping(contextView)) {
			viewInjector.injectInto(contextView);
		}

		startup();

		contextView.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
	}

	private function addedToStage(event:Event):void {
		contextView.removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
		startupContextView();
	}

	private function removedFromStage(event:Event):void {
		contextView.removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
		shutdown();
		dispose();
	}

	// =========================================================
	// implementation getters
	// =========================================================
	/** @see ssen.mvc.core.IEventBus */
	final override public function get eventBus():IEventBus {
		if (_dispatcher) {
			return _dispatcher;
		}

		_dispatcher=parentContext === null ? new EventBus : new EventBus(parentContext.eventBus);

		return _dispatcher;
	}

	/** @see ssen.mvc.core.IInjector */
	final override public function get injector():IInjector {
		if (_injector) {
			return _injector;
		}

		_injector=parentContext === null ? new SwiftSuspendersInjector : parentContext.injector.createChild();

		return _injector;
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

	/** @private */
	final override protected function get contextViewInjector():IContextViewInjector {
		return _contextViewInjector||=new ImplContextViewInjector(this);
	}

	/** @see ssen.mvc.core.ICommandMap */
	final override public function get commandMap():ICommandMap {
		return _commandMap||=new ImplCommandMap(eventBus.eventDispatcher, injector);
	}
}
}

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.system.ApplicationDomain;
import flash.utils.Dictionary;
import flash.utils.getQualifiedClassName;

import org.swiftsuspenders.Injector;

import ssen.common.IDisposable;
import ssen.common.ds.MultipleKeyDataCollection;
import ssen.mvc.DispatchTo;
import ssen.mvc.ICommand;
import ssen.mvc.ICommandChain;
import ssen.mvc.ICommandMap;
import ssen.mvc.IContext;
import ssen.mvc.IContextView;
import ssen.mvc.IContextViewInjector;
import ssen.mvc.IDependent;
import ssen.mvc.IEventBus;
import ssen.mvc.IInjector;
import ssen.mvc.IMediator;
import ssen.mvc.IViewCatcher;
import ssen.mvc.IViewInjector;
import ssen.mvc.IViewOuterBridge;

class ImplCommandMap implements ICommandMap {
	private var dic:Dictionary;
	private var injector:IInjector;
	private var dispatcher:IEventDispatcher;

	public function ImplCommandMap(dispatcher:IEventDispatcher, injector:IInjector) {
		this.dispatcher=dispatcher;
		this.injector=injector;
		dic=new Dictionary;
	}

	public function mapCommand(eventType:String, commandClasses:Vector.<Class>):void {
		if (dic[eventType] !== undefined) {
			throw new Error("mapped this event type");
		}

		dic[eventType]=commandClasses;
		dispatcher.addEventListener(eventType, eventCatched);
	}

	private function eventCatched(event:Event):void {
		var chain:ICommandChain=new ImplEventChain(event, create(event.type));
		chain.next();
	}

	public function unmapCommand(eventType:String):void {
		if (dic[eventType] === undefined) {
			throw new Error("undefined this command type");
		}

		delete dic[eventType];
		dispatcher.removeEventListener(eventType, eventCatched);
	}

	public function hasMapping(eventType:String):Boolean {
		return dic[eventType] !== undefined;
	}

	private function create(eventType:String):Vector.<ICommand> {
		if (dic[eventType] === undefined) {
			throw new Error("undefined command");
		}

		var commandClasses:Vector.<Class>=dic[eventType];
		var commands:Vector.<ICommand>=new Vector.<ICommand>(commandClasses.length, true);
		var cls:Class;

		var f:int=commandClasses.length;
		while (--f >= 0) {
			cls=commandClasses[f];
			commands[f]=new cls();
			injector.injectInto(commands[f]);
		}

		return commands;
	}

	public function dispose():void {
		dic=null;
	}
}

//==========================================================================================
// context view injector
//==========================================================================================
class ImplContextViewInjector implements IContextViewInjector {
	private var context:IContext;

	public function ImplContextViewInjector(context:IContext=null) {
		this.context=context;
	}

	public function injectInto(contextView:IContextView):void {
		if (!contextView.contextInitialized) {
			contextView.initialContext(context);
		}
	}

	public function dispose():void {
		context=null;
	}
}

//==========================================================================================
// injector
//==========================================================================================
class SwiftSuspendersInjector extends Injector implements IInjector {
	//	protected static const XML_CONFIG:XML=<types>
	//			<type name='org.robotlegs.mvcs::Actor'>
	//				<field name='eventDispatcher'/>
	//			</type>
	//			<type name='org.robotlegs.mvcs::Command'>
	//				<field name='contextView'/>
	//				<field name='mediatorMap'/>
	//				<field name='eventDispatcher'/>
	//				<field name='injector'/>
	//				<field name='commandMap'/>
	//			</type>
	//			<type name='org.robotlegs.mvcs::Mediator'>
	//				<field name='contextView'/>
	//				<field name='mediatorMap'/>
	//				<field name='eventDispatcher'/>
	//			</type>
	//		</types>;
	//
	//	public function SwiftSuspendersInjector(xmlConfig:XML=null) {
	//		if (xmlConfig) {
	//			for each (var typeNode:XML in XML_CONFIG.children()) {
	//				xmlConfig.appendChild(typeNode);
	//			}
	//		}
	//		super(xmlConfig);
	//	}

	public function createChild(applicationDomain:ApplicationDomain=null):IInjector {
		var injector:SwiftSuspendersInjector=new SwiftSuspendersInjector();
		injector.setApplicationDomain(applicationDomain);
		injector.setParentInjector(this);
		return injector;
	}

	public function get applicationDomain():ApplicationDomain {
		return getApplicationDomain();
	}

	public function set applicationDomain(value:ApplicationDomain):void {
		setApplicationDomain(value);
	}

	public function dispose():void {
		// ???
	}

	override public function injectInto(target:Object):void {
		super.injectInto(target);

		if (target is IDependent) {
			IDependent(target).onDependent();
		}
	}
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
		this.view.addEventListener(Event.ADDED, added, true);

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
		}

		return false;
	}

	public function stop():void {
		view.removeEventListener(Event.ADDED, added, true);

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
		display.addEventListener(Event.ADDED_TO_STAGE, addedToStage, false, 0, true);
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

//==========================================================================================
// event bus
//==========================================================================================
class EventBus implements IEventBus {
	private static var _globalDispatcher:IEventDispatcher=new EventDispatcher;
	private var _parent:IEventBus;
	private var _eventDispatcher:IEventDispatcher;
	private var _collection:ListenerCollection;

	public function EventBus(parent:IEventBus=null) {
		_eventDispatcher=new EventDispatcher;
		_parent=parent;
		_collection=new ListenerCollection;

		startup();
	}

	//----------------------------------------------------------------
	// dispatcher method
	//----------------------------------------------------------------
	/** @inheritDoc */
	public function addEventListener(event:String, listener:Function):void {
		_eventDispatcher.addEventListener(event, listener, false, 0, true);
		_collection.add(event, listener);
	}

	/** @inheritDoc */
	public function removeEventListener(event:String, listener:Function):void {
		_eventDispatcher.removeEventListener(event, listener);
		_collection.remove(event, listener);
	}

	/** @inheritDoc */
	public function removeEventListeners(event:String):void {
		var listeners:Vector.<Function>=_collection.clear(event);

		var f:int=listeners.length;
		while (--f >= 0) {
			_eventDispatcher.removeEventListener(event, listeners[f]);
		}
	}

	//----------------------------------------------------------------
	// 
	//----------------------------------------------------------------
	private function startup():void {
		if (_parent) {
			_parent.eventDispatcher.addEventListener(ContextEvent.FROM_PARENT_CONTEXT, catchOutsideEvent);
		}
		_globalDispatcher.addEventListener(ContextEvent.FROM_GLOBAL_CONTEXT, catchOutsideEvent);
		_eventDispatcher.addEventListener(ContextEvent.FROM_CHILD_CONTEXT, catchOutsideEvent);
	}

	private function shutdown():void {
		if (_parent) {
			_parent.eventDispatcher.removeEventListener(ContextEvent.FROM_PARENT_CONTEXT, catchOutsideEvent);
		}
		_globalDispatcher.removeEventListener(ContextEvent.FROM_GLOBAL_CONTEXT, catchOutsideEvent);
		_eventDispatcher.removeEventListener(ContextEvent.FROM_CHILD_CONTEXT, catchOutsideEvent);
	}

	private function catchOutsideEvent(event:ContextEvent):void {
		_eventDispatcher.dispatchEvent(event.evt);

		if (event.penetrate) {
			if (event.type === ContextEvent.FROM_CHILD_CONTEXT) {
				dispatchEvent(event.evt, DispatchTo.PARENT, true);
			} else if (event.type === ContextEvent.FROM_PARENT_CONTEXT) {
				dispatchEvent(event.evt, DispatchTo.CHILDREN, true);
			}
		}
	}

	//----------------------------------------------------------------
	// 
	//----------------------------------------------------------------
	/** @inheritDoc */
	public function get eventDispatcher():IEventDispatcher {
		return _eventDispatcher;
	}

	/** @inheritDoc */
	public function get parentEventBus():IEventBus {
		return _parent;
	}

	/** @inheritDoc */
	public function createChildEventBus():IEventBus {
		return new EventBus(this);
	}

	/** @inheritDoc */
	public function dispatchEvent(event:Event, to:String="self", penetrate:Boolean=false):void {
		if (to == DispatchTo.CHILDREN) {
			_eventDispatcher.dispatchEvent(new ContextEvent(ContextEvent.FROM_PARENT_CONTEXT, event, penetrate));
		} else if (to == DispatchTo.ALL) {
			_globalDispatcher.dispatchEvent(new ContextEvent(ContextEvent.FROM_GLOBAL_CONTEXT, event, penetrate));
		} else if (to == DispatchTo.PARENT) {
			if (_parent) {
				_parent.eventDispatcher.dispatchEvent(new ContextEvent(ContextEvent.FROM_CHILD_CONTEXT, event, penetrate));
			}
		} else if (to == DispatchTo.SELF) {
			_eventDispatcher.dispatchEvent(event);
		} else {
			throw new Error("unknown dispatch target :: " + to);
		}
	}

	/** @inheritDoc */
	public function dispose():void {
		shutdown();

		// remove all events
		var evts:Vector.<Evt>=_collection.all();
		var evt:Evt;
		var f:int=evts.length;
		while (--f >= 0) {
			evt=evts[f];
			_eventDispatcher.removeEventListener(evt.type, evt.listener);
		}
		_collection.dispose();


		_collection=null;
		_eventDispatcher=null;
		_parent=null;
	}
}

class ContextEvent extends Event {
	public static const FROM_PARENT_CONTEXT:String="fromParentContext";
	public static const FROM_GLOBAL_CONTEXT:String="fromGlobalContext";
	public static const FROM_CHILD_CONTEXT:String="fromChildContext";

	public var evt:Event;
	public var penetrate:Boolean;

	public function ContextEvent(type:String, evt:Event, penetrate:Boolean) {
		super(type);
		this.evt=evt;
		this.penetrate=penetrate;
	}

	override public function clone():Event {
		return new ContextEvent(type, evt, penetrate);
	}
}

class ListenerCollection extends MultipleKeyDataCollection {
	public function add(event:String, listener:Function):void {
		_create({event: event, listener: listener});
	}

	public function remove(event:String, listener:Function):void {
		var indices:Vector.<int>=_find({event: event, listener: listener});

		var f:int=indices.length;
		while (--f >= 0) {
			_delete(indices[f]);
		}
	}

	public function clear(event:String):Vector.<Function> {
		var indices:Vector.<int>=_find({event: event});
		var result:Vector.<Function>=new Vector.<Function>(indices.length, true);

		var f:int=indices.length;
		while (--f >= 0) {
			result[f]=_read(indices[f])["listener"];
			_delete(indices[f]);
		}

		return result;
	}

	public function get(event:String):Vector.<Function> {
		var indices:Vector.<int>=_find({event: event});
		var result:Vector.<Function>=new Vector.<Function>(indices.length, true);

		var f:int=indices.length;
		while (--f >= 0) {
			result[f]=_read(indices[f])["listener"];
		}

		return result;
	}

	public function all():Vector.<Evt> {
		var arr:Array=_getSource();
		var evts:Vector.<Evt>=new Vector.<Evt>(arr.length, true);
		var evt:Evt;
		var obj:Object;

		var f:int=arr.length;
		while (--f >= 0) {
			obj=arr[f];
			evt=new Evt;
			evt.type=obj["event"];
			evt.listener=obj["listener"];
			evts[f]=evt;
		}

		return evts;
	}
}

class Evt {
	public var type:String;
	public var listener:Function;
}

//==========================================================================================
// event chain
//==========================================================================================
class ImplEventChain implements ICommandChain {

	private var _commands:Vector.<ICommand>;
	private var dic:Dictionary;
	private var c:int=-1;
	private var _trigger:Event;

	public function ImplEventChain(trigger:Event, commands:Vector.<ICommand>) {
		_trigger=trigger;
		_commands=commands;
	}

	public function get cache():Dictionary {
		if (dic === null) {
			dic=new Dictionary(true);
		}

		return dic;
	}

	public function get current():int {
		return c;
	}

	public function next():void {
		if (++c < _commands.length) {
			_commands[c].execute(this);
		} else {
			var f:int=_commands.length;
			while (--f >= 0) {
				_commands[f].dispose();
			}
			_commands=null;
			dic=null;
		}
	}

	public function get numCommands():int {
		return _commands.length;
	}

	public function get trigger():Event {
		return _trigger;
	}
}
