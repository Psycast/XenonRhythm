package classes.noteskin.noteskin4
{
	import classes.noteskin.NoteskinEntry;
	import flash.display.Bitmap;

	public class EmbedNoteskin4 extends NoteskinEntry
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
			return "ffr4";
		}
		
		override public function getName():String
		{
			return "SM Orbular";
		}
	}
}