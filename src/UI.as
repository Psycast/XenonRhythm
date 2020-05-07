package
{
	import classes.ui.ResizeListener;
	import classes.ui.UICore;
	import classes.ui.UIStyle;

	import flash.display.DisplayObject;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.ui.Keyboard;

	import scenes.SceneDebugLogger;
	import flash.utils.getTimer;
	
	public class UI extends Sprite
	{
		private var _overlayParent:UICore = new UICore(null);
		
		// Delta Timer
		private var _deltaLastTick:Number = 0;
		private var _curTimer:Number = 0;
		private var _eclipsedTime:Number = 0;

		// Active Scene
		private var _scene:UICore;
		private var _overlays:int = 0;
		private var _debugScene:UICore = new SceneDebugLogger(null);
		private var _debugWindow:NativeWindow;

		public function onFrameEvent(e:Event):void
		{
			//e.stopImmediatePropagation();

			_curTimer = getTimer();
            _eclipsedTime = _curTimer - _deltaLastTick;

            _deltaLastTick = _curTimer;

			if(_scene)
				_scene.onTick(_deltaLastTick, _eclipsedTime);
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
				if(this.contains(_scene))
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
			if (stage && (!stage.focus || stage.focus.parent == null || stage.focus.stage == null))
				stage.focus = null;
		}
		
		public function get overlayParent():UICore 
		{
			return _overlayParent;
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
				if(scene)
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
		
		//CONFIG::debug {
		public function e_debugKeyDown(e:KeyboardEvent):void 
		{
			if (e.keyCode == Keyboard.F11)
			{
				UIStyle.USE_ANIMATION = !UIStyle.USE_ANIMATION;
			}
			if (e.keyCode == Keyboard.F12)
			{
				_openDebugLog();
			}
		}
		public function _openDebugLog():void
		{
			if(!NativeWindow.isSupported)
				return;

			if(_debugWindow != null && !_debugWindow.closed)
			{
				stage.nativeWindow.x += 400;
				_debugWindow.close();
				return;
			}

			_debugWindow = new NativeWindow(new NativeWindowInitOptions());
			_debugWindow.width = 800;
			_debugWindow.height = stage.nativeWindow.height;
			_debugWindow.title = "Xenon Debug Logger";
			_debugWindow.stage.align = StageAlign.TOP_LEFT;
			_debugWindow.stage.scaleMode = StageScaleMode.NO_SCALE;
			_debugWindow.stage.color = 0;
			_debugWindow.stage.addChild(_debugScene);
			_debugScene.onStage();
			stage.nativeWindow.x -= 400;
			_debugWindow.x = stage.nativeWindow.bounds.right;
			_debugWindow.y = stage.nativeWindow.y;
			_debugWindow.activate();
		}
		//}
	}

}