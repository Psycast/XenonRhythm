package
{
	import classes.engine.EngineCore;
	import classes.ui.FormManager;
	import classes.ui.UIStyle;
	import classes.user.User;
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
			UIStyle.init();
			
			stage.stageFocusRect = false;
			stage.scaleMode = StageScaleMode.NO_SCALE; 
			stage.align = StageAlign.TOP_LEFT; 
			
			core = new EngineCore();
			core.ui = new UI();
			addChildAt(core.ui, 0);
			
			// Load User
			core.user = new User(true, true);
			
			// Jump to Game Loader
			core.scene = new SceneGameLoader(core);
			
			stage.addEventListener(Event.RESIZE, core.e_stageResize);
			core.ui.updateStageResize();
			
			CONFIG::debug { 
				stage.addEventListener(KeyboardEvent.KEY_DOWN, core.ui.e_debugKeyDown);
				//addChild(FormManager.debugFormViewerSprite());
				//stage.addEventListener(Event.ENTER_FRAME, e_formDebugUpdate);
			}
		}
		
		CONFIG::debug {
		public var debugUpdateTick:int = 0;
		private function e_formDebugUpdate(e:Event):void 
		{
			debugUpdateTick++;
			if(debugUpdateTick % 2 == 0) {
				FormManager.debugUpdate();
				debugUpdateTick = 0;
			}
		}
		}
	}

}