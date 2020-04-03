package classes.engine.track 
{
	public class TrackConfigManager 
	{
		[Embed(source = "track_data.json", mimeType='application/octet-stream')]
		private static const TRACK_DATA:Class;
		
		public static var TRACK_CONFIGS:Vector.<TrackConfigGroup>;
		
		public static function init():void
		{
			TRACK_CONFIGS = new Vector.<TrackConfigGroup>();
			
			var trackData:Object = JSON.parse(String(new TRACK_DATA()).replace(/\/\*.*?\*\//sg, ""));
			
			var group:Object;
			var config:TrackConfigGroup;
			
			for each (group in trackData) 
			{
				config = new TrackConfigGroup();
				config.load(group);
				TRACK_CONFIGS.push(config);
			}
			
			Logger.log("TrackConfigManager", Logger.INFO, "Loaded " + TRACK_CONFIGS.length + " track configs.");
		}
	}
}