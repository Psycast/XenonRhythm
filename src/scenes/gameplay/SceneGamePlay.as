package scenes.gameplay
{
	import classes.Song;
	import classes.engine.EngineCore;
	import classes.engine.EngineSettings;
	import classes.ui.UIAnchor;
	import classes.ui.UICore;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import scenes.gameplay.ui.components.UIComboValue;
	import scenes.gameplay.ui.components.UIPAWindow;
	import scenes.gameplay.ui.components.UIPlayComponent;
	import scenes.gameplay.ui.components.UIStaticText;
	
	public class SceneGamePlay extends UICore
	{
		private var song:Song;
		private var settings:EngineSettings;
		private var score:ScoreValue;
		
		private var dragTarget:UIPlayComponent;
		
		private var ui_components:Array;
		
		public function SceneGamePlay(core:EngineCore)
		{
			super(core);
		}
	
		override public function init():void 
		{
			settings = new EngineSettings();// core.user.settings;
			
			if (core.variables.song_queue.length > 0) 
			{
				song = core.song_loader.getSong(core.variables.song_queue[0]);
				
				// Set Song Variables
				song.playback_speed = settings.playback_speed;
			}
			
			// Game Variables
			score = new ScoreValue();
			
			super.init();
		}
		
		override public function onStage():void 
		{
			this.addEventListener(Event.ENTER_FRAME, e_onEnterFrame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, e_onKeyDown);
			
			//song.start();
			
			createUI();
			
			position();
			draw();
		}
		
		private function e_onKeyDown(e:KeyboardEvent):void 
		{
			score.amazing = int(Math.random() * 25000);
			score.perfect = int(score.amazing / 2);
			score.good = int(score.perfect / 2);
			score.average = int(score.good / 2);
			score.miss = int(score.average / 2);
			score.boo = int(score.miss / 2);
			score.combo = int(Math.random() * 25000);
			if (e.keyCode == Keyboard.BACKSPACE)
			{
				for each (var item:UIPlayComponent in ui_components) 
				{
					item.editorMode = !item.editorMode;
					if (item.editorMode)
					{
						item.addEventListener(MouseEvent.MOUSE_DOWN, e_mouseDown);
					}
					else
					{
						item.removeEventListener(MouseEvent.MOUSE_DOWN, e_mouseDown);
					}
				}
			}
			
			if (e.keyCode == core.user.settings.key_down)
			{
				
			}
			else if (e.keyCode == core.user.settings.key_up)
			{
				
			}
			else if (e.keyCode == core.user.settings.key_left)
			{
				
			}
			else if (e.keyCode == core.user.settings.key_right)
			{
				song.start();
			}
		}
		
		private function e_mouseDown(e:MouseEvent):void 
		{
			
			stage.addEventListener(MouseEvent.MOUSE_UP, e_mouseUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, e_mouseMove);
			
			(dragTarget = (e.target as UIPlayComponent)).startDrag(false, new Rectangle(0, 0, Constant.GAME_WIDTH, Constant.GAME_HEIGHT));
		}
		
		private function e_mouseMove(e:MouseEvent):void 
		{
			if (dragTarget)
			{
				
			}
		}
		
		private function e_mouseUp(e:MouseEvent):void 
		{
			if (dragTarget)
			{
				dragTarget.removeEventListener(MouseEvent.MOUSE_UP, e_mouseUp);
				dragTarget.stopDrag();
				dragTarget = null;
			}
		}
		
		private function createUI():void 
		{
			ui_components = [];
			
			var uicomp:UIPlayComponent;
			
			for each (var anc:int in UIAnchor.ALIGNMENTS_A) 
			{
				uicomp = new UIStaticText(this, "combo");
				uicomp.anchor = anc;
				uicomp.alignment = anc;
				ui_components.push(uicomp);
				
				uicomp = new UIComboValue(this, core, score);
				uicomp.anchor = anc;
				uicomp.alignment = anc;
				ui_components.push(uicomp);
				
				uicomp = new UIPAWindow(this, core, score, settings);
				uicomp.anchor = anc;
				uicomp.alignment = anc;
				ui_components.push(uicomp);
			}
		}
		
		private function e_onEnterFrame(e:Event):void 
		{
			for each (var item:UIPlayComponent in ui_components) 
			{
				item.update();
			}
		}
	}

}