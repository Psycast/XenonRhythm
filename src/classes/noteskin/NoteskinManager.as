package classes.noteskin
{
	import classes.noteskin.NoteskinEntry;
	import classes.noteskin.noteskin1.EmbedNoteskin1;
	import classes.noteskin.noteskin2.EmbedNoteskin2;
	import classes.noteskin.noteskin3.EmbedNoteskin3;
	import classes.noteskin.noteskin4.EmbedNoteskin4;
	import classes.noteskin.noteskin5.EmbedNoteskin5;
	import classes.noteskin.noteskin6.EmbedNoteskin6;
	import classes.noteskin.noteskin7.EmbedNoteskin7;
	import classes.noteskin.noteskin8.EmbedNoteskin8;
	import classes.noteskin.noteskin9.EmbedNoteskin9;
	import classes.noteskin.noteskin10.EmbedNoteskin10;

	public class NoteskinManager
	{
		public static var NOTESKINS:Vector.<NoteskinEntry>;

		public static function init():void
		{
			NOTESKINS = new Vector.<NoteskinEntry>();

			// Load Embedded Noteskin images.
			var loadList:Vector.<NoteskinEntry> = new Vector.<NoteskinEntry>();
			loadList.push(new EmbedNoteskin1());
			loadList.push(new EmbedNoteskin2());
			loadList.push(new EmbedNoteskin3());
			loadList.push(new EmbedNoteskin4());
			loadList.push(new EmbedNoteskin5());
			loadList.push(new EmbedNoteskin6());
			loadList.push(new EmbedNoteskin7());
			loadList.push(new EmbedNoteskin8());
			loadList.push(new EmbedNoteskin9());
			loadList.push(new EmbedNoteskin10());

			for each(var NOTESKIN:NoteskinEntry in loadList)
			{
				registerConfig(NOTESKIN);
			}

			Logger.log("NoteskinManager", Logger.INFO, "Loaded " + NOTESKINS.length + " noteskin configs.");
		}

		public static function registerConfig(group:NoteskinEntry):void
		{
			group.init();

			//if(group.valid && getNoteskin(group.getID()) == null)
				NOTESKINS.push(group);
		}

		public static function getNoteskin(id:String):NoteskinEntry
		{
			if(NOTESKINS.length == 0)
				return null;

			for each(var entry:NoteskinEntry in NOTESKINS)
			{
				if(entry.getID() == id)
					return entry;
			}
			return NOTESKINS[0];
		}
	}
}