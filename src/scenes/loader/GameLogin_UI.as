package scenes.loader 
{
	import assets.sGameBackground;
	import classes.engine.EngineCore;

	public class GameLogin_UI extends GameLogin 
	{
		
		public function GameLogin_UI(core:EngineCore) 
		{
			super(core);
			
		}
		
		override public function onStage():void
		{
			draw();
		}
		
		override public function draw():void
		{
			var bg:sGameBackground = new sGameBackground(class_name);
			addChild(bg);
		}
		
	}

}