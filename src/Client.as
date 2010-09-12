package {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.net.GroupSpecifier;
	import flash.net.NetConnection;
	import flash.net.NetGroup;

	/**
	 * @author Marvin
	 */
	public class Client extends Sprite {
		private var spr:Sprite;
		private var nc:NetConnection;
		private var ng:NetGroup;
		private var secretKey:String = "";
		private var server:String = "rtmfp://stratus.adobe.com/";

		public function Client() {
			spr = new Sprite();
			spr.graphics.beginFill(0x000000);
			spr.graphics.drawCircle(0, 0, 300);
			spr.graphics.endFill();

			spr.x = 100;
			spr.y = 100;

			addChild(spr);
			connect();
		}

		private function connect() : void {
			nc = new NetConnection();
			nc.addEventListener(NetStatusEvent.NET_STATUS, ncStatusHandler);
			nc.connect(server + secretKey);
		}

		private function ncStatusHandler(event:NetStatusEvent) : void {
			trace(event.info.code);

			switch(event.info.code) {
				case "NetConnection.Connect.Success":
					setupGroup();
					break;
				case "NetGroup.Connect.Success":
					// connected = true;
					break;
				case "NetGroup.Posting.Notify":
					colorByInput(event.info.message.count);
					break;
			}
		}

		private function setupGroup() : void {
			var groupspec:GroupSpecifier = new GroupSpecifier("remote-control");
			groupspec.serverChannelEnabled = true;
			groupspec.postingEnabled = true;

			ng = new NetGroup(nc, groupspec.groupspecWithAuthorizations());
			ng.addEventListener(NetStatusEvent.NET_STATUS, ncStatusHandler);
		}

		private function colorByInput(message:Number) : void {
			trace('message: ' + (message));
			spr.alpha = message;
		}
	}
}
