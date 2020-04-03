package scenes.gameplay 
{
	public class ScoreValues 
	{
		public var amazing:Number = 0;
		public var perfect:Number = 0;
		public var good:Number = 0;
		public var average:Number = 0;
		public var miss:Number = 0;
		public var boo:Number = 0;
		public var combo:Number = 0;
		public var max_combo:Number = 0;
		
		public function get raw_goods():Number
		{
			return good + (average * 1.8) + (miss * 2.4) + (boo * 0.2);
		}
	}

}