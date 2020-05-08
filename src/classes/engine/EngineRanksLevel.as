package classes.engine
{
	
	public class EngineRanksLevel
	{
		public var level:String = "";
		public var genre:int = 0; // Used to calculate average rank.
		
		public var rank:int = 0;
		public var score:int = 0;
		
		public var amazing:int = 0;
		public var perfect:int = 0;
		public var good:int = 0;
		public var average:int = 0;
		public var miss:int = 0;
		public var boo:int = 0;
		public var combo:int = 0;
		
		public function EngineRanksLevel(level:String)
		{
			this.level = level;
		}
		
		// Results - Format [0]'perfect' - [1]'good' - [2]'average' - [3]'miss' - [4]'boo' - [5]'maxcombo'
		// Optional prefix [0]'amazing'
		public function set results(results:String):void
		{
			// Split Results
			var scoreResults:Array = results.split("-");
			for (var s:String in scoreResults)
			{
				scoreResults[s] = int(scoreResults[s]);
			}
			
			// Set Variables
			var off:int = 0;
			if (scoreResults.length == 7) // Includes Amazings
			{
				amazing = scoreResults[off++];
			}
			perfect = scoreResults[off++];
			good = scoreResults[off++];
			average = scoreResults[off++];
			miss = scoreResults[off++];
			boo = scoreResults[off++];
			combo = scoreResults[off++];
		}
		
		public function get results():String
		{
			return (amazing > 0 ? amazing + "-" : "") + perfect + "-" + good + "-" + average + "-" + miss + "-" + boo + "-" + combo;
		}
		
		public function get raw_score():int
		{
			return ((amazing + perfect) * 50) + (good * 25) + (average * 5) - (miss * 10) - (boo * 5);
		}
	}
}