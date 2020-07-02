package classes.engine
{
	public class EngineLevelDetails
	{
		private static var FPS:int = 30;
		private static var NORMALIZE_POINTS:int = 50;

		public var total_length:Number = 0;
		public var effective_length:Number = 0;
		public var first_note_delay:Number = 0;
		public var last_note_delay:Number = 0;

		public var chord_count:int = 0;
		public var average_nps:Number = 0;

		public var note_delays:Array;
		public var hand_bias:int = 0;
		public var camel_jacks:int = 0;

		public var jumps:Array;
		public var color_jumps:Array;

		public var framers:Array;
		public var density:Array;
		public var color_totals:Array;

		private var _nps_string:String;
		public var nps_data:Array;
		public var nps_data_normalized:Array;
		public var nps_data_normalized_max:Number = 0;

		public function EngineLevelDetails(item:Object):void
		{
			if(item.total_length)
				this.total_length = item.total_length / FPS; // In Frames

			if(item.eff_length)
				this.effective_length = item.eff_length / FPS; // In Frames

			if(item.first_delay)
				this.first_note_delay = item.first_delay / FPS; // In Frames

			if(item.last_delay)
				this.last_note_delay = item.last_delay / FPS; // In Frames

			if(item.chord_count)
				this.chord_count = item.chord_count;

			if(item.avg_nps)
				this.average_nps = item.avg_nps;

			if(item.note_delays)
				this.note_delays = item.note_delays;

			if(item.hand_bias)
				this.hand_bias = item.hand_bias;

			if(item.camel_jacks)
				this.camel_jacks = item.camel_jacks;

			if(item.jumps)
				this.jumps = item.jumps;

			if(item.color_jumps)
				this.color_jumps = item.color_jumps;

			if(item.framers)
				this.framers = item.framers;

			if(item.density)
				this.density = item.density;

			if(item.color_totals)
				this.color_totals = item.color_totals;
		}

		public function set nps_string(data:String):void
		{
			_nps_string = data;
			nps_data = data.split("|").map(parseIntMap);

			// Normalize into a constant amount of data points or less.
			if(nps_data.length <= NORMALIZE_POINTS)
			{
				nps_data_normalized = nps_data;
				nps_data_normalized_max = Math.max.apply(null, nps_data);
			}
			else
			{
				var valuesPerPoint:int = Math.floor(nps_data.length / NORMALIZE_POINTS);
				var normalData:Array = [];
				var curIndex:int = 0;
				var curSum:Number = 0;
				for(var i:int = 0; i < nps_data.length; i++)
				{
					curSum += nps_data[i];
					curIndex++;
					if(curIndex >= valuesPerPoint)
					{
						normalData[normalData.length] = (curSum / curIndex);
						curSum = 0;
						curIndex = 0;
					}
				}

				// Include last value.
				if(curIndex > 0)
					normalData[normalData.length] = (curSum / curIndex);
				
				nps_data_normalized = normalData;
				nps_data_normalized_max = Math.max.apply(null, nps_data_normalized);
			}
		}

		public function get nps_string():String
		{
			return _nps_string;
		}

		private static function parseIntMap(value:String, index:int, array:Array):Number {
			return parseInt(value);
		}

		///////////////////
		
		public function toJSON(k:String):Object
		{
			return {
				"total_length": total_length,
				"effective_length": effective_length,
				"first_note_delay": first_note_delay,
				"last_note_delay": last_note_delay,
				"chord_count": chord_count,
				"average_nps": average_nps,
				"note_delays": note_delays,
				"hand_bias": hand_bias,
				"camel_jacks": camel_jacks,
				"jumps": jumps,
				"color_jumps": color_jumps,
				"framers": framers,
				"density": density,
				"color_totals": color_totals,
				"nps_string": nps_string,
				"nps_data": nps_data,
				"nps_data_normalized": nps_data_normalized,
				"nps_data_normalized_max": nps_data_normalized_max
			};
		}
	}
}