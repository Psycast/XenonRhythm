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
		
		public function getRank(level:String):EngineRanksLevel
		{
			if (!ranks[level])
			{
				ranks[level] = new EngineRanksLevel(level);
			}
			
			return ranks[level];
		}
		
		public function setRank(data:EngineRanksLevel):void
		{
			ranks[data.level] = data;
		}
	}

}