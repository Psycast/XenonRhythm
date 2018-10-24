package classes.engine 
{
	public class EngineVariables 
	{
		public var active_filter:EngineLevelFilter;
		public var song_queue:Vector.<EngineLevel> = new <EngineLevel>[];
		
		// Gameplay
		public var is_autoplay:Boolean = false;
	}
}