package classes.engine.track 
{
	import classes.engine.input.InputConfigManager;

	public class TrackConfigManager 
	{
		[Embed(source = "track_data.json", mimeType='application/octet-stream')]
		private static const TRACK_DATA:Class;
		
		public static var TRACK_CONFIGS:Vector.<TrackConfigGroup> = new Vector.<TrackConfigGroup>();
		
		public static function init():void
		{
			var trackData:Object = JSON.parse(String(new TRACK_DATA()).replace(/\/\*.*?\*\//sg, ""));
			
			parseObject(trackData);
		}

		public static function parseObject(trackData:Object):void
		{
			var startCount:int = TRACK_CONFIGS.length;
			var group:Object;

			// Input Data
			if(trackData["input"]["configs"] != null)
			{
				for each (group in trackData["input"]["configs"]) 
				{
					InputConfigManager.registerConfig(group);
				}
			}

			// Track Data
			if(trackData["track_data"]["configs"] != null)
			{
				for each (group in trackData["track_data"]["configs"]) 
				{
					registerConfig(group);
				}
			}
			
			Logger.log("TrackConfigManager", Logger.INFO, "Loaded " + (TRACK_CONFIGS.length - startCount) + " track configs.");
		}

		public static function registerConfig(group:Object):void
		{
			var track_config:TrackConfigGroup = new TrackConfigGroup();
			track_config.load(group);
			
			if(getConfig(track_config.type, track_config.id) == null)
				TRACK_CONFIGS.push(track_config);
		}

		public static function getConfig(type:String, id:String):TrackConfigGroup
		{
			var group:TrackConfigGroup;

			// Find Matching type and direction.
			for each(group in TRACK_CONFIGS)
				if(type == group.type && id == group.id)
					return group;

			// Backup, Find Matching type.
			for each(group in TRACK_CONFIGS)
				if(type == group.type)
					return group;

			// No Config found for Type
			return null;
		}
	}
}