package classes.engine.track 
{
	public class TrackConfigLane 
	{
		public var track:String;
		
		public var x:Array;
		public var y:Array;
		
		public var rotation:int = 0;
		public var vertex:String = "y";
		public var direction:int = 1;
		
		public var anchor:int = 0;
		
		/**
		 * Loads JSON object into structure.
		 * @param	input
		 */
		public function load(input:Object):void 
		{
			this.x = input.x;
			this.y = input.y;
			
			this.rotation = input.rotation;
			this.vertex = input.vertex;
			this.direction = input.direction;
			
			if (input.anchor != null)
				this.anchor = input.anchor;
		}
	}

}