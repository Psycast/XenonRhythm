package scenes.songselection 
{
	import assets.sGameBackground;
	import classes.engine.EngineCore;
	import classes.ui.Label;
	import classes.ui.UICore;

	public class SelectionSongs extends UICore 
	{
		private var icons:Array = ["ArrowCount", "Artist", "BPM", "Difficulty", "Genre", "ID", "Name", "NPS", "Rank", "Score", "Stats", "StepArtist", "Time"];
		public function SelectionSongs(core:EngineCore)
		{
			super(core);
		}
		
		override public function onStage():void
		{
			draw();
		}
		
		override public function draw():void
		{
			var bg:sGameBackground = new sGameBackground();
			addChildAt(bg, 0);
			
			for (var i:int = 0; i < icons.length; i++) 
			{
				new FilterIcon(this, 5, i * 30 + 5, icons[i]);
				new Label(this, 35, i * 30 + 5, icons[i]);
			}
		}
	}

}