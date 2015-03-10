package scenes.loader
{
	import classes.engine.EngineCore;
	import classes.engine.EngineLoader;
	import classes.UICore;
	import flash.events.Event;
	import scenes.home.TitleScreen_UI;
	
	public class GameLoader extends UICore
	{
		
		public function GameLoader(core:EngineCore)
		{
			super(core);
		}
		
		override public function init():void
		{
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
					log(0, "User is guest, showing login.");
					removeEventListener(Event.ENTER_FRAME, e_onEnterFrame);
					core.scene = new GameLogin_UI(core);
				}
				// Engine Loading
				else
				{
					var el:EngineLoader = core.getCurrentLoader();
					if (el == null)
					{
						log(4, "Loading FFR Core Engine.");
						_loadEngines();
					}
					else if (el.loaded)
					{
						log(4, "FFR Core Engine Loaded.");
						removeEventListener(Event.ENTER_FRAME, e_onEnterFrame);
						core.scene = new TitleScreen_UI(core);
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
	}

}