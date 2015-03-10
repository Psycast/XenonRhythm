package scenes.loader 
{
	import assets.sGameBackground;
	import classes.engine.EngineCore;

	public class GameLoader_UI extends GameLoader 
	{
		
		public function GameLoader_UI(core:EngineCore) 
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