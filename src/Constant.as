package
{
	import flash.display.Loader;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class Constant
	{
		//- Game Sessions
		public static var GAME_SESSION:String = "0";
		
		//- URLs
		public static const SITE_DATA_URL:String = "http://www.flashflashrevolution.com/game/r3/r3-siteData.php";
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
		public static const PLAYLIST_URL:String = "http://www.flashflashrevolution.com/game/r3/r3-playlist.php";
		public static const LANGUAGE_URL:String = "http://www.flashflashrevolution.com/game/r3/r3-language.php";
		public static const LANGUAGE_FONT_URL:String = "http://www.flashflashrevolution.com/game/r3/R^3Font.swf";
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
		public static const VERSION:int = 2;
		public static const GAME_ENGINE:String = "ffr";
		public static const GAME_NAME:String = "FlashFlashRevolution";
		
		//- Formats
		public static const TEXT_FORMAT:TextFormat = new TextFormat("Segoe UI", 14, 0xFFFFFF, true);
		public static const TEXT_FORMAT_CENTER:TextFormat = new TextFormat("Segoe UI", 14, 0xFFFFFF, true, null, null, null, null, TextFormatAlign.CENTER);
	
		//- Functions
	}
}