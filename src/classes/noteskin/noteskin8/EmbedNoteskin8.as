package classes.noteskin.noteskin8
{
	import classes.noteskin.NoteskinEntry;
	import flash.display.Bitmap;

	public class EmbedNoteskin8 extends NoteskinEntry
	{
		[Embed(source = "packed.json", mimeType='application/octet-stream')]
		private static const PACKED_JSON:Class;

		[Embed(source = "packed.png", mimeType='image/png')]
		private static const PACKED_BMP:Class;

		override public function init():void
		{
			useNoteRotation = false;
			processData(String(new PACKED_JSON()), (new PACKED_BMP() as Bitmap));
		}

		override public function getID():String
		{
			return "ffr8";
		}
		
		override public function getName():String
		{
			return "Beatmania v2";
		}
	}
}