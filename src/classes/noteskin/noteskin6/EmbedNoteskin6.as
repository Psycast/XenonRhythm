package classes.noteskin.noteskin6
{
    import classes.noteskin.EmbedNoteskinBase;
    import flash.display.Bitmap;

    public class EmbedNoteskin6 extends EmbedNoteskinBase
    {
        public static var NAME:String = "noteskin6";
        
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
            return "noteskin6";
        }
    }
}