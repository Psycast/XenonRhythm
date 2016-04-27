package classes.ui
{
	import assets.sGameBackground;
	import classes.engine.EngineCore;
	import flash.display.Sprite;
	
	public class UICore extends Sprite
	{
		protected var core:EngineCore;
		public var INPUT_DISABLED:Boolean = false;
		
		public function UICore(core:EngineCore)
		{
			this.core = core;
		}
		
		/**
		 * Abstract init() function.
		 * Called by UI before placement on the stage.
		 */
		public function init():void
		{
		
		}
		
		/**
		 * Abstract destroy() function.
		 * Called by UI before removal from the stage.
		 */
		public function destroy():void
		{
		
		}
		
		/**
		 * Abstract destroy() function.
		 * Called by UI after placement on the stage.
		 */
		public function onStage():void
		{
			var bg:sGameBackground = new sGameBackground();
			addChildAt(bg, 0);
			
			position();
			draw();
		}
		
		/**
		 * Abstract onResize() function.
		 * Called by UI when the stage size changes.
		 */
		public function onResize():void
		{
			position();
		}
		
		/**
		 * Abstract draw() function.
		 */
		public function draw():void
		{
		
		}
		
		/**
		 * Abstract position() function.
		 */
		public function position():void
		{
			
		}
		
		/**
		 * Returns the constructor class name.
		 */
		public function get class_name():String
		{
			var t:String = (Object(this).constructor).toString();
			return t.substr(7, t.length - 8);
		}
	}
}