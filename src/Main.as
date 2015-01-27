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
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			// Init Classes
			JSONManager.init();
			core = new EngineCore();
			
			// Load active User
			core.user = new User(true, true);
			
			// Load FFR Playlist, Site Data, Language Text
			var requestParams:Object = { "session": Constant.GAME_SESSION, "ver": Constant.VERSION, "debugLimited": true };
			var canonLoader:EngineLoader = new EngineLoader(core, Constant.GAME_ENGINE, Constant.GAME_NAME);
			canonLoader.isCanon = true;
			canonLoader.loadPlaylist(Constant.PLAYLIST_URL, requestParams );
			canonLoader.loadInfo(Constant.SITE_DATA_URL, requestParams );
			canonLoader.loadLanguage(Constant.LANGUAGE_URL, requestParams );
			
			// Load Legacy Engine Data
			var legacyLoader:EngineLoader = new EngineLoader(core);
			legacyLoader.loadFromXML("http://keysmashingisawesome.com/r3.xml");
			
			addEventListener(Event.ENTER_FRAME, e_onEnterFrame);
		}
		
		private function e_onEnterFrame(e:Event):void 
		{
			var el:EngineLoader = core.getCurrentLoader();
			
			if (el.loaded)
			{
				trace("4:[Main] FFR Core Engine Loaded.");
				removeEventListener(Event.ENTER_FRAME, e_onEnterFrame);
			}
		}
		
	}
	
}