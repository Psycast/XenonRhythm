package com.adobe.serialization.json
{
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;
	
	public dynamic class JSONManager
	{
		public static var encode:Function;
		public static var decode:Function;
		private static var _initialized:Boolean;
		
		public static function init():void
		{
			if (_initialized)
				return;
			
			if (ApplicationDomain.currentDomain.hasDefinition("JSON"))
			{
				var JSONClass:Class = getDefinitionByName("JSON") as Class;
				encode = JSONClass["stringify"];
				decode = JSONClass["parse"];
			}
			else
			{
				encode = function(o:Object):*
				{
					var encoder:JSONEncoder = new JSONEncoder(o);
					return encoder.getString();
				};
				decode = function(s:String):*
				{
					var decoder:JSONDecoder = new JSONDecoder(s);
					return decoder.getValue();
				};
			}
			
			_initialized = true;
		}
	}
}