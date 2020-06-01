package classes.engine
{
	import flash.ui.Keyboard;
	import classes.engine.input.InputConfigGroup;
	import classes.engine.input.InputConfigManager;
	
	/**
	 * Engine Settings
	 * Contains per user settings for the game.
	 */
	public class EngineSettings
	{
		///- Variables
		// Inputs
		public var menu_keys:InputConfigGroup;
		public var key_mappings:Vector.<InputConfigGroup>;

		//public function get keys():Array { return [key_left, key_down, key_up, key_right, key_restart, key_quit, key_options]; }
		
		// Speed
		public var scroll_direction:String = "down";
		public var scroll_speed:Number = 1.5;
		public var receptor_spacing:int = 80;
		public var screencut_position:Number = 0.5;
		public var playback_speed:Number = 1;
		
		// Judge
		public var offset_global:Number = 0;
		public var offset_judge:Number = 0;
		public var judge_colors:Array = [0x78ef29, 0x12e006, 0x01aa0f, 0xf99800, 0xfe0000, 0x804100];
		public var judge_window:Array = null;
		
		// Flags
		public var display_song_flags:Boolean = true;
		public var display_alt_engines:Boolean = true;
		
		// Other
		public var filters:Array = [];

		public function EngineSettings():void
		{
			menu_keys = InputConfigManager.getConfig("global");
		}
		
		/**
		 * Setups Engine Settings for a passed object.
		 * @param	obj	Object containing new settings.
		 */
		public function setup(obj:Object, source:String = "ffr"):void
		{

			// Keys
			if (obj["keys"])
			{
				menu_keys.setAction("left", 	obj["keys"][0]);
				menu_keys.setAction("down", 	obj["keys"][1]);
				menu_keys.setAction("up", 		obj["keys"][2]);
				menu_keys.setAction("right", 	obj["keys"][3]);
				menu_keys.setAction("restart", 	obj["keys"][4]);
				menu_keys.setAction("quit", 	obj["keys"][5]);
				menu_keys.setAction("options", 	obj["keys"][6]);

				// FFR - 4key Settings
				var game_keys:InputConfigGroup = InputConfigManager.getConfig("4key");
				game_keys.setAction("left", 	obj["keys"][0]);
				game_keys.setAction("down", 	obj["keys"][1]);
				game_keys.setAction("up", 		obj["keys"][2]);
				game_keys.setAction("right", 	obj["keys"][3]);
			}
			
			// Speed
			if (obj["direction"])			scroll_direction = obj["direction"];
			if (obj["speed"])				scroll_speed = obj["speed"];
			if (obj["gap"])					receptor_spacing = obj["gap"];
			if (obj["screencutPosition"])	screencut_position = obj["screencutPosition"];
			
			// Judge
			if (obj["judgeOffset"])			offset_judge = obj["judgeOffset"];
			if (obj["viewOffset"])			offset_global = obj["viewOffset"];
			if (obj["judgeColours"])		judge_colors = obj["judgeColours"];
			
			// Other
			if(obj["filters"])				filters = doImportFilters(obj["filters"]);
		}
		
		public function export():Object
		{
			var obj:Object = new Object();
			// Keys
			obj["keys"] = []; //TODO: Write InputConfigGroup Exporter for FFR format.
			
			// Speed
			obj["direction"] 		= scroll_direction;
			obj["speed"]			= scroll_speed;
			obj["gap"] 				= receptor_spacing;
			obj["screencutPosition"] = screencut_position;
			
			// Judge
			obj["judgeOffset"] 		= offset_judge;
			obj["viewOffset"] 		= offset_global;
			obj["judgeColours"] 	= judge_colors;
			
			// Other
			obj["filters"]			= doExportFilters(filters);
			
			return obj;
		}
		
		/**
		 * Imports user filters from a save object.
		 * @param	filters Array of Filter objects.
		 * @return Array of EngineLevelFilters.
		 */
		private function doImportFilters(filters_in:Array):Array 
		{
			var newFilters:Array = [];
			var filter:EngineLevelFilter;
			for each (var item:Object in filters_in) 
			{
				filter = new EngineLevelFilter();
				filter.setup(item);
				newFilters.push(filter);
			}
			return newFilters;
		}
		
		/**
		 * Exports the user filters into an array of filter objects.
		 * @param	filters_out Array of Filters to export.
		 * @return	Array of Filter Object.
		 */
		private function doExportFilters(filters_out:Array):Array 
		{
			var filtersOut:Array = [];
			for each (var item:EngineLevelFilter in filters_out) 
			{
				if((item.type == EngineLevelFilter.FILTER_AND || item.type == EngineLevelFilter.FILTER_OR) && item.filters.length > 0)
					filtersOut.push(item.export());
			}
			return filtersOut;
		}
	}
}