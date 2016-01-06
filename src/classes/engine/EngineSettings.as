package classes.engine {
	import flash.ui.Keyboard;
	
	/**
	 * Engine Settings
	 * Contains per user settings for the game.
	 */
	public class EngineSettings 
	{
		///- Variables
		// Keys
		public var key_left:int = Keyboard.LEFT;
		public var key_down:int = Keyboard.DOWN;
		public var key_up:int = Keyboard.UP;
		public var key_right:int = Keyboard.RIGHT;
		public var key_restart:int = 191; // Keyboard.SLASH;
		public var key_quit:int = Keyboard.CONTROL;
		public var key_options:int = 145; // Scrolllock
		public function get keys():Array { return [key_left, key_down, key_up, key_right, key_restart, key_quit, key_options]; };
		
		// Speed
		public var scroll_direction:String = "up";
		public var scroll_speed:Number = 1.5;
		public var receptor_spacing:int = 80;
		public var screencut_position:Number = 0.5;
		
		// Judge
		public var offset_global:Number = 0;
		public var offset_judge:Number = 0;
		public var judge_colours:Array = [0x78ef29, 0x12e006, 0x01aa0f, 0xf99800, 0xfe0000, 0x804100];
		public var judge_window:Array = null;
		
		// Flags
		public var display_song_flags:Boolean = true;
		public var display_judge:Boolean = true;
		public var display_health:Boolean = true;
		public var display_combo:Boolean = true;
		public var display_pacount:Boolean = true;
		public var display_amazing:Boolean = true;
		public var display_perfect:Boolean = true;
		public var display_total:Boolean = true;
		public var display_screencut:Boolean = false;
		public var display_song_progress:Boolean = true;
		
		public var display_mp_mask:Boolean = false;
		public var display_mp_timestamp:Boolean = false;
		
		/**
		 * Setups Engine Settings for a passed object.
		 * @param	obj	Object containing new settings.
		 */
		public function setup(obj:Object):void
		{
			// Keys
			if (obj["keys"])
			{
				key_left 	= obj["keys"][0];
				key_down 	= obj["keys"][1];
				key_up 		= obj["keys"][2];
				key_right 	= obj["keys"][3];
				key_restart = obj["keys"][4];
				key_quit 	= obj["keys"][5];
				key_options = obj["keys"][6];
			}
			
			// Speed
			if (obj["direction"])			scroll_direction = obj["direction"];
			if (obj["speed"])				scroll_speed = obj["speed"];
			if (obj["gap"])					receptor_spacing = obj["gap"];
			if (obj["screencutPosition"])	screencut_position = obj["screencutPosition"];
			
			// Judge
			if (obj["judgeOffset"])			offset_judge = obj["judgeOffset"];
			if (obj["viewOffset"])			offset_global = obj["viewOffset"];
			if (obj["judgeColours"])		judge_colours = obj["judgeColours"];
			
			// Flags
			if(obj["viewSongFlag"])			display_song_flags = obj["viewSongFlag"];
			if(obj["viewJudge"])			display_judge = obj["viewJudge"];
			if(obj["viewHealth"])			display_health = obj["viewHealth"];
			if(obj["viewCombo"])			display_combo = obj["viewCombo"];
			if(obj["viewPACount"])			display_pacount = obj["viewPACount"];
			if(obj["viewAmazing"])			display_amazing = obj["viewAmazing"];
			if(obj["viewPerfect"])			display_perfect = obj["viewPerfect"];
			if(obj["viewTotal"])			display_total = obj["viewTotal"];
			if(obj["viewScreencut"])		display_screencut = obj["viewScreencut"];
			if(obj["viewSongProgress"])		display_song_progress = obj["viewSongProgress"];
			if(obj["viewMPMask"])			display_mp_mask = obj["viewMPMask"];
			if(obj["viewMPTimestamp"])		display_mp_timestamp = obj["viewMPTimestamp"];
		}
	}

}