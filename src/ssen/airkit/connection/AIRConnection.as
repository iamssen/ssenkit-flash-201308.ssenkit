package ssen.airkit.connection {
	import flash.events.Event;
	import flash.net.LocalConnection;
	import flash.utils.setTimeout;

	/** AIR Side Connection */
	final public class AIRConnection extends Connection {
		private var _reciver:LocalConnection;

		public function AIRConnection(config:IConnectionConfig=null) {
			super(config);
		}

		/** @private */
		override protected function connect():void {
			_reciver=new LocalConnection;
			_reciver.allowDomain(config.domain);
			_reciver.client=this;
			_reciver.connect(config.connectionName);

			setTimeout(delayInit, 1000);
		}

		private function delayInit():void {
			dispatchEvent(new Event(Event.INIT));
		}

		/** @private */
		override protected function disconnect():void {
			try {
				_reciver.close();
			} catch (error:Error) {
				trace("AIRConnection.disconnect", error);
			}
		}

		/** @private */
		override protected function get from():String {
			return "app#" + config.appId + ":" + config.connectionName;
		}

		/** @private */
		override protected function sendMessage(command:String, parameters:Array):void {
			var f:int=config.channels;
			while (--f >= 0) {
				localConnectionSend(config.domain + ":" + config.connectionName + "_" + f, command,
									parameters);
				trace("Send To ::", config.domain + ":" + config.connectionName + "_" + f, command,
					  parameters);
			}
		}
	}
}
