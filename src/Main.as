package
{
	import classes.engine.EngineCore;
	import classes.engine.EngineLoader;
	import classes.user.User;
	import com.adobe.serialization.json.JSONManager;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Main extends Sprite
	{
		public var core:EngineCore;
		
		public function Main():void
		{
			trace("2:------------------------------------------------------------------------------------------------");
			//for (var i:int = 0; i < 5; i++) trace(i + ":", i);
			
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			// Init Classes
			JSONManager.init();
			core = new EngineCore();
			
			// Load active User
			core.user = new User(true, true);
			
			addEventListener(Event.ENTER_FRAME, e_onEnterFrame);
		}
		
		private function e_onEnterFrame(e:Event):void
		{
			// Check User Loaded.
			if (core.user.isLoaded)
			{
				// Check for Guest and never attempted Login.
				if (core.user.permissions.isGuest && !core.user.permissions.didLogin)
				{
					trace("0:[Main] User is guest, showing login.");
					removeEventListener(Event.ENTER_FRAME, e_onEnterFrame);
					
					// Login User
					var session:Session = new Session(_loginUserComplete, _loginUserError);
					session.login(DebugStrings.USERNAME, DebugStrings.PASSWORD);
				}
				// Engine Loading
				else
				{
					var el:EngineLoader = core.getCurrentLoader();
					if (el == null)
					{
						trace("4:[Main] Loading FFR Core Engine.");
						_loadEngines();
					}
					else if (el.loaded)
					{
						trace("4:[Main] FFR Core Engine Loaded.");
						removeEventListener(Event.ENTER_FRAME, e_onEnterFrame);
					}
				}
			}
		}
		
		private function _loadEngines():void
		{
			// Load FFR Playlist, Site Data, Language Text
			var requestParams:Object = {"session": Session.SESSION_ID, "ver": Constant.VERSION, "debugLimited": true};
			var canonLoader:EngineLoader = new EngineLoader(core, Constant.GAME_ENGINE, Constant.GAME_NAME);
			canonLoader.isCanon = true;
			canonLoader.loadFromConfig(Constant.SITE_CONFIG_URL, requestParams);
		}
		
		private function _loginUserComplete(e:Event):void
		{
			trace("0:[Main] User Login Success");
			
			// Load User using Session
			core.user = new User(true, true);
			core.user.permissions.didLogin = true;
			
			addEventListener(Event.ENTER_FRAME, e_onEnterFrame);
		}
		
		private function _loginUserError(e:Event):void
		{
			trace("0:[Main] User Login Error, FULL STOP~");
		}
	
	}

}