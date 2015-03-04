package classes.user
{
	import classes.engine.EngineRanks;
	import classes.engine.EngineRanksLevel;
	import classes.engine.EngineSettings;
	import classes.user.UserInfo;
	import classes.user.UserPermissions;
	import com.adobe.serialization.json.JSONManager;
	import com.flashfla.net.WebRequest;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	
	public class User extends EventDispatcher
	{
		private var _isLoaded:Boolean;
		private var _isLoadedRanks:Boolean;
		
		// User Data
		public var name:String;
		public var id:uint;
		public var avatar:Loader;
		
		public var info:UserInfo;
		public var permissions:UserPermissions;
		public var settings:EngineSettings;
		public var levelranks:UserLevelRanks;
		
		public function User(loadData:Boolean = false, isActiveUser:Boolean = false, userid:int = 0):void
		{
			this.info = new UserInfo();
			this.permissions = new UserPermissions();
			this.levelranks = new UserLevelRanks();
			this.settings = new EngineSettings();
			
			// Setup Active User
			this.permissions.isActiveUser = isActiveUser;
			
			// Load Data
			if (loadData)
			{
				load(userid);
			}
		}
		
		public function load(userid:int = 0):void
		{
			// Create Request
			var wr:WebRequest = new WebRequest(userid == 0 ? Constant.USER_INFO_URL : Constant.USER_SMALL_INFO_URL, e_profileOnComplete, e_profileOnError);
			
			// Request Params
			var o:Object = new Object();
			o["ver"] = Constant.VERSION;
			o["session"] = Session.SESSION_ID;
			o["userid"] = userid;
			
			// Load
			wr.load(o);
		}
		
		public function loadLevelRanks():void
		{
			// Guest don't need ranks.
			if (this.permissions.isGuest) {
				// Set isLoadedRanks
				_isLoadedRanks = true;
				
				// Trigger Loaded Event
				_eventIsLoaded();
				return;
			}
			
			// Create Request
			var wr:WebRequest = new WebRequest(Constant.USER_RANKS_URL, e_ranksOnComplete, e_ranksOnError);
			
			// Request Params
			var o:Object = new Object();
			o["ver"] = Constant.VERSION;
			o["session"] = Session.SESSION_ID;
			
			// Load
			wr.load(o);
		}
		
		public function setupUserData(_data:Object):void
		{
			// Important Data
			this.name = _data["name"];
			this.id = _data["id"];
			
			// Load Avatar
			this.avatar = new Loader();
			this.avatar.load(new URLRequest(Constant.USER_AVATAR_URL + "?uid=" + this.id + "&cHeight=99&cWidth=99"));
			
			// Setup Class Data
			this.info.setup(_data);
			this.permissions.setup(this);
			
			// Setup Settings
			if (_data["settings"] && !this.permissions.isGuest)
			{
				this.settings.setup(JSONManager.decode(_data["settings"]));
			}
		}
		
		public function setupRanks(_data:Object):void
		{
			var er:EngineRanks = levelranks.getEngineRanks(Constant.GAME_ENGINE);
			var songRank:EngineRanksLevel;
			
			// Parse Data
			var rankTemp:Array = _data.split(",");
			var rankLength:int = rankTemp.length;
			for (var x:int = 0; x < rankLength; x++)
			{
				// [0] = Level ID : [1] = Rank : [2] = Score : [3] = Genre : [4] = Results
				var rankSplit:Array = rankTemp[x].split(":");
				
				songRank = new EngineRanksLevel(rankSplit[0]);
				songRank.rank = int(rankSplit[1]);
				songRank.score = int(rankSplit[2]);
				songRank.genre = int(rankSplit[3]);
				songRank.results = rankSplit[4];
				
				er.setRank(songRank);
			}
		}
		
		public function get isLoaded():Boolean
		{
			return this.permissions.isActiveUser ? (_isLoaded && _isLoadedRanks) : _isLoaded;
		}
		
		//- Events
		// Profile Data
		private function e_profileOnComplete(e:Event):void
		{
			trace("0:[User] Profile Load Complete");
			// JSON Decode Data
			var _data:Object = JSONManager.decode(e.target.data);
			
			// Setup Data
			setupUserData(_data);
			
			// Load Level Ranks if Active User
			if (this.permissions.isActiveUser)
			{
				loadLevelRanks();
			}
			
			// Set isLoaded
			_isLoaded = true;
			
			// Trigger Loaded Event
			_eventIsLoaded();
		}
		
		private function e_profileOnError(e:Event):void
		{
			trace("3:[User] Profile Load Error");
		}
		
		// Ranks
		private function e_ranksOnComplete(e:Event):void
		{
			trace("0:[User] Ranks Load Complete");
			var _data:Object = e.target.data;
			
			setupRanks(_data);
			
			// Set isLoadedRanks
			_isLoadedRanks = true;
			
			// Trigger Loaded Event
			_eventIsLoaded();
		}
		
		private function e_ranksOnError(e:Event):void
		{
			trace("3:[User] Ranks Load Error");
		}
		
		//- Event Dispatching
		private function _eventIsLoaded():void
		{
			if (isLoaded)
			{
				this.dispatchEvent(new Event("LOAD_COMPLETE"));
			}
		}
	}

}