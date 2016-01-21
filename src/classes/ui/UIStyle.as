package classes.ui
{
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class UIStyle
	{
		//- Formats
		public static var FONT_SIZE:int = 14;
		public static var FONT_COLOR:uint = 0xFFFFFF;
		public static var ACTIVE_FONT_COLOR:String = "#93F0FF";
		public static var FONT_NAME:String = new SegoeUI().fontName;
		public static var FONT_NAME_U:String = new ArialUnicodeMS().fontName;
		public static var USE_ANIMATION:Boolean = false;
		
		public static var TEXT_FORMAT:TextFormat = new TextFormat(FONT_NAME, FONT_SIZE, FONT_COLOR, true);
		public static var TEXT_FORMAT_CENTER:TextFormat = new TextFormat(FONT_NAME, FONT_SIZE, FONT_COLOR, true, null, null, null, null, TextFormatAlign.CENTER);
		public static var TEXT_FORMAT_U:TextFormat = new TextFormat(FONT_NAME_U, FONT_SIZE, FONT_COLOR, true);
		public static var TEXT_FORMAT_U_CENTER:TextFormat = new TextFormat(FONT_NAME_U, FONT_SIZE, FONT_COLOR, true, null, null, null, null, TextFormatAlign.CENTER);
		
		public static function getTextFormat(unicode:Boolean = false):TextFormat
		{
			return unicode ? TEXT_FORMAT_U : TEXT_FORMAT;
		}
		
		public static function textIsUnicode(str:String):Boolean
		{
			return !((/^[\x20-\x7E]*$/).test(str));
		}
	}

}