package classes.engine
{
	import classes.ui.ResizeListener;
	import classes.ui.UICore;
	import classes.user.User;
	import com.flashfla.utils.ObjectUtil;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class EngineCore extends EventDispatcher
	{
		//
		static public const LOADERS_UPDATE:String = "loadersUpdate";
		
		// Engine Source
		private var _source:String;
		
		// Engine Loaders
		private var _loaders:Object = { };
		private var _loaderCount:uint = 0;
		
		// Indexed List of Components
		private var _playlists:Object = {};
		private var _info:Object = {};
		private var _languages:Object = {};
		
		// Active User
		public var user:User;
		
		// Active UI
		public var ui:UI;
		
		// Engine Flags
		public var flags:Array = [];
		
		/** Engine Variables */
		public var variables:EngineVariables;
		public var song_loader:EngineLevelLoader;
		
		public function EngineCore()
		{
			this._source = Constant.GAME_ENGINE;
			variables = new EngineVariables();
			song_loader = new EngineLevelLoader(this);
		}
		
		///- Engine Content Source
		// Set Engine Source for Content.
		public function set source(gameEngine:String):void
		{
			if (_loaders[gameEngine] != null)
			{
				_source = gameEngine;
				Logger.log(this, Logger.INFO, "Changed Default Engine: " + gameEngine);
			}
		}
		
		/** Gets the current engines source. */
		public function get source():String
		{
			return _source;
		}
		
		///- Engine Loader
		public function get loaderCount():uint
		{
			return _loaderCount;
		}
		
		// Get Active Engine Loader.
		public function getCurrentLoader():EngineLoader
		{
			if (_loaders[_source] != null)
			{
				return _loaders[_source];
			}
			return _loaders[Constant.GAME_ENGINE];
		}
		
		public function get canonLoader():EngineLoader
		{
			return _loaders[Constant.GAME_ENGINE]
		}
		
		public function registerLoader(loader:EngineLoader):void
		{
			_loaders[loader.id] = loader;
			_loaderCount = ObjectUtil.count(_loaders);
			Logger.log(this, Logger.INFO, "Registered EngineLoader: " + loader.id);
		}
		
		public function removeLoader(loader:EngineLoader):void
		{
			// Remove Playlist, Info and Language First
			removePlaylist(loader.playlist);
			removeInfo(loader.info);
			removeLanguage(loader.language);
			
			// Remove Loader itself.
			delete _loaders[loader.id];
			
			// Reset Source if active source was removed.
			if (source == loader.id)
			{
				source = Constant.GAME_ENGINE;
			}
			
			_loaderCount = ObjectUtil.count(_loaders);
			
			if(loader.loaded)
				dispatchEvent(new Event(LOADERS_UPDATE));
				
			Logger.log(this, Logger.INFO, "Removed EngineLoader: " + loader.id);
		}
		
		public function loaderInitialized(loader:EngineLoader):void
		{
			dispatchEvent(new Event(LOADERS_UPDATE));
		}
		
		public function get engineLoaders():Object
		{
			return _loaders;
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
		
		public function removePlaylist(engine:EnginePlaylist):void
		{
			if (engine && _playlists[engine.id] != null)
			{
				Logger.log(this, Logger.INFO, "Removed Playlist: " + engine.id);
				delete _playlists[engine.id];
			}
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
		
		public function removeInfo(info:EngineSiteInfo):void
		{
			if (info && _info[info.id])
			{
				Logger.log(this, Logger.INFO, "Removed SiteInfo: " + info.id);
				delete _info[info.id];
			}
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
		
		public function removeLanguage(language:EngineLanguage):void
		{
			if (language && _languages[language.id])
			{
				Logger.log(this, Logger.INFO, "Removed Language: " + language.id);
				delete _languages[language.id];
			}
		}
		
		public function getString(id:String, lang:String = "us"):String
		{
			return getStringSource(source, id, lang);
		}
		
		public function getStringSource(engineSource:String, id:String, lang:String = "us"):String
		{
			var out:String;
			var el:EngineLanguage;
			
			// Get Text for Source Language, Fall back to FFR.
			for each (var eid:String in[engineSource, Constant.GAME_ENGINE])
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
			ResizeListener.clear();
			ui.scene = scene;
		}
		
		public function addOverlay(overlay:DisplayObject):void
		{
			ui.addOverlay(overlay);
		}
		
		public function e_stageResize(e:Event):void
		{
			ui.updateStageResize();
		}
	}
}