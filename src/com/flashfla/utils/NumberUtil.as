package com.flashfla.utils {
	
	public class NumberUtil {
		public static function numberFormat(number:*, maxDecimals:int = 2, forceDecimals:Boolean = false):String {
			var i:int = 0, inc:Number = Math.pow(10, maxDecimals), str:String = String(Math.round(inc * Number(number)) / inc);
			var hasSep:Boolean = str.indexOf(".") == -1, sep:int = hasSep ? str.length : str.indexOf(".");
			var ret:String = (hasSep && !forceDecimals ? "" : ".") + str.substr(sep + 1);
			
			if (forceDecimals)
				for (var j:int = 0; j <= maxDecimals - (str.length - (hasSep ? sep - 1 : sep)); j++)
					ret += "0";
					
			while (i + 3 < (str.substr(0, 1) == "-" ? sep - 1 : sep))
				ret = "," + str.substr(sep - (i += 3), 3) + ret;
				
			return str.substr(0, sep - i) + ret;
		}
	}
}