package
{
	import classes.engine.EngineLevel;
	import classes.engine.EngineRanksLevel;
	
	public class Constant
	{
		//- URLs
		public static const SITE_CONFIG_URL:String = "http://www.flashflashrevolution.com/game/r3/r3-gameConfig.php";
		public static const SITE_LOGIN_URL:String = "http://www.flashflashrevolution.com/game/r3/r3-siteLogin.php";
		public static const SITE_REPLAY_URL:String = "http://www.flashflashrevolution.com/game/r3/r3-siteReplay.php";
		public static const USER_INFO_URL:String = "http://www.flashflashrevolution.com/game/r3/r3-userInfo.php";
		public static const USER_SMALL_INFO_URL:String = "http://www.flashflashrevolution.com/game/r3/r3-userSmallInfo.php";
		public static const USER_SETTINGS_URL:String = "http://www.flashflashrevolution.com/game/r3/r3-userSettings.php";
		public static const USER_FRIENDS_URL:String = "http://www.flashflashrevolution.com/game/r3/r3-userFriends.php";
		public static const USER_REPLAY_URL:String = "http://www.flashflashrevolution.com/game/r3/r3-userReplay.php";
		public static const USER_RANKS_URL:String = "http://www.flashflashrevolution.com/game/r3/r3-userRanks.php";
		public static const USER_AVATAR_URL:String = "http://www.flashflashrevolution.com/avatar_imgembedded.php";
		public static const HISCORES_URL:String = "http://www.flashflashrevolution.com/game/r3/r3-hiscores.php";
		public static const LANGUAGE_URL:String = "http://www.flashflashrevolution.com/game/r3/r3-language.php";
		public static const NOTESKIN_URL:String = "http://www.flashflashrevolution.com/game/r3/r3-noteSkins.xml";
		public static const NOTESKIN_SWF_URL:String = "http://www.flashflashrevolution.com/game/r3/noteskins/";
		public static const SONG_DATA_URL:String = "http://www.flashflashrevolution.com/game/r3/r3-songLoad.php";
		public static const SONG_START_URL:String = "http://www.flashflashrevolution.com/game/r3/r3-songStart.php";
		public static const SONG_SAVE_URL:String = "http://www.flashflashrevolution.com/game/r3/r3-songSave.php";
		public static const MULTIPLAYER_SUBMIT_URL:String = "http://www.flashflashrevolution.com/game/ffr-legacy_multiplayer.php";
		public static const MULTIPLAYER_SUBMIT_URL_VELOCITY:String = "http://www.flashflashrevolution.com/game/ffr-velocity_multiplayer.php";
		public static const LEVEL_STATS_URL:String = "http://www.flashflashrevolution.com/levelstats.php?level=";
		
		//- Other
		public static const LOCAL_SO_NAME:String = "90579262-509d-4370-9c2e-564667e511d7";
		public static const VERSION:int = 3;
		public static const GAME_ENGINE:String = "ffr";
		public static const GAME_NAME:String = "FlashFlashRevolution";
		public static var GAME_WIDTH:int = 800;
		public static var GAME_WIDTH_CENTER:int = GAME_WIDTH / 2;
		public static var GAME_HEIGHT:int = 600;
		public static var GAME_HEIGHT_CENTER:int = GAME_HEIGHT / 2;
	
		//- Functions
		public static function getSongIconIndex(song:EngineLevel, rank:EngineRanksLevel):int {
			var songIcon:int = 0;
			if (song && rank) {
				// No Score
				if (rank.score == 0)
					songIcon = 0;
				
				// No Score
				if (rank.score > 0)
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
				
				// BooFlag
				if (rank.perfect == song.notes - 1 && rank.good == 0 && rank.average == 0 && rank.miss == 0 && rank.boo == 1 && rank.combo == song.notes)
					songIcon = 5;
				
				// AAA
				if (rank.raw_score == song.score_raw)
					songIcon = 6;
			}
			return songIcon;
		}
		
		public static const SONG_ICON_TEXT:Array = ["<font color=\"#C6C6C6\">UNPLAYED</font>", "", "<font color=\"#00FF00\">FC</font>",
					"<font color=\"#f2a254\">SDG</font>", "<font color=\"#2C2C2C\">BLACKFLAG</font>",
					"<font color=\"#473218\">BOOFLAG</font>", "<font color=\"#FFFF38\">AAA</font>"];
					
		public static function getSongIcon(song:EngineLevel, rank:EngineRanksLevel):String {
			return SONG_ICON_TEXT[getSongIconIndex(song, rank)];
		}
	}
}