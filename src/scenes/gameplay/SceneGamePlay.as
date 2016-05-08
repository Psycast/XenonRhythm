package scenes.gameplay
{
	import classes.engine.EngineCore;
	import classes.ui.UICore;
	
	public class SceneGamePlay extends UICore
	{
		
		public function SceneGamePlay(core:EngineCore)
		{
			super(core);
		
		}
	
		override public function onStage():void 
		{
			position();
			draw();
		}
	}

}