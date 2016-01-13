package classes.ui 
{
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	public class UIStyle 
	{
		//- Formats
		public static var fontSize:int = 14;
		public static var fontColor:uint = 0xFFFFFF;
		public static var activeFontColor:String = "#93F0FF";
		public static var fontName:String = new SegoeUI().fontName;
		public static var fontName_U:String = new ArialUnicodeMS().fontName;
		
		public static var TEXT_FORMAT:TextFormat = new TextFormat(fontName, fontSize, fontColor, true);
		public static var TEXT_FORMAT_CENTER:TextFormat = new TextFormat(fontName, fontSize, fontColor, true, null, null, null, null, TextFormatAlign.CENTER);
		public static var TEXT_FORMAT_U:TextFormat = new TextFormat(fontName_U, fontSize, fontColor, true);
		public static var TEXT_FORMAT_U_CENTER:TextFormat = new TextFormat(fontName_U, fontSize, fontColor, true, null, null, null, null, TextFormatAlign.CENTER);
		
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