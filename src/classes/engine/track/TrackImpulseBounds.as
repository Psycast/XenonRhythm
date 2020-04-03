package classes.engine.track 
{

	public class TrackImpulseBounds 
	{
		public var min_x:Number = 0;
		public var max_x:Number = 0;
		public var min_y:Number = 0;
		public var max_y:Number = 0;
		
		public function TrackImpulseBounds(_min_x:Number = 0, _max_x:Number = 0, _min_y:Number = 0, _max_y:Number = 0) 
		{
			this.min_x = _min_x;
			this.max_x = _max_x;
			this.min_y = _min_y;
			this.max_y = _max_y;
		}
		
		public function updateFrom(input:Object):void
		{
			this.min_x = input.min_x;
			this.max_x = input.max_x;
			this.min_y = input.min_y;
			this.max_y = input.max_y;
		}
		
	}

}