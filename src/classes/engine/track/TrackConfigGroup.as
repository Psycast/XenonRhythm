package classes.engine.track 
{

	public class TrackConfigGroup 
	{
		public var id:String;
		public var name:String;
		public var config:String = "4key";
		public var anchor:int = 0;
		
		public var track_lanes:Object = {};
		
		public var lane_order:Vector.<String>;
		public var lane_count:int = 0;
		
		public var impulse_bound:TrackImpulseBounds = new TrackImpulseBounds(0, 0, 0, 0);
		
		/**
		 * Loads JSON object into structure.
		 * @param	input
		 */
		public function load(input:Object):void
		{
			this.id = input.id;
			this.name = input.name;
			this.config = input.config;
			this.anchor = input.anchor;
			
			var trackObj:TrackConfigLane;
			for (var track:String in input.tracks) 
			{
				trackObj = new TrackConfigLane();
				trackObj.track = track;
				trackObj.load(input.tracks[track]);
				
				track_lanes[track] = trackObj;
			}
			
			lane_order = arrayToStringVector(input.lane_order);
			lane_count = lane_order.length;
			impulse_bound.updateFrom(input.impulse_bounds);
		}
		
		private static function arrayToStringVector(__strings:Array):Vector.<String> {
			var v:Vector.<String> = new Vector.<String>(__strings.length, true);
			if (__strings != null) {
				for (var i:int = 0; i < __strings.length; i++) v[i] = __strings[i];
			}
			return v;
		}
	}
}