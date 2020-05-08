package classes.engine 
{
	import classes.Song;
	import flash.events.EventDispatcher;
	
	public class EngineLevelLoader extends EventDispatcher 
	{
		private var core:EngineCore;
		private var loaded_levels:Object = { };
		
		public function EngineLevelLoader(core:EngineCore) 
		{
			this.core = core;
		}
		
		public function getSong(songData:EngineLevel):Song
		{
			var key:String = songData.source + "_" + songData.id;
			if (loaded_levels[key] != null && !loaded_levels[key].load_failed)
			{
				return loaded_levels[key];
			}
			
			return (loaded_levels[key] = new Song(core, songData));
		}
	}
}