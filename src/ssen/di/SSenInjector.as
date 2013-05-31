package ssen.di {
import flash.utils.describeType;
import flash.utils.getQualifiedClassName;

use namespace injection_internal;

public class SSenInjector {
	injection_internal static var dependents:Object={};

	private var factories:Object;
	private var parent:SSenInjector;
	private var factoriesset:Array;

	public function SSenInjector(parent:SSenInjector=null) {
		this.parent=parent;
		this.factories={};
		this.factoriesset=[this.factories];

		if (parent) {
			var current:SSenInjector=parent;
			while (current) {
				factoriesset.push(current.factories);
				current=current.parent;
			}
		}
	}

	//==========================================================================================
	// children
	//==========================================================================================
	public function createChild():SSenInjector {
		return new SSenInjector(this);
	}

	//==========================================================================================
	// factories logic
	//==========================================================================================
	public function getInstance(asktype:Class, named:String=""):* {
		var factory:InstanceFactory=getValueFactory(asktype, named);
		return factory ? factory.getInstance() : undefined;
	}

	public function hasMapping(asktype:Class, named:String=""):Boolean {
		var factory:InstanceFactory=getValueFactory(asktype, named);
		return factory !== null;
	}

	public function injectInto(obj:Object):Object {
		var id:String=getQualifiedClassName(obj);

		if (!dependents[id]) {
			throw new Error("undefined dependent by " + id);
		}

		var d:Object;
		var list:Array=dependents[id];
		var facs:Array;
		var fac:InstanceFactory;
		var args:Array;
		var method:Function;

		var f:int=-1;
		var fmax:int=list.length;
		var s:int;
		var smax:int;

		while (++f < fmax) {
			d=list[f];

			if (d.type === "property") {
				fac=factories[d.factory];
				obj[d.name]=fac.getInstance();
			} else if (d.type === "method") {
				method=obj[d.name];

				facs=d.factories;
				args=[];

				s=-1;
				smax=facs.length;
				while (++s < smax) {
					fac=facs[s];
					args.push(fac.getInstance());
				}

				method.apply(null, args);
			} else {
				// TODO
			}
		}

		return obj;
	}

	//==========================================================================================
	// map, unmap
	//==========================================================================================
	public function mapClass(asktype:Class, usetype:Class=null, named:String=""):void {
		if (!usetype) {
			usetype=asktype;
		}
		factories[getNameByClass(asktype, named)]=new InstantiateFactory(this, usetype);
		makeDependentSpec(usetype);
	}

	public function mapSingleton(asktype:Class, usetype:Class=null, named:String=""):void {
		if (!usetype) {
			usetype=asktype;
		}
		factories[getNameByClass(asktype, named)]=new SingletonFactory(this, usetype);
		makeDependentSpec(usetype);
	}

	public function mapValue(asktype:Class, usevalue:*, named:String=""):void {
		factories[getNameByClass(asktype, named)]=new ValueFactory(this, usevalue);
		makeDependentSpec(usevalue);
	}

	public function unmap(asktype:Class, named:String=""):void {
		var factory:InstanceFactory=factories[getNameByClass(asktype, named)];

		if (factory) {
			factory.dispose();
			delete factories[getNameByClass(asktype, named)];
		}
	}

	//==========================================================================================
	// dispose
	//==========================================================================================
	public function dispose():void {
		for each (var factory:InstanceFactory in factories) {
			if (factory) {
				factory.dispose();
			}
		}

		factories=null;
		parent=null;
		factoriesset=null;
	}

	//==========================================================================================
	// utils
	//==========================================================================================
	injection_internal function makeDependentSpec(target:*):XML {
		var id:String=getQualifiedClassName(target);
		var spec:XML=describeType(target);

		if (dependents[id]) {
			return spec;
		}

		var injectList:XMLList=spec..metadata.(@name == "Inject");

		var member:XML;
		var inject:XML;
		var keys:XMLList;
		var params:XMLList;
		var param:XML;

		var list:Array=[];
		var factories:Array;

		var f:int=-1;
		var fmax:int=injectList.length();
		var s:int;
		var smax:int;

		while (++f < fmax) {
			inject=injectList[f];
			member=inject.parent();
			keys=inject.arg.(@key == "name");

			if ((member.name() == "variable") || (member.name() == "accessor" && member.@access != "readonly")) {
				list.push({name: member.@name.toString(), type: "property", factory: getName(member.@type.toString(), (keys.length() > 0) ? keys[0].@value.toString() : "")});
			} else if (member.name() == "method") {
				params=member.parameter;
				s=-1;
				smax=params.length();

				if (params.length() === 0) {
					continue;
				}

				factories=[];

				while (++s < smax) {
					factories.push(getName(params[s].@type.toString(), (keys.length() > s) ? keys[s].@value.toString() : ""));
				}
				list.push({name: member.@name.toString(), type: "method", factories: factories});
			}
		}

		dependents[id]=list;

		return spec;
	}

	private function getValueFactory(type:Class, named:String):InstanceFactory {
		var id:String=getNameByClass(type, named);

		var factories:Object;
		var factory:InstanceFactory;

		var f:int=-1;
		var fmax:int=factoriesset.length;

		while (++f < fmax) {
			factories=factoriesset[f];
			if (factories[id]) {
				return factories[id];
			}
		}

		return undefined;
	}

	private function getNameByClass(type:Object, named:String):String {
		return getQualifiedClassName(type) + "#" + named;
	}

	private function getName(type:String, named:String):String {
		return type + "#" + named;
	}
}
}
import ssen.common.IDisposable;
import ssen.di.InstanceFactory;
import ssen.di.SSenInjector;

class InstantiateFactory extends InstanceFactory {
	private var type:Class;

	public function InstantiateFactory(injector:SSenInjector, type:Class) {
		super(injector);
		this.type=type;
	}

	override public function getInstance():* {
		return instanceInitialize(new type);
	}

	override public function dispose():void {
		super.dispose();
		type=null;
	}
}

class SingletonFactory extends InstanceFactory {
	private var type:Class;
	private var instance:Object;

	public function SingletonFactory(injector:SSenInjector, type:Class) {
		super(injector);
		this.type=type;
	}

	override public function getInstance():* {
		if (!instance) {
			instance=instanceInitialize(new type);
		}

		return instance;
	}

	override public function dispose():void {
		super.dispose();

		if (instance is IDisposable) {
			IDisposable(instance).dispose();
		}

		type=null;
		instance=null;
	}
}

class ValueFactory extends InstanceFactory {
	private var value:*;
	private var initialized:Boolean;

	public function ValueFactory(injector:SSenInjector, value:*) {
		super(injector);
		this.value=value;
	}

	override public function getInstance():* {
		if (!initialized) {
			instanceInitialize(value);
		}

		return value;
	}

	override public function dispose():void {
		super.dispose();

		if (value is IDisposable) {
			IDisposable(value).dispose();
		}

		value=null;
	}

}
