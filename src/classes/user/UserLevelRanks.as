package classes.user
{
	import classes.engine.EngineRanks;
	
	public class UserLevelRanks
	{
		public var engines:Array;
		
		public function UserLevelRanks()
		{
			this.engines = [];
			
			this.engines[Constant.GAME_ENGINE] = new EngineRanks(Constant.GAME_ENGINE);
		}
		
		public function getEngineRanks(engine:String, createNew:Boolean = false):EngineRanks
		{
			if (createNew)
			{
				this.engines[engine] = new EngineRanks(engine);
			}
			
			if (this.engines[engine])
			{
				return this.engines[engine];
			}
			
			return null;
		}
	
	}

}