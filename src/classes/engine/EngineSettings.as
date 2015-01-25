package classes.engine {
	import flash.ui.Keyboard;
	
	public class EngineSettings 
	{
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
		public var display_songprogress:Boolean = true;
		
		public var display_mp_mask:Boolean = false;
		public var display_mp_timestamp:Boolean = false;
		
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
		
		// Setup function
		public function setup(obj:Object):void
		{
			
		}
	}

}