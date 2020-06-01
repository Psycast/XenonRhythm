package classes.engine.input
{
	public class InputConfigManager 
	{
		public static var INPUT_CONFIGS:Vector.<InputConfigGroup> = new Vector.<InputConfigGroup>();
		
		public static function init():void
		{
			var menuConfig:Object = {
				"id": "global",
				"name": "Global",
				"controls": {
					"left": 37,		 // Keyboard.LEFT
					"down": 40,		 // Keyboard.DOWN
					"up": 38,		 // Keyboard.UP
					"right": 39,	 // Keyboard.RIGHT
					"restart": 191,  // Keyboard.SLASH
					"quit": 17,		 // Keyboard.CONTROL
					"options": 145,	 // SCROLL_LOCK
					"select": 32,	 // Keyboard.SPACE
					"confirm": 13	 // Keyboard.ENTER
				}
			};

			registerConfig(menuConfig);
		}

		public static function parseObject(inputData:Object):void
		{
			var startCount:int = INPUT_CONFIGS.length;
			var group:Object;

			// Input Data
			if(inputData["input"]["configs"] != null)
			{
				for each (group in inputData["input"]["configs"]) 
				{
					registerConfig(group);
				}
			}
			Logger.log("InputConfigManager", Logger.INFO, "Loaded " + (INPUT_CONFIGS.length - startCount) + " input configs.");
		}

		public static function registerConfig(config:Object):void
		{
			var newConfig:InputConfigGroup = new InputConfigGroup();
			newConfig.load(config);

			if(getConfig(newConfig.id) == null)
				INPUT_CONFIGS.push(newConfig);
		}

		public static function getConfig(id:String):InputConfigGroup
		{
			for each(var group:InputConfigGroup in INPUT_CONFIGS)
			{
				if(group.id == id)
					return group;
			}
			return null;
		}

	}
}