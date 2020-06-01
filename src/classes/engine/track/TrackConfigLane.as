package classes.engine.track 
{
	public class TrackConfigLane 
	{
		public var index:int = 0;
		public var track:String;
		
		public var x:Array;
		public var y:Array;
		
		/** Rotation, in radians. */
		public var rotation:Number = 0;

		/** Rotation, in degrees. */
		public var rotation_deg:Number = 0;

		/** Vertex Direction is applied to. 0 is y, 1 is x*/
		public var vertex:int = 0;

		/** Direction of Velocity, 1 or -1 */
		public var direction:int = 1;
		
		/** UI Anchor Point for Lane, see "ui.UIAnchor" */
		public var anchor:int = 0;
		
		/**
		 * Loads JSON object into structure.
		 * @param	input
		 */
		public function load(input:Object):void 
		{
			this.index = input.index;
			
			this.x = input.x;
			this.y = input.y;
			
			this.rotation_deg = ((input.rotation + 360) % 360); // Wrap Rotation into the 0-359 range.
			this.rotation = this.rotation_deg / 180.0 * Math.PI; // Convert Degree to Radians;
			this.vertex = (input.vertex == "x" ? 1 : 0);
			this.direction = input.direction;
			
			if (input.anchor != null)
				this.anchor = input.anchor;
		}
	}

}