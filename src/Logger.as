package 
{
	import com.flashfla.utils.TimeUtil;
	import flash.utils.getTimer;

	public class Logger 
	{
		public static var enabled:Boolean = CONFIG::debug;
		
		public static const DEBUG_LINES:Array = ["Info: ", "Debug: ", "Warning: ", "Error: ", "Fatal: "];
		public static const INFO:Number = 0; 	// Gray
		public static const DEBUG:Number = 1; 	// Black
		public static const WARNING:Number = 2; // Orange
		public static const ERROR:Number = 3; 	// Red
		public static const NOTICE:Number = 4;	// Purple
		
		public static var debugUpdateCallback:Function;
		public static var history:Array = [];
		
		public static function divider(clazz:*):void 
		{
			log(clazz, WARNING, "------------------------------------------------------------------------------------------------", true);
		}
		
		public static function log(clazz:*, level:int, text:String, simple:Boolean = false):void
		{
			CONFIG::debug {
			// Check if Logger Enabled
			if (!enabled) return;
			
			// Store History
			history.push([class_name(clazz), level, text, simple]);
			if (history.length > 250) history.unshift();
			if (debugUpdateCallback != null) debugUpdateCallback();
			
			// Display
			trace(level + ":" + (!simple ? "[" + TimeUtil.convertToHHMMSS(getTimer() / 1000) + "][" + class_name(clazz) + "] " : "") + text);
			}
		}
		
		public static function class_name(clazz:*):String
		{
			var t:String = (Object(clazz).constructor).toString();
			return t.substr(7, t.length - 8);
		}
		
	}

}