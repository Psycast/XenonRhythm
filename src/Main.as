package
{
	import classes.engine.EngineCore;
	import classes.user.User;
	import com.adobe.serialization.json.JSONManager;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import scenes.loader.SceneGameLoader;
	
	public class Main extends Sprite
	{
		public var core:EngineCore;
		
		public function Main():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			// Welcome Message
			Logger.divider(this);
			Logger.log(this, Logger.WARNING, "Game Started, Welcome to " + Constant.GAME_NAME + "!");
			
			// Init Classes
			JSONManager.init();
			stage.stageFocusRect = false;
			stage.scaleMode = StageScaleMode.NO_SCALE; 
			stage.align = StageAlign.TOP_LEFT; 
			
			core = new EngineCore();
			core.ui = new UI();
			CONFIG::debug { stage.addEventListener(KeyboardEvent.KEY_DOWN, core.ui.e_debugKeyDown); }
			addChildAt(core.ui, 0);
			
			// Load User
			core.user = new User(true, true);
			
			// Jump to Game Loader
			core.scene = new SceneGameLoader(core);
			
			stage.addEventListener(Event.RESIZE, core.e_stageResize);
		}
		
	}

}