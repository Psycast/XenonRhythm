package classes.engine
{
	import classes.ui.UICore;
	import classes.user.User;
	import classes.engine.EnginePlaylist;
	
	public class EngineCore
	{
		// Engine Source
		private var _source:String;
		
		// Engine Loaders
		private var _loaders:Object = {};
		
		// Indexed List of Components
		private var _playlists:Object = {};
		private var _info:Object = {};
		private var _languages:Object = {};
		
		// Active User
		public var user:User;
		
		// Active UI
		public var ui:UI;
		
		public var flags:Array = [];
		
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
			Logger.log(this, Logger.INFO, "Registered EngineLoader: " + loader.id);
		}
		
		public function removeLoader(loader:EngineLoader):void
		{
			delete _loaders[loader.id];
			Logger.log(this, Logger.INFO, "Removed EngineLoader: " + loader.id);
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
			Logger.log(this, Logger.INFO, "Registered Playlist: " + engine.id);
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
			Logger.log(this, Logger.INFO, "Registered SiteInfo: " + info.id);
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
		
		// Get Engine Language.
		public function getLanguage(id:String):EngineLanguage
		{
			return _languages[id];
		}
		
		public function registerLanguage(language:EngineLanguage):void
		{
			_languages[language.id] = language;
			Logger.log(this, Logger.INFO, "Registered Language: " + language.id);
		}
		
		public function getString(id:String, lang:String = "us"):String
		{
			var out:String;
			var el:EngineLanguage;
			
			// Get Text for Source Language, Fall back to FFR incase.
			for each (var eid:String in[source, Constant.GAME_ENGINE])
			{
				el = getLanguage(eid);
				if (el != null)
				{
					for each (var s:String in[lang, "us"])
					{
						if ((out = el.getString(id, lang)) != "")
						{
							return out;
						}
					}
				}
			}
			
			// No Text, Return ID
			return id;
		}
		
		// UI
		public function get scene():UICore
		{
			return ui.scene;
		}
		
		public function set scene(scene:UICore):void
		{
			ui.scene = scene;
		}
	}

}