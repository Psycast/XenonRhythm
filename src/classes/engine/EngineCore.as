package classes.engine
{
	import classes.user.User;
	
	public class EngineCore
	{
		private var _source:String;
		
		private var _loaders:Array = [];
		
		private var _playlists:Array = [];
		private var _info:Array = [];
		private var _languages:Array = [];
		
		public var user:User;
		
		public function EngineCore()
		{
			this.source = Constant.GAME_ENGINE;
		}
		
		///- Engine Content Source
		// Set Engine Source for Content.
		public function set source(gameEngine:String):void
		{
			_source = gameEngine;
		}
		
		public function get source():String
		{
			return _source;
		}
		
		///- Engine Loader
		// Get Active Engine Loader.
		public function getCurrentLoader():EngineLoader
		{
			if (_loaders[_source] != null)
			{
				return _loaders[_source];
			}
			return _loaders[Constant.GAME_ENGINE];
		}
		
		public function registerLoader(loader:EngineLoader):void
		{
			_loaders[loader.id] = loader;
			trace("0:[EngineCore] Registered EngineLoader:", loader.id);
		}
		
		///- Engine Playlist
		// Get Active Engine Playlist.
		public function getCurrentPlaylist():EnginePlaylist
		{
			if (_playlists[_source] != null)
			{
				return _playlists[_source];
			}
			return _playlists[Constant.GAME_ENGINE];
		}
		
		// Get Engine Playlist.
		public function getPlaylist(id:String):EnginePlaylist
		{
			return _playlists[id];
		}
		
		public function registerPlaylist(engine:EnginePlaylist):void
		{
			_playlists[engine.id] = engine;
			trace("0:[EngineCore] Registered Playlist:", engine.id);
		}
		
		///- Engine Info
		// Get Active Engine Language.
		public function getCurrentInfo():EngineSiteInfo
		{
			if (_info[_source] != null)
			{
				return _info[_source];
			}
			return _info[Constant.GAME_ENGINE];
		}
		
		// Get Engine Playlist.
		public function getInfo(id:String):EngineSiteInfo
		{
			return _info[id];
		}
		
		public function registerInfo(info:EngineSiteInfo):void
		{
			_info[info.id] = info;
			trace("0:[EngineCore] Registered SiteInfo:", info.id);
		}
		
		///- Engine Language
		// Get Active Engine Language.
		public function getCurrentLanguage():EngineLanguage
		{
			if (_languages[_source] != null)
			{
				return _languages[_source];
			}
			return _languages[Constant.GAME_ENGINE];
		}
		
		// Get Engine Playlist.
		public function getLanguage(id:String):EngineLanguage
		{
			return _languages[id];
		}
		
		public function registerLanguage(language:EngineLanguage):void
		{
			_languages[language.id] = language;
			trace("0:[EngineCore] Registered Language:", language.id);
		}
	}

}