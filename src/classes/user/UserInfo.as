package classes.user
{
	/**
	 * User Information Class
	 * Stores user specific information unique to FFR the Game.
	 */
	public class UserInfo
	{
		public var hash:String;
		public var forum_groups:Array;
		public var join_date:String;

		public var credits:Number;
		public var game_rank:Number;
		public var games_played:Number;
		public var grand_total:Number;
		public var skill_level:Number;
		public var skill_rating:Number;
		
		public var total_replays:int;
		public var max_replays:int;
		public var songs_purchased:Array;
		public var song_ratings:Object;
		
		public function UserInfo(obj:Object = null)
		{
			if (obj != null)
			{
				setup(obj);
			}
		}
		
		public function setup(obj:Object):void
		{
			// User Purchased Songs
			this.songs_purchased = [];
			if (obj["purchased"])
			{
				for (var x:int = 1; x < obj["purchased"].length; x++)
				{
					this.songs_purchased.push(obj["purchased"].charAt(x));
				}
			}
			
			// Common Variables
			this.hash = obj["hash"] ? obj["hash"] : "";
			this.forum_groups = obj["groups"] ? obj["groups"] : [];
			this.join_date = obj["joinDate"] ? obj["joinDate"] : "";

			this.credits = obj["credits"] ? obj["credits"] : 0;
			this.game_rank = obj["gameRank"] ? obj["gameRank"] : 0;
			this.games_played = obj["gamesPlayed"] ? obj["gamesPlayed"] : 0;
			this.grand_total = obj["grandTotal"] ? obj["grandTotal"] : 0;
			this.skill_level = obj["skillLevel"] ? obj["skillLevel"] : 0;
			this.skill_rating = obj["skillRating"] ? obj["skillRating"] : 0;
			
			this.total_replays = obj["totalreplays"] ? obj["totalreplays"] : 0;
			this.max_replays = obj["maxreplays"] ? obj["maxreplays"] : 0;
			this.song_ratings = obj["song_ratings"] ? obj["song_ratings"] : {};
		}
	}

}