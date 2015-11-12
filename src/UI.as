package
{
	import classes.ui.UICore;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import scenes.DebugLogger;
	
	public class UI extends Sprite
	{
		// Active Scene
		private var _scene:UICore;
		private var _debugscrene:UICore = new DebugLogger(null);
		
		public function UI()
		{
			super();
			_debugscrene.init();
		}
		
		// Game Scene
		public function get scene():UICore
		{
			return _scene;
		}
		
		public function set scene(new_scene:UICore):void
		{
			Logger.divider(this);
			Logger.log(this, Logger.WARNING, "Scene Change: " + new_scene.class_name);
			// Remove Old
			if (_scene)
			{
				_scene.destroy();
				this.removeChild(_scene);
				_scene = null;
			}
			
			// Add to Stage
			_scene = new_scene;
			_scene.init();
			addChildAt(_scene, 0);
			_scene.onStage();
		}
		
		CONFIG::debug {
		public function e_debugKeyDown(e:KeyboardEvent):void 
		{
			// Debug Logger
			if (e.keyCode == Keyboard.F12)
			{
				if (contains(_debugscrene))
				{
					removeChild(_debugscrene);
				}
				else
				{
					addChild(_debugscrene);
					_debugscrene.onStage();
				}
			}
		}
		
		}
	}

}