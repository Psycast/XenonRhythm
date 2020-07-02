package classes.user
{
	import classes.engine.EngineRanks;
	import classes.engine.EngineRanksLevel;
	import classes.engine.EngineSettings;
	import classes.user.UserInfo;
	import classes.user.UserPermissions;
	import com.flashfla.utils.StringUtil;
	import com.flashfla.net.WebRequest;
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import classes.engine.EngineCore;
	
	/**
	 * Core User Class for Game Engine.
	 * Handles all user information for a single user.
	 */
	public class User extends EventDispatcher
	{
		public static const PROFILE:String = "PROFILE";
		public static const AVATAR:String = "AVATAR";
		public static const RANK:String = "RANK";

		private var core:EngineCore;
		
		private var _isLoaded:Boolean;
		private var _isLoadedRanks:Boolean;
		
		// Loader Data
		public var loader_id:String = Constant.GAME_ENGINE;
		
		// User Data
		public var name:String;
		public var id:uint;
		public var avatar:Loader;
		
		public var info:UserInfo;
		public var permissions:UserPermissions;
		public var settings:EngineSettings;
		public var levelranks:UserLevelRanks;
		
		/**
		 * Constructor for User
		 * @param	loadData		Automatically Load User Data
		 * @param	isActiveUser	Is Active/Current User
		 * @param	userid			UserID
		 */
		public function User(core:EngineCore, loadData:Boolean = false, isActiveUser:Boolean = false, userid:int = 0):void
		{
			this.core = core;

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
		
		/**
		 * Loads user info for the specified userid.
		 * @param	userid	UserID to load.
		 */
		public function load(userid:int = 0):void
		{
			// Create Request
			var wr:WebRequest = new WebRequest(userid == 0 ? core.canonLoader.config.user_info_url : core.canonLoader.config.user_info_url, e_profileOnComplete, e_profileOnError);
			
			// Request Params
			var o:Object = new Object();
			o["ver"] = Constant.VERSION;
			o["session"] = Session.SESSION_ID;
			o["userid"] = userid;
			
			// Load
			wr.load(o);
		}
		
		/**
		 * Loads the user level ranks if not guest.
		 */
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
			var wr:WebRequest = new WebRequest(core.canonLoader.config.user_ranks_url, e_ranksOnComplete, e_ranksOnError);
			
			// Request Params
			var o:Object = new Object();
			o["ver"] = Constant.VERSION;
			o["session"] = Session.SESSION_ID;
			
			// Load
			wr.load(o);
		}
		
		/**
		 * Sets user info from the loaded data from "load()".
		 * @param	_data	Object Containing User information.
		 */
		public function setupUserData(_data:Object):void
		{
			// Important Data
			this.name = _data["name"];
			this.id = _data["id"];
			
			// Load Avatar
			if (_data["avatar"] && _data["avatar"] != "")
			{
				this.avatar = new Loader();
				this.avatar.load(new URLRequest(_data["avatar"]));
				this.avatar.contentLoaderInfo.addEventListener(Event.COMPLETE, e_avatarLoadComplete);
				this.avatar.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, e_avatarLoadError);
				this.avatar.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, e_avatarLoadError);
			}
			
			// Setup Class Data
			this.info.setup(_data);
			this.permissions.setup(this);
			
			// Setup Settings
			if (_data["settings"] && !this.permissions.isGuest)
			{
				this.settings.setup(JSON.parse(_data["settings"]));
			}
		}
		
		private function e_avatarLoadComplete(e:Event):void 
		{
			Logger.log(this, Logger.INFO, "Avatar Load Complete");
			this.avatar.contentLoaderInfo.removeEventListener(Event.COMPLETE, e_avatarLoadComplete);
			this.avatar.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, e_avatarLoadError);
			this.avatar.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, e_avatarLoadError);
		}
		
		private function e_avatarLoadError(e:Event):void 
		{
			Logger.log(this, Logger.ERROR, "Avatar Load Error");
			this.avatar.contentLoaderInfo.removeEventListener(Event.COMPLETE, e_avatarLoadComplete);
			this.avatar.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, e_avatarLoadError);
			this.avatar.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, e_avatarLoadError);
			this.avatar = null;
			this.dispatchEvent(new ErrorEvent(AVATAR));
		}
		
		/**
		 * Sets User ranks for loaded data from "loadLevelRanks()".
		 * @param	_data	String containing formatted user ranks.
		 */
		public function setupRanks(_data:String):void
		{
			var er:EngineRanks = levelranks.getEngineRanks(Constant.GAME_ENGINE);
			var songRank:EngineRanksLevel;
			
			// Parse Data
			if (_data != "")
			{
				var rankTemp:Array = _data.split(",");
				var rankLength:int = rankTemp.length;
				for (var x:int = 0; x < rankLength; x++)
				{
					// [0] = Level ID : [1] = Rank : [2] = Score : [3] = Genre : [4] = Results : [5] Play Count
					var rankSplit:Array = rankTemp[x].split(":");
					
					if (rankSplit.length == 6)
					{
						songRank = new EngineRanksLevel(rankSplit[0]);
						songRank.rank = int(rankSplit[1]);
						songRank.score = int(rankSplit[2]);
						songRank.genre = int(rankSplit[3]);
						songRank.results = rankSplit[4];
						songRank.play_count = int(rankSplit[5]);
						
						er.setRank(songRank);
					}
				}
			}
		}
		
		/**
		 * Returns true if User Info is loaded.
		 */
		public function get isLoaded():Boolean
		{
			return this.permissions.isActiveUser ? (_isLoaded && _isLoadedRanks) : _isLoaded;
		}
		
		//- Events
		// User Data
		/**
		 * Profile Load Complete Event.
		 * JSON decodes loaded data and setups user info and loads level ranks if not guest.
		 * @param	e 	URLLoader event from "load()" WebRequest.
		 */
		private function e_profileOnComplete(e:Event):void
		{
			Logger.log(this, Logger.INFO, "Profile Load Complete");
			// JSON Decode Data
			var _data:Object = JSON.parse(StringUtil.trim(e.target.data));
			
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
		
		/**
		 * Profile Load Error Event.
		 * @param	e 	URLLoader event from "load()" WebRequest.
		 */
		private function e_profileOnError(e:Event):void
		{
			Logger.log(this, Logger.ERROR, "Profile Load Error");
			this.dispatchEvent(new ErrorEvent(PROFILE));
		}
		
		// Ranks
		/**
		 * User Ranks Load Complete Event.
		 * Setups user ranks.
		 * @param	e 	URLLoader event from "loadLevelRanks()" WebRequest.
		 */
		private function e_ranksOnComplete(e:Event):void
		{
			Logger.log(this, Logger.INFO, "Ranks Load Complete");
			var _data:String = StringUtil.trim(e.target.data);
			
			setupRanks(_data);
			
			// Set isLoadedRanks
			_isLoadedRanks = true;
			
			// Trigger Loaded Event
			_eventIsLoaded();
		}
		
		/**
		 * User Ranks Load Error Event.
		 * @param	e 	URLLoader event from "loadLevelRanks()" WebRequest.
		 */
		private function e_ranksOnError(e:Event):void
		{
			Logger.log(this, Logger.ERROR, "Ranks Load Error");
			this.dispatchEvent(new ErrorEvent(RANK));
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