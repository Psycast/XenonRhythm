package classes.chart {
	
	public class Note {
		public var direction:String;
		public var time:Number;
		public var color:String;
		
		/**
		 * Defines a new Note object.
		 * @param	direction
		 * @param	pos
		 * @param	color
		 * @param	frame
		 */
		public function Note(direction:String, time:Number, color:String):void {
			this.direction = direction;
			this.time = time;
			this.color = color;
		}

	}
}