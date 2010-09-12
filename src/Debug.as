package {

	/**
	 * @author Tobias Oberrauch <tobias@beautifycode.com>
	 */

	public class Debug {

		public static function dump(element:*):void {
			trace(_dump(element));
		}

		
		public static function Dtrace(param:*):void {
			var pattern:RegExp = /at.*[^)](\/.*())/gim;
			try {
				throw new Error();
			}
			catch (e:Error) {
				var result:String = e.getStackTrace().match(pattern)[1];
				trace(param + " (was called from: " + result.replace(pattern, "$1") + ")");
			}
		}

		
		
		private static function _dump(element:*, depth:int = 1):String {
			var alert:String = "";
			for(var key:String in element) {
				if(typeof element[key] == "object") {
					alert += _space(depth) + key + "\n";
					depth++;
					alert += _dump(element[key], depth) + "\n";
					depth--;
				} else if(element.numChildren > 0) {
					depth++;
					alert += _children(element, depth) + "\n";
					depth--;
				} else {
					alert += _space(depth) + key + ": " + element[key] + "\n";
				}
			}
			return alert;
		}

		
		private static function _children(element:*, depth:int = 1):String {
			var alert:String = "";
			for (var i:int = 0;i < element.numChildren;i++) {
				alert += _dump(element.getChildAt(i), depth) + "\n";
			}
			return alert;
		}

		
		private static function _space(depth:int = 1):String {
			var space:String = '';
			for(var i:int = 1;i < depth;i++) {
				space += '  ';
			}
			return space;
		}
	}
}