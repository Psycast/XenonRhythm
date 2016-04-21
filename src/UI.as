package
{
	import classes.ui.ResizeListener;
	import classes.ui.UICore;
	import classes.ui.UIStyle;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
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
		private var _overlays:int = 0;
		
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
			
			if (_overlays > 0)
				blurInterface();
				
			// Reset Stage Focus
			if (stage)
				stage.focus = null;
		}
		
		// Overlays
		public function addOverlay(overlay:DisplayObject):void
		{
			addChild(overlay);
			_overlays++;
			
			if (_overlays > 0)
				blurInterface();
		}
		
		public function removeOverlay(overlay:DisplayObject):void
		{
			removeChild(overlay);
			_overlays--;
			
			if (_overlays <= 0)
				unblurInterface();
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
		
		public function setStageSize(w:int, h:int, scale:String = null):void
		{
			var oS:String = stage.scaleMode;
			var oW:int = Constant.GAME_WIDTH;
			var oH:int = Constant.GAME_HEIGHT;
			
			Constant.GAME_WIDTH = w;
			Constant.GAME_HEIGHT = h;
			
			if (Constant.GAME_WIDTH < 800) Constant.GAME_WIDTH = 800;
			if (Constant.GAME_HEIGHT < 600) Constant.GAME_HEIGHT = 600;
			
			Constant.GAME_WIDTH_CENTER = Constant.GAME_WIDTH / 2;
			Constant.GAME_HEIGHT_CENTER = Constant.GAME_HEIGHT / 2;
			
			if (oW != Constant.GAME_WIDTH || oH != Constant.GAME_HEIGHT)
			{
				scene.onResize();
				ResizeListener.signal();
			}
			if (scale != null && oS != scale)
			{
				stage.scaleMode = scale;
			}
		}
		
		public function updateStageResize():void 
		{
			if (stage.scaleMode == StageScaleMode.NO_SCALE)
			{
				setStageSize(stage.stageWidth, stage.stageHeight);
			}
		}
		
		CONFIG::debug {
		public function e_debugKeyDown(e:KeyboardEvent):void 
		{
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