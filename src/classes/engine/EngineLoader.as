package classes.engine
{
	import com.adobe.serialization.json.JSONManager;
	import com.flashfla.utils.StringUtil;
	import com.flashfla.net.WebRequest;
	import com.flashfla.utils.ArrayUtil;
	import flash.events.Event;
	
	public class EngineLoader
	{
		private var _core:EngineCore;
		
		private var _playlist:EnginePlaylist;
		private var _info:EngineSiteInfo;
		private var _language:EngineLanguage;
		
		private var domain:String = "";
		private var song_url:String;
		
		private var _plURL:String = "";
		private var _inURL:String = "";
		private var _laURL:String = "";
		
		private var _isInit:Boolean = false;
		private var _plIsLoaded:Boolean = false;
		private var _inIsLoaded:Boolean = false;
		private var _laIsLoaded:Boolean = false;
		
		private var _requestParams:Object;
		
		public var isCanon:Boolean = false;
		public var isLegacy:Boolean = false;
		
		public var id:String = "";
		public var name:String = "";
		private var _short_name:String = "";
		
		public function EngineLoader(core:EngineCore, id:String = "", name:String = "")
		{
			this._core = core;
			this.id = id;
			this.name = name;
			
			if (id != "")
			{
				_core.registerLoader(this);
			}
		}
		
		public function get short_name():String
		{
			return _short_name != null && _short_name != "" ? _short_name : name;
		}
		
		public function set short_name(value:String):void
		{
			_short_name = value;
		}
		
		public function get infoArray():Array
		{
			return [name, short_name, id];
		}
		
		///- Get Loaded Status
		public function get loaded():Boolean
		{
			var load:Boolean = _isInit;
			
			// A Engine source requires a playlist to be valid.
			if (_plURL == "")
				load = false;
			
			// Check Sources
			if (_plURL != "" && !_plIsLoaded)
				load = false;
			if (_inURL != "" && !_inIsLoaded)
				load = false;
			if (_laURL != "" && !_laIsLoaded)
				load = false;
			
			return load;
		}
		
		public function get loaded_playlist():Boolean
		{
			return _plURL != "" ? _plIsLoaded : true;
		}
		
		public function get loaded_info():Boolean
		{
			return _inURL != "" ? _inIsLoaded : true;
		}
		
		public function get loaded_language():Boolean
		{
			return _laURL != "" ? _laIsLoaded : true;
		}
		
		///- Loader
		public function loadFromConfig(url:String, params:Object = null):void
		{
			if (url != "")
			{
				_requestParams = params;
				url = prepareURL(url);
				var wr:WebRequest = new WebRequest(url, e_configLoad);
				wr.load(_requestParams);
				Logger.log(this, Logger.INFO, "Loading Engine Config: " + url);
			}
		
		}
		
		private function e_configLoad(e:Event):void
		{
			var data:String = StringUtil.trim(e.target.data);
			
			// Data is XML - Legacy Type
			if (data.charAt(0) == "<")
			{
				// Create XML Tree
				try
				{
					var xml:XML = new XML(data);
				}
				catch (e:Error)
				{
					Logger.log(this, Logger.ERROR, "Malformed XML Config.");
					return;
				}
				
				// Check if FFR Engine XML
				if (xml.localName() != "ffr_engines" && xml.localName() != "arc_engines")
					return;
				
				for each (var node:XML in xml.children())
				{
					if (node.id == null)
						continue;
					
					if (node.playlistURL == null)
						return;
					
					if (this.id == "")
						this.id = node.id.toString() + "-external";
					this.name = node.name.toString();
					this.domain = node.domain.toString();
					this.song_url = node.songURL.toString();
					
					// Short Name
					if (node.shortName != null)
						this.short_name = node.shortName.toString();
					
					// Load Playlist
					loadPlaylist(node.playlistURL.toString(), _requestParams);
					
					// Load Site Info is existing.
					if (node.siteinfoURL != null)
						loadInfo(node.siteinfoURL.toString(), _requestParams);
					
					// Load Language is existing.
					if (node.languageURL != null)
						loadLanguage(node.languageURL.toString(), _requestParams);
					
					/*
					   engine.ignoreCache = Boolean(node.@ignoreCache.toString());
					   engine.legacySync = Boolean(node.@legacySync.toString());
					   if (engine.legacySync) {
					   engine.legacySyncLevel = int(node.@legacySyncLevel.toString());
					   engine.legacySyncLow = int(node.@legacySyncLow.toString());
					   engine.legacySyncHigh = int(node.@legacySyncHigh.toString());
					   setEngineSync(engine);
					   }
					   if (CONFIG::debug || node.@nocrossdomain != "true")
					   handler(engine);
					 */
					
					Logger.log(this, Logger.INFO, "Loaded XML \"" + id + "\" Name: " + this.name);
					_core.registerLoader(this);
					
					break;
				}
			}
			
			// Data is JSON - R^3 Type
			if (data.charAt(0) == "{" || data.charAt(0) == "[")
			{
				try
				{
					var json:Object = JSONManager.decode(data);
				}
				catch (e:Error)
				{
					Logger.log(this, Logger.ERROR, "Malformed JSON Config.");
					return;
				}
				if (this.id == "")
					this.id = json.id + "-external";
				this.name = json.name;
				this.short_name = json.short_name;
				this.domain = json.domain;
				this.song_url = json.songURL;
				
				// Load Playlist
				loadPlaylist(json.playlistURL, _requestParams);
				
				// Load Site Info is existing.
				if (json.siteinfoURL != null)
					loadInfo(json.siteinfoURL, _requestParams);
				
				// Load Language is existing.
				if (json.languageURL != null)
					loadLanguage(json.languageURL, _requestParams);
				
				Logger.log(this, Logger.INFO, "Loaded JSON \"" + id + "\" Name: " + this.name);
				_core.registerLoader(this);
			}
		}
		
		//- Playlist
		public function get playlist():EnginePlaylist
		{
			return _playlist;
		}
		
		public function loadPlaylist(url:String, params:Object = null):void
		{
			if (url != "")
			{
				_plURL = prepareURL(url);
				var wr:WebRequest = new WebRequest(_plURL, e_playlistLoad);
				wr.load(params);
				Logger.log(this, Logger.INFO, "Loading \"" + id + "\" Playlist: " + _plURL);
			}
		}
		
		private function e_playlistLoad(e:Event):void
		{
			Logger.log(this, Logger.INFO, "\"" + id + "\" Playlist Loaded!");
			_playlist = new EnginePlaylist(id);
			_playlist.parseData(e.target.data);
			_playlist.setLoadPath(this.song_url);
			
			// Register Playlist if Valid
			if (_playlist.valid)
			{
				_plIsLoaded = true;
				_core.registerPlaylist(_playlist);
			}
			else
			{
				_plURL = "";
				_plIsLoaded = false;
			}
			_doLoadCompleteInit();
		}
		
		//- Info
		public function get info():EngineSiteInfo
		{
			return _info;
		}
		
		public function loadInfo(url:String, params:Object = null):void
		{
			if (url != "")
			{
				_inURL = prepareURL(url);
				var wr:WebRequest = new WebRequest(_inURL, e_dataLoad);
				wr.load(params);
				Logger.log(this, Logger.INFO, "Loading \"" + id + "\" SiteInfo: " + _inURL);
			}
		}
		
		private function e_dataLoad(e:Event):void
		{
			Logger.log(this, Logger.INFO, "\"" + id + "\" SiteInfo Loaded!");
			_info = new EngineSiteInfo(id);
			_info.parseData(e.target.data);
			
			// Register SiteInfo if Valid
			if (_info.valid)
			{
				_inIsLoaded = true;
				_core.registerInfo(_info);
			}
			else
			{
				_inURL = "";
				_inIsLoaded = false;
			}
			_doLoadCompleteInit();
		}
		
		//- Language
		public function get language():EngineLanguage
		{
			return _language;
		}
		
		public function loadLanguage(url:String, params:Object = null):void
		{
			if (url != "")
			{
				_laURL = prepareURL(url);
				var wr:WebRequest = new WebRequest(_laURL, e_languageLoad);
				wr.load(params);
				Logger.log(this, Logger.INFO, "Loading \"" + id + "\" Language: " + _laURL);
			}
		}
		
		private function e_languageLoad(e:Event):void
		{
			Logger.log(this, Logger.INFO, "\"" + id + "\" Language Loaded!");
			_language = new EngineLanguage(id);
			_language.parseData(e.target.data);
			
			// Register Language if Valid
			if (_language.valid)
			{
				_laIsLoaded = true;
				_core.registerLanguage(_language);
			}
			else
			{
				_laURL = "";
				_laIsLoaded = false;
			}
			_doLoadCompleteInit();
		}
		
		private function _doLoadCompleteInit():void
		{
			// Language Only Load Check
			if (!loaded_info && loaded_language && !loaded_playlist)
			{
				_isInit = true;
				return;
			}
			
			// Load Checks, check if things are loaded and playlist exist.
			if (!loaded_info || !loaded_language || !loaded_playlist || !_playlist)
				return;
			
			// Playlist
			_playlist.total_songs = _playlist.total_public_songs = _playlist.index_list.length;
			_playlist.total_genres = ArrayUtil.count(_playlist.genre_list);
			
			if (_info != null)
			{
				// Excluded Genres from Public count
				var nonpublic_genres:Array = _info.getData("game_nonpublic_genres");
				if (nonpublic_genres != null)
				{
					_playlist.total_public_songs = _playlist.index_list.filter(function(item:*, index:int, array:Array):Boolean
					{
						return !ArrayUtil.in_array([item.genre], nonpublic_genres)
					}).length;
				}
			}
			
			// Site
			
			// Language
			
			// Finished
			Logger.log(this, Logger.NOTICE, "Load Init: " + name);
			Logger.log(this, Logger.NOTICE, "Total Songs: " + _playlist.total_songs);
			Logger.log(this, Logger.NOTICE, "Total Public Songs: " + _playlist.total_public_songs);
			Logger.log(this, Logger.NOTICE, "Total Genres: " + _playlist.total_genres);
			_isInit = true;
		}
		
		///- Private
		private function prepareURL(url:String):String
		{
			return url + (url.indexOf("?") != -1 ? "&d=" : "?d=") + new Date().getTime();
		}
	
	}

}