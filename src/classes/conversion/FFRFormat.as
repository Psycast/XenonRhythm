package classes.conversion
{
	import classes.engine.EngineSettings;
	import classes.engine.input.InputConfigGroup;
	import classes.engine.input.InputConfigManager;
	import classes.engine.EngineLevelFilter;

	public class FFRFormat
	{
		public static function parseSettings(settings:EngineSettings, obj:Object):void
		{
			// Keys
			if (obj["keys"])
			{
				settings.menu_keys.setAction("left", 	obj["keys"][0]);
				settings.menu_keys.setAction("down", 	obj["keys"][1]);
				settings.menu_keys.setAction("up", 		obj["keys"][2]);
				settings.menu_keys.setAction("right", 	obj["keys"][3]);
				settings.menu_keys.setAction("restart", obj["keys"][4]);
				settings.menu_keys.setAction("quit", 	obj["keys"][5]);
				settings.menu_keys.setAction("options", obj["keys"][6]);

				// FFR - 4key Settings
				var game_keys:InputConfigGroup = InputConfigManager.getConfig("4key");
				game_keys.setAction("left", 	obj["keys"][0]);
				game_keys.setAction("down", 	obj["keys"][1]);
				game_keys.setAction("up", 		obj["keys"][2]);
				game_keys.setAction("right", 	obj["keys"][3]);
			}
			
			// Speed
			if (obj["direction"])			settings.scroll_direction = obj["direction"];
			if (obj["speed"])				settings.scroll_speed = obj["speed"];
			if (obj["gap"])					settings.receptor_spacing = obj["gap"];
			if (obj["screencutPosition"])	settings.screencut_position = obj["screencutPosition"];
			
			// Judge
			if (obj["judgeOffset"])			settings.offset_judge = obj["judgeOffset"];
			if (obj["viewOffset"])			settings.offset_global = obj["viewOffset"];
			if (obj["judgeColours"])		settings.judge_colors = obj["judgeColours"];
			
			// Other
			if(obj["filters"])				settings.filters = doImportFilters(obj["filters"]);
		}

		public static function exportSettings(settings:EngineSettings):Object
		{
			var obj:Object = new Object();
			// Keys
			obj["keys"] = []; //TODO: Write InputConfigGroup Exporter for FFR format.
			
			// Speed
			obj["direction"] 			= settings.scroll_direction;
			obj["speed"]				= settings.scroll_speed;
			obj["gap"] 					= settings.receptor_spacing;
			obj["screencutPosition"] 	= settings.screencut_position;
			
			// Judge
			obj["judgeOffset"] 			= settings.offset_judge;
			obj["viewOffset"] 			= settings.offset_global;
			obj["judgeColours"] 		= settings.judge_colors;
			
			// Other
			obj["filters"]				= doExportFilters(settings.filters);

			return obj;
		}

		/**
		 * Imports user filters from a save object.
		 * @param	filters Array of Filter objects.
		 * @return Array of EngineLevelFilters.
		 */
		public static function doImportFilters(filters_in:Array):Vector.<EngineLevelFilter>
		{
			var newFilters:Vector.<EngineLevelFilter> = new <EngineLevelFilter>[];
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
		public static function doExportFilters(filters_out:Vector.<EngineLevelFilter>):Array 
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