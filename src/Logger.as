package 
{
	import flash.display.Stage;

	public class Logger 
	{
		public static var enabled:Boolean = CONFIG::debug;
		
		public static const INFO:Number = 0; 	// Gray
		public static const DEBUG:Number = 1; 	// Black
		public static const WARNING:Number = 2; // Orange
		public static const ERROR:Number = 3; 	// Red
		public static const NOTICE:Number = 4;	// Purple
		
		public static var history:Array = [];
		
		public static function divider(clazz:*):void 
		{
			log(clazz, WARNING, "------------------------------------------------------------------------------------------------", true);
		}
		
		public static function log(clazz:*, level:int, text:String, simple:Boolean = false):void
		{
			// Check if Logger Enabled
			if (!enabled) return;
			
			// Store History
			history.push([class_name(clazz), level, text, simple]);
			if (history.length > 250) history.unshift();
			
			// Display
			trace(level + ":" + (!simple ? "[" + class_name(clazz) + "] " : "") + text);
		}
		
		public static function class_name(clazz:*):String
		{
			var t:String = (Object(clazz).constructor).toString();
			return t.substr(7, t.length - 8);
		}
		
	}

}