package classes.ui
{
	import classes.engine.EngineCore;
	import flash.display.Sprite;
	
	public class UICore extends Sprite
	{
		protected var core:EngineCore;
		
		public function UICore(core:EngineCore)
		{
			this.core = core;
		}
		
		// Construct
		public function init():void
		{
			
		}
		
		// Deconstruct
		public function destroy():void
		{
		
		}
		
		// 
		public function onStage():void
		{
		
		}
		
		//
		public function draw():void
		{
		
		}
		
		public function get class_name():String
		{
			var t:String = (Object(this).constructor).toString();
			return t.substr(7, t.length - 8);
		}
	}
}