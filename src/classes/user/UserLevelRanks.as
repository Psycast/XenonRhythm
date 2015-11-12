package classes.user
{
	import classes.engine.EngineRanks;
	
	/**
	 * User Level Ranks
	 * Stores User Engine Ranks.
	 */
	public class UserLevelRanks
	{
		public var engines:Array;
		
		public function UserLevelRanks()
		{
			this.engines = [];
			
			this.engines[Constant.GAME_ENGINE] = new EngineRanks(Constant.GAME_ENGINE);
		}
		
		/**
		 * Returns the EngineRanks for the specified engine id.
		 * @param	engine		Engine ID
		 * @param	createNew	Create new EngineRanks for engine if not found.
		 * @return	EngineRanks, null
		 */
		public function getEngineRanks(engine:String, createNew:Boolean = false):EngineRanks
		{
			if (!this.engines[engine] || createNew)
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