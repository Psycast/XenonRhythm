package classes.ui 
{
	import assets.sGameBackground;
	import classes.engine.EngineCore;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	public class UIOverlay extends UIComponent 
	{
		public var core:EngineCore;
		private var _INPUT_DISABLED:Boolean = false;
		
		public function UIOverlay(core:EngineCore, parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0) 
		{
			this.core = core;
			super(parent, xpos, ypos);
		}
		
		override protected function init():void 
		{
			super.init();
			setSize(Constant.GAME_WIDTH, Constant.GAME_HEIGHT);
			ResizeListener.addObject(this);
			
			// Stage Listener
			if (stage)
				onStage();
			else
				addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		/**
		 * Draws the visual ui of the component.
		 */
		override public function draw():void 
		{
			super.draw();
			
			this.graphics.clear();
			this.graphics.beginFill(UIStyle.BG_DARK, 0.90);
			this.graphics.drawRect(0, 0, width, height);
			this.graphics.endFill();
		}
		
		/**
		 * Stage resize and child positioning.
		 */
		override public function onResize():void 
		{
			_width = Constant.GAME_WIDTH
			_height = Constant.GAME_HEIGHT;
			
			super.onResize();
			
			this.graphics.clear();
			this.graphics.beginFill(UIStyle.BG_DARK, 0.90);
			this.graphics.drawRect(0, 0, width, height);
			this.graphics.endFill();
		}
		
		/**
		 * Abstract function to handle action based input.
		 * @param	action String: Action to preform.
		 * @param	index Number: Differs depending on the action. For actions left, right, up, down: Used as the index to determine the the next item to highlight. Where index 0 is the closest.
		 */
		public function doInputNavigation(action:String, index:Number = 0):void 
		{
			FormManager.handleAction(action, index);
		}
		
		/**
		 * Called when added to stage. Use to hookup stage listeners.
		 * @param	e
		 */
		public function onStage(e:Event = null):void 
		{
			if (e)
				removeEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		public function get INPUT_DISABLED():Boolean
		{
			return _INPUT_DISABLED;
		}
		
		public function set INPUT_DISABLED(val:Boolean):void
		{
			_INPUT_DISABLED = val;
		}
		
		
	}

}