package
{
	import classes.ui.UICore;
	import classes.ui.UIStyle;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.ui.Keyboard;
	import scenes.SceneDebugLogger;
	
	public class UI extends Sprite
	{
		// Active Scene
		private var _scene:UICore;
		private var _debugscrene:UICore = new SceneDebugLogger(null);

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
			
			// Reset Stage Focus
			if (stage)
				stage.focus = null;
		}
		
		// Overlays
		public function addOverlay(overlay:DisplayObject):void
		{
			addChild(overlay);
		}
		
		public function blurInterface():void
		{
			scene.filters = [new BlurFilter(8, 8, 1)];
			scene.transform.colorTransform = new ColorTransform(0.5, 0.5, 0.5);
		}
		
		public function unblurInterface():void
		{
			scene.filters = [];
			scene.transform.colorTransform = new ColorTransform();
		}
		
		CONFIG::debug {
		public function e_debugKeyDown(e:KeyboardEvent):void 
		{
			// Debug Logger
			if (e.keyCode == Keyboard.F11)
			{
				UIStyle.USE_ANIMATION = !UIStyle.USE_ANIMATION;
			}
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