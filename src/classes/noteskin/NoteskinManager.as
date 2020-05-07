package classes.noteskin
{
	import classes.noteskin.EmbedNoteskinBase;
	import classes.noteskin.noteskin1.EmbedNoteskin1;
	import classes.noteskin.noteskin2.EmbedNoteskin2;
	import classes.noteskin.noteskin3.EmbedNoteskin3;
	import classes.noteskin.noteskin4.EmbedNoteskin4;
	import classes.noteskin.noteskin5.EmbedNoteskin5;
	import classes.noteskin.noteskin6.EmbedNoteskin6;
	import classes.noteskin.noteskin7.EmbedNoteskin7;

    public class NoteskinManager
    {
        public static var NOTESKINS:Vector.<EmbedNoteskinBase>;

        public static function init():void
        {
            NOTESKINS = new Vector.<EmbedNoteskinBase>();

            // Load Embedded Noteskin images.
            var loadList:Vector.<EmbedNoteskinBase> = new Vector.<EmbedNoteskinBase>();
            loadList.push(new EmbedNoteskin1());
            loadList.push(new EmbedNoteskin2());
            loadList.push(new EmbedNoteskin3());
            loadList.push(new EmbedNoteskin4());
            loadList.push(new EmbedNoteskin5());
            loadList.push(new EmbedNoteskin6());
            loadList.push(new EmbedNoteskin7());

            for each(var NOTESKIN:EmbedNoteskinBase in loadList)
            {
                NOTESKIN.init();

                if(NOTESKIN.valid)
                    NOTESKINS.push(NOTESKIN);
            }

            Logger.log("NoteskinManager", Logger.INFO, "Loaded " + NOTESKINS.length + " noteskin configs.");
        }
    }
}