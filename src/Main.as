package
{
	import classes.engine.EngineCore;
	import classes.user.User;
	import com.adobe.serialization.json.JSONManager;
	import flash.display.Sprite;
	import flash.events.Event;
	import scenes.loader.GameLoader_UI;
	
	public class Main extends Sprite
	{
		public var core:EngineCore;
		
		public function Main():void
		{
			//trace("2:------------------------------------------------------------------------------------------------");
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
			core.ui = new UI();
			
			addChild(core.ui);
			
			// Load User
			core.user = new User(true, true);
			
			// Jump to Game Loader
			core.scene = new GameLoader_UI(core);
		}
	}

}