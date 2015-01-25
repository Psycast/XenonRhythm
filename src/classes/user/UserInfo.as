package classes.user
{
	
	public class UserInfo
	{
		public var hash:String;
		public var join_date:String;
		public var credits:uint;
		public var game_rank:Number;
		public var games_played:uint;
		public var grand_total:uint;
		public var songs_purchased:Array;
		public var forum_groups:Array;
		
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
			this.credits = obj["credits"] ? obj["credits"] : 0;
			this.forum_groups = obj["groups"] ? obj["groups"] : [];
			this.join_date = obj["joinDate"] ? obj["joinDate"] : "";
			this.game_rank = obj["gameRank"] ? obj["gameRank"] : 0;
			this.games_played = obj["gamesPlayed"] ? obj["gamesPlayed"] : 0;
			this.grand_total = obj["grandTotal"] ? obj["grandTotal"] : 0;
		}
	}

}