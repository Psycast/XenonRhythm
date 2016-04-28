package classes.user
{
	import classes.engine.EngineLevel;
	import classes.engine.EngineLoader;
	import classes.engine.EngineRanks;
	import classes.engine.EngineRanksLevel;
	import com.flashfla.utils.ArrayUtil;
	
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
		
		public function getAverageRank(engine:EngineLoader):Number
		{
			var engineRanks:EngineRanks = this.engines[engine.id];
			var public_songs:Array = engine.playlist.index_list;
			
			// Filter Out Non-public Genres
			if (engine.info != null)
			{
				var nonpublic_genres:Array = engine.info.getData("game_nonpublic_genres");
				if (nonpublic_genres != null)
				{
					public_songs = public_songs.filter(function(item:EngineLevel, index:int, array:Array):Boolean
					{
						return !ArrayUtil.in_array([item.genre], nonpublic_genres)
					})
				}
			}
			
			// Total Ranks
			var levelRank:EngineRanksLevel;
			var totalRanks:Number = 0;
			for (var i:int = 0; i < public_songs.length; i++) 
			{
				levelRank = engineRanks.getRank(public_songs[i].id);
				
				if(levelRank)
					totalRanks += engineRanks.getRank(public_songs[i].id).rank;
			}
			
			return totalRanks / engine.playlist.total_public_songs;
		}
	
	}

}