package classes.engine
{
	
	public class EngineRanks
	{
		public var id:String;
		public var ranks:Array = [];
		
		public function EngineRanks(id:String)
		{
			this.id = id;
		}
		
		public function getRank(level:String):EngineRanksSong
		{
			if (!ranks[level])
			{
				ranks[level] = new EngineRanksSong(level);
			}
			
			return ranks[level];
		}
		
		public function setRank(level:String, data:EngineRanksSong):void
		{
			ranks[level] = data;
		}
	}

}