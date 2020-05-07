package classes.noteskin.noteskin5
{
    import classes.noteskin.EmbedNoteskinBase;
    import flash.display.Bitmap;

    public class EmbedNoteskin5 extends EmbedNoteskinBase
    {
        public static var NAME:String = "noteskin5";
        
        [Embed(source = "packed.json", mimeType='application/octet-stream')]
		private static const PACKED_JSON:Class;

        [Embed(source = "packed.png", mimeType='image/png')]
		private static const PACKED_BMP:Class;

        override public function init():void
        {
            processData(String(new PACKED_JSON()), (new PACKED_BMP() as Bitmap));
        }

        override public function getName():String
        {
            return "noteskin5";
        }
    }
}