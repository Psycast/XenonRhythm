package classes.engine
{
	import classes.user.User;
	import com.flashfla.utils.StringUtil;
	
	public class EngineLevelFilter
	{
		/// Filter Types
		public static const FILTER_AND:String = "and";
		public static const FILTER_OR:String = "or";
		public static const FILTER_STYLE:String = "style";
		public static const FILTER_NAME:String = "name";
		public static const FILTER_ARTIST:String = "artist";
		public static const FILTER_STEPARTIST:String = "stepartist";
		public static const FILTER_BPM:String = "bpm";
		public static const FILTER_DIFFICULTY:String = "difficulty";
		public static const FILTER_ARROWCOUNT:String = "arrows";
		public static const FILTER_ID:String = "id";
		public static const FILTER_MIN_NPS:String = "min_nps";
		public static const FILTER_MAX_NPS:String = "max_nps";
		public static const FILTER_RANK:String = "rank";
		public static const FILTER_SCORE:String = "score";
		public static const FILTER_STATS:String = "stats";
		public static const FILTER_TIME:String = "time";
		
		public static const FILTERS:Array = [FILTER_AND, FILTER_OR, FILTER_STYLE, FILTER_ARTIST, FILTER_STEPARTIST, FILTER_DIFFICULTY, FILTER_ARROWCOUNT, FILTER_ID, FILTER_MIN_NPS, FILTER_MAX_NPS, FILTER_RANK, FILTER_SCORE, FILTER_STATS, FILTER_TIME];
		public static const FILTERS_STAT:Array = ["amazing", "perfect", "average", "miss", "boo", "combo"];
		public static const FILTERS_NUMBER:Array = ["=", "!=", "<=", ">=", "<", ">"];
		public static const FILTERS_STRING:Array = ["equal", "start_with", "end_with", "contains"];
		
		public var name:String;
		private var _type:String;
		public var comparison:String;
		public var inverse:Boolean = false;
		
		public var parent_filter:EngineLevelFilter;
		public var filters:Array = [];
		public var input_number:Number = 0;
		public var input_string:String = "";
		public var input_stat:String = FILTERS_STAT[0]; // Display4
		
		public function EngineLevelFilter(topLevelFilter:Boolean = false) 
		{
			if (topLevelFilter)
			{
				name = "Untitled Filter";
				type = "and";
				filters = [];
			}
		}
		
		public function get type():String 
		{
			return _type;
		}
		
		public function set type(value:String):void 
		{
			_type = value;
			setDefaultComparison();
		}
		
		/**
		 * Process the engine level to see if it has passed the requirements of the filters currently set.
		 *
		 * @param	songData	Engine Level to be processed.
		 * @param	userData	User Data from comparisons.
		 * @return	Song passed filter.
		 */
		public function process(songData:EngineLevel, userData:User):Boolean
		{
			switch (type)
			{
				case FILTER_AND: 
					if (!filters || filters.length == 0)
						return true;
					
					// Check ALL Sub Filters Pass
					for each (var filter_and:EngineLevelFilter in filters)
					{
						if (!filter_and.process(songData, userData))
							return false;
					}
					return true;
				
				case FILTER_OR: 
					if (!filters || filters.length == 0)
						return true;
					
					var out:Boolean = false;
					// Check if any Sub Filters Pass
					for each (var filter_or:EngineLevelFilter in filters)
					{
						if (filter_or.process(songData, userData))
							out = true;
					}
					return out;
				
				case FILTER_ID: 
					return compareString(songData.id, input_string);
				
				case FILTER_NAME: 
					return compareString(songData.name, input_string);
				
				case FILTER_STYLE: 
					return compareString(songData.style, input_string);
				
				case FILTER_ARTIST: 
					return compareString(songData.author, input_string);
				
				case FILTER_STEPARTIST: 
					return compareString(songData.stepauthor, input_string);
				
				case FILTER_BPM: 
					return false; // TODO: compareNumber(songData.bpm, input_number);
				
				case FILTER_DIFFICULTY: 
					return compareNumber(songData.difficulty, input_number);
				
				case FILTER_ARROWCOUNT: 
					return compareNumber(songData.notes, input_number);
				
				case FILTER_MIN_NPS: 
					return compareNumber(songData.min_nps, input_number);
				
				case FILTER_MAX_NPS: 
					return compareNumber(songData.max_nps, input_number);
				
				case FILTER_RANK: 
					return compareNumber(userData.levelranks.getEngineRanks(songData.source).getRank(songData.id).rank, input_number);
				
				case FILTER_SCORE: 
					return compareNumber(userData.levelranks.getEngineRanks(songData.source).getRank(songData.id).score, input_number);
				
				case FILTER_STATS: 
					return compareNumber(userData.levelranks.getEngineRanks(songData.source).getRank(songData.id)[input_stat], input_number);
				
				case FILTER_TIME: 
					return compareNumber(songData.time_secs, input_number);
			}
			return true;
		}
		
		/**
		 * Compares 2 Number values with the selected comparision.
		 * @param	value1	Input Value
		 * @param	value2	Value to compare to.
		 * @param	comparison	Method of comparision.
		 * @return	If comparision was successful.
		 */
		private function compareNumber(value1:Number, value2:Number):Boolean
		{
			switch (comparison)
			{
				case "=": 
					return value1 == value2;
				
				case "!=": 
					return value1 != value2;
				
				case "<=": 
					return value1 <= value2;
				
				case ">=": 
					return value1 >= value2;
				
				case "<": 
					return value1 < value2;
				
				case ">": 
					return value1 > value2;
			}
			return false;
		}
		
		/**
		 * Compares 2 String values with the selected comparision.
		 * @param	value1	Input Value
		 * @param	value2	Value to compare to.
		 * @param	comparison	Method of comparision.
		 * @param	inverse	Use inverse comparisions.
		 * @return	If comparision was successful.
		 */
		private function compareString(value1:String, value2:String):Boolean
		{
			var out:Boolean = false;
			value1 = value1.toLowerCase();
			value2 = value2.toLowerCase();
			
			switch (comparison)
			{
				case "equal": 
					out = (value1 == value2);
				
				case "start_with": 
					out = StringUtil.beginsWith(value1, value2);
				
				case "end_with": 
					out = StringUtil.endsWith(value1, value2);
				
				case "contains": 
					out = (value1.indexOf(value2) >= 0);
			}
			return inverse ? !out : out;
		}
		
		public function setup(obj:Object):void
		{
			if (obj.hasOwnProperty("type"))
				type = obj["type"];
				
			if (obj.hasOwnProperty("filters"))
			{
				var in_filter:EngineLevelFilter;
				var in_filters:Array = obj["filters"];
				for (var i:int = 0; i < in_filters.length; i++)
				{
					in_filter = new EngineLevelFilter();
					in_filter.setup(in_filters[i]);
					in_filter.parent_filter = this;
					filters.push(in_filter);
				}
				if (obj.hasOwnProperty("name"))
					name = obj["name"];
					
			}
			else
			{
				if (obj.hasOwnProperty("comparison"))
					comparison = obj["comparison"];
					
				if (obj.hasOwnProperty("input_number"))
					input_number = obj["input_number"];
					
				if (obj.hasOwnProperty("input_string"))
					input_string = obj["input_string"];
					
				if (obj.hasOwnProperty("input_stat"))
					input_stat = obj["input_stat"];
			}
		}
		
		public function export():Object
		{
			var obj:Object = { "type": type };
			
			// Filter AND/OR
			if (type == FILTER_AND || type == FILTER_OR)
			{
				var ex_array:Array = [];
				for (var i:int = 0; i < filters.length; i++)
				{
					ex_array.push(filters[i].export());
				}
				obj["filters"] = ex_array;
				
				if (name && name != "")
					obj["name"] = name;
			}
			else
			{
				obj["comparison"] = comparison;
				obj["input_number"] = input_number;
				obj["input_string"] = input_string;
					
				if (type == FILTER_STATS)
					obj["input_stat"] = input_stat;
			}
			return obj;
		}
		
		public function setDefaultComparison():void
		{
			switch (type)
			{
				case FILTER_STATS: 
					comparison = FILTERS_STAT[0];
					break;
				
				case FILTER_ARROWCOUNT: 
				case FILTER_BPM: 
				case FILTER_DIFFICULTY: 
				case FILTER_MAX_NPS: 
				case FILTER_MIN_NPS: 
				case FILTER_RANK: 
				case FILTER_SCORE: 
				case FILTER_TIME: 
					comparison = FILTERS_NUMBER[0];
					break;
				
				case FILTER_ID: 
				case FILTER_NAME: 
				case FILTER_STYLE: 
				case FILTER_ARTIST: 
				case FILTER_STEPARTIST: 
					comparison = FILTERS_STRING[0];
					break;
			}
		}
		
		public function toString():String
		{
			return type + " [" + comparison + "]" 
					+ (!isNaN(input_number) ? " input_number=" + input_number : "") 
					+ (input_string != null ? " input_string=" + input_string : "") 
					+ (input_stat != null ? " input_stat=" + input_stat : "");
		}
		
		static public function createOptions(core:EngineCore, filtersString:Array, type:String):Array 
		{
			var options:Array = [];
			for (var i:int = 0; i < filtersString.length; i++) 
			{
				options.push([core.getString("filter_" + type + "_" + filtersString[i]), filtersString[i]]);
			}
			
			return options;
		}
	}
}