package classes.ui
{
	import flash.geom.Matrix;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.Font;
	
	public class UIStyle
	{
		SegoeUI;
		SegoeUIBold;
		ArialUnicodeMS;
		Consolas;

		//- Formats
		public static var FONT_SIZE:int = 14;
		public static var FONT_COLOR:uint = 0xFFFFFF;
		public static var ACTIVE_FONT_COLOR:String = "#93F0FF";
		public static var FONT_NAME:String = new SegoeUI().fontName;
		public static var FONT_NAME_U:String = new ArialUnicodeMS().fontName;
		public static var FONT_NAME_C:String = new Consolas().fontName;
		public static var USE_ANIMATION:Boolean = false;
		
		public static var TEXT_FORMAT:TextFormat = new TextFormat(FONT_NAME, FONT_SIZE, FONT_COLOR, true);
		public static var TEXT_FORMAT_CENTER:TextFormat = new TextFormat(FONT_NAME, FONT_SIZE, FONT_COLOR, true, null, null, null, null, TextFormatAlign.CENTER);
		public static var TEXT_FORMAT_U:TextFormat = new TextFormat(FONT_NAME_U, FONT_SIZE, FONT_COLOR, true);
		public static var TEXT_FORMAT_U_CENTER:TextFormat = new TextFormat(FONT_NAME_U, FONT_SIZE, FONT_COLOR, true, null, null, null, null, TextFormatAlign.CENTER);

		public static var TEXT_FORMAT_CONSOLE:TextFormat = new TextFormat("Consolas", 12, "#FFFFFF", true);
		
		public static var BG_DARK:int = 0x033242;
		public static var BG_LIGHT:int = 0x1495BD;
		
		public static var GRADIENT_MATRIX:Matrix = new Matrix();
		
		public static function init():void
		{
			GRADIENT_MATRIX.createGradientBox(200, 200, (Math.PI / 180) * 225);
		}
		
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