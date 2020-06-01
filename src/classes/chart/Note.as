package classes.chart {
	
	public class Note {
		public static const COLOR_INDEXES:Object = {
				"blue": 0,
				"red": 1,
				"green": 2,
				"yellow": 3,
				"pink": 4,
				"purple": 5,
				"orange": 6,
				"cyan": 7,
				"white": 8
			};

		public var direction:String;
		public var time:Number;
		public var color:int;
		
		/**
		 * Defines a new Note object.
		 * @param	direction
		 * @param	pos
		 * @param	color
		 */
		public function Note(direction:String, time:Number, color:String):void {
			this.direction = direction;
			this.time = time;
			this.color = COLOR_INDEXES[color];
		}
	}
}