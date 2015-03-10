package
{
	import classes.engine.EngineCore;
	import classes.UICore;
	import flash.display.Sprite;
	
	public class UI extends Sprite
	{
		// Active Scene
		private var _scene:UICore;
		
		public function UI()
		{
			super();
		}
		
		// Game Scene
		public function get scene():UICore
		{
			return _scene;
		}
		
		public function set scene(new_scene:UICore):void
		{
			trace("2:------------------------------------------------------------------------------------------------");
			trace("2:[UI] Scene Change:", new_scene.class_name);
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
	}

}