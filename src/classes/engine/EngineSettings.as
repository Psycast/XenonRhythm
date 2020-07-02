package classes.engine
{
	import flash.ui.Keyboard;
	import classes.engine.input.InputConfigGroup;
	import classes.engine.input.InputConfigManager;
	import classes.conversion.FFRFormat;
	
	/**
	 * Engine Settings
	 * Contains per user settings for the game.
	 */
	public class EngineSettings
	{
		///- Variables
		// Inputs
		public var menu_keys:InputConfigGroup;
		public var key_mappings:Vector.<InputConfigGroup>;

		//public function get keys():Array { return [key_left, key_down, key_up, key_right, key_restart, key_quit, key_options]; }
		
		// Speed
		public var scroll_direction:String = "down";
		public var scroll_speed:Number = 1.5;
		public var receptor_spacing:int = 80;
		public var screencut_position:Number = 0.5;
		public var playback_speed:Number = 1;
		
		// Judge
		public var offset_global:Number = 0;
		public var offset_judge:Number = 0;
		public var judge_colors:Array = [0x78ef29, 0x12e006, 0x01aa0f, 0xf99800, 0xfe0000, 0x804100];
		public var judge_window:Array = null;
		
		// Flags
		public var display_song_flags:Boolean = true;
		public var display_alt_engines:Boolean = true;
		
		// Other
		public var filters:Vector.<EngineLevelFilter> = new <EngineLevelFilter>[];

		public function EngineSettings():void
		{
			menu_keys = InputConfigManager.getConfig("global");
		}
		
		/**
		 * Setups Engine Settings for a passed object.
		 * @param	obj	Object containing new settings.
		 */
		public function setup(obj:Object, format:String = "ffr"):void
		{
			if(format == "ffr")
			{
				FFRFormat.parseSettings(this, obj);
			}
		}
		
		public function export(format:String = "ffr"):Object
		{
			if(format == "ffr")
			{
				return FFRFormat.exportSettings(this);
			}
			
			return {};
		}
	}
}