package scenes.gameplay
{
	import classes.Song;
	import classes.engine.EngineCore;
	import classes.engine.EngineSettings;
	import classes.ui.UICore;
	
	public class SceneGamePlay extends UICore
	{
		
		private var song:Song;
		private var settings:EngineSettings;
		
		public function SceneGamePlay(core:EngineCore)
		{
			super(core);
		
		}
	
		override public function init():void 
		{
			song = core.song_loader.getSong(core.variables.song_queue.shift());
			settings = core.user.settings;
			
			song.playbackSpeed = settings.playback_speed;
			
			super.init();
		}
		
		override public function onStage():void 
		{
			position();
			draw();
		}
	}

}