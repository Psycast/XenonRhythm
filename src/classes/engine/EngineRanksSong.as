package classes.engine 
{

	public class EngineRanksSong 
	{
		public var songid:String;
		public var genre:int;
		
		public var rank:int;
		public var score:int;
		
		public var amazing:int;
		public var perfect:int;
		public var good:int;
		public var average:int;
		public var miss:int;
		public var boo:int;
		public var combo:int;
		
		public function EngineRanksSong(songid:String) 
		{
			this.songid = songid;
		}
		
		// Results - Format [0]'perfect' - [1]'good' - [2]'average' - [3]'miss' - [4]'boo' - [5]'maxcombo'
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
			return (amazing > 0 ? amazing + "-" : "") + perfect + "-" +  good + "-" + average + "-" + miss + "-" + boo + "-" + combo;
		}
		
		public function get raw_score():int
		{
			return ((amazing + perfect) * 50) + (good * 25) + (average * 5) - (miss * 10) - (boo * 5);
		}
	}

}