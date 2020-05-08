package classes.engine 
{
	public class EngineSiteInfo 
	{
		public var data:Object;
		public var id:String;
		public var valid:Boolean = false;
		
		/*
		// News
		[news_title] (string) => Latest News Post Title
		[news_text] (string) => Latest News Post
		[news_date] (string) => Latest News Post Timestamp
		
		// Tokens
		[game_tokens] => (object) {
			[level_id_linked] => (object) {
				[level] => (string) // Level ID, same as level_id_linked
				[name] => (string) // Token Name
				[picture] => (string) // Path to Token Image
				[type] => (string) // Token Type
				[info] => (string) // Unlock Description
				[unlock] => (number) // 0-1, 1 is Unlocked
				[id] => (string) // Token ID
			}
		}
		
		// Other
		[game_maxcredits] => (number) // Max Cedits to awards per song.
		[game_nonpublic_genres] => (array) // Genre Id to exclude from public song count
		
		[game_tournamentSongs] => (object) {
			[game_tournamentSongs] => object) {
				[division] => (object) {
					[n] => (string) "level_id" // n Starting at 1.
				}
			}
		}
		*/
		
		public function EngineSiteInfo(id:String) 
		{
			this.id = id;
		}
		
		public function parseData(str:String):void 
		{
			try
			{
				data = JSON.parse(str);
				valid = true;
			}
			catch (e:Error)
			{
				Logger.log(this, Logger.ERROR, "Malformed JSON Data.");
				return;
			}
		}
		
		/**
		 * Returns information loaded for the engines site info.
		 * @param	id	Key of Requested Data.
		 * @return 	* 	Requested Data or null
		 */
		public function getData(id:String):*
		{
			return data[id];
		}
	}
}