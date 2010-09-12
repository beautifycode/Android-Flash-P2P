package {
	import flash.display.Sprite;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.net.GroupSpecifier;
	import flash.net.NetConnection;
	import flash.net.NetGroup;
	import flash.sensors.Accelerometer;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.Timer;

	/**
	 * @author Marvin
	 */
	public class Controller extends Sprite {
		private var nc:NetConnection;
		private var ng:NetGroup;
		private var secretKey:String = "";
		private var server:String = "rtmfp://stratus.adobe.com/";
		private var sequence:Number;
		private var sui:SliderUI;
		private var timer:Timer;
		private var debugTF:*;

		public function Controller() {
			var trackMC:Sprite = new Sprite();
			trackMC.graphics.beginFill(0xFF0000);
			trackMC.graphics.drawRect(0, -300, 10, 300);
			trackMC.graphics.endFill();

			trackMC.x = 50;
			trackMC.y = 350;

			var sliderMC:Sprite = new Sprite();
			sliderMC.graphics.beginFill(0x000000);
			sliderMC.graphics.drawCircle(0, 0, 20);
			sliderMC.graphics.endFill();

			sliderMC.x = 55;
			sliderMC.y = 350;

			addChild(trackMC);
			addChild(sliderMC);

			debugTF = new TextField();
			debugTF.autoSize = TextFieldAutoSize.LEFT;
			debugTF.x = 200;
			debugTF.y = 100;
			debugTF.text = Accelerometer.isSupported + "";

			addChild(debugTF);

			sui = new SliderUI(stage, "y", trackMC, sliderMC, 0, 100, 0);

			timer = new Timer(50, 0);
			timer.addEventListener(TimerEvent.TIMER, onTimer);

			connect();
		}

		private function onTimer(event:TimerEvent) : void {
			var msg:Object = new Object();

			msg.count = sui.currentValue / 100;
			msg.sender = ng.convertPeerIDToGroupAddress(nc.nearID);
			msg.sequence = sequence++;

			if(sui.isDown) ng.post(msg);
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
					timer.start();
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
	}
}
