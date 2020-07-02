package
{
	import classes.engine.EngineCore;
	import classes.engine.EngineLevel;
	import classes.engine.EngineRanks;
	import classes.engine.EngineRanksLevel;
	
	public class Constant
	{
		//- URLs
		public static const SITE_CONFIG_URL:String = "http://www.flashflashrevolution.com/game/r3/r3-gameConfig.php";
		
		//- Other
		public static const LOCAL_SO_NAME:String = "90579262-509d-4370-9c2e-564667e511d7";
		public static const VERSION:int = 3;
		public static const GAME_ENGINE:String = "ffr";
		public static const GAME_NAME:String = "Xenon Core";
		public static var GAME_WIDTH:int = 1280;
		public static var GAME_WIDTH_CENTER:int = GAME_WIDTH / 2;
		public static var GAME_HEIGHT:int = 720;
		public static var GAME_HEIGHT_CENTER:int = GAME_HEIGHT / 2;
	
		//- Functions
		public static function getSongIconIndex(song:EngineLevel, rank:EngineRanksLevel):int {
			var songIcon:int = 0;
			if (song && rank) {
				// No Note Count to test against
				if(song.notes == 0)
					return 1;

				// No Score
				if (rank.raw_score == 0)
					songIcon = 0;
				
				// No Score
				if (rank.raw_score > 0)
					songIcon = 1;
				
				// FC
				if (rank.amazing + rank.perfect + rank.good + rank.average == song.notes && rank.miss == 0 && rank.combo == song.notes)
					songIcon = 2;
				
				// SDG
				if (song.score_raw - rank.raw_score < 250)
					songIcon = 3;
				
				// BlackFlag
				if (rank.perfect == song.notes - 1 && rank.good == 1 && rank.average == 0 && rank.miss == 0 && rank.boo == 0 && rank.combo == song.notes)
					songIcon = 4;
				
				// AvgFlag
				if (rank.perfect == song.notes - 1 && rank.good == 0 && rank.average == 1 && rank.miss == 0 && rank.boo == 0 && rank.combo == song.notes)
					songIcon = 5;
				
				// MissFlag
				if (rank.perfect == song.notes - 1 && rank.good == 0 && rank.average == 0 && rank.miss == 1 && rank.boo == 0 && rank.combo == song.notes)
					songIcon = 6;
				
				// BooFlag
				if (rank.perfect == song.notes - 1 && rank.good == 0 && rank.average == 0 && rank.miss == 0 && rank.boo == 1 && rank.combo == song.notes)
					songIcon = 7;

				// OmniFlag
				if (rank.perfect == song.notes - 1 && rank.good == 1 && rank.average == 1 && rank.miss == 1 && rank.boo == 1 && rank.combo == song.notes)
					songIcon = 8;
				
				// AAA
				if (rank.raw_score == song.score_raw)
					songIcon = 9;
			}
			return songIcon;
		}
		
		public static const SONG_ICON_TEXT:Array = [
				"<font color=\"#C6C6C6\">UNPLAYED</font>", 
				"", 
				"<font color=\"#00FF00\">FC</font>",
				"<font color=\"#F2A254\">SDG</font>", 
				"<font color=\"#2C2C2C\">BLACKFLAG</font>",
				"<font color=\"#D19C60\">AVGFLAG</font>",
				"<font color=\"#7d0000\">MISSFLAG</font>",
				"<font color=\"#473218\">BOOFLAG</font>",
				"<font color=\"#b3f1ff\">OMNIFLAG</font>",
				"<font color=\"#FFFF38\">AAA</font>"
			];

		public static const SONG_ICON_COLOR:Array = [
				0xC6C6C6,
				0xC9C9C9, 
				0x00FF00,
				0xF2A254,
				0x2C2C2C,
				0xD19C60,
				0x7d0000,
				0x473218,
				0xb3f1ff,
				0xFFFF38
			];
		
		public static function getSongIcon(core:EngineCore, song:EngineLevel):int {
			return getSongIconIndex(song, getSongRank(core, song));
		}

		public static function getSongIconText(core:EngineCore, song:EngineLevel):String {
			return SONG_ICON_TEXT[getSongIcon(core, song)];
		}
		
		public static function getSongRank(core:EngineCore, song:EngineLevel):EngineRanksLevel 
		{
			var eng_ranks:EngineRanks = core.user.levelranks.getEngineRanks(song.source);
			if (eng_ranks)
			{
				return eng_ranks.getRank(song.id);
			}
			return null;
		}
	}
}