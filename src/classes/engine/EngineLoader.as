package classes.engine
{
	import classes.engine.EnginePlaylist;
	import com.adobe.serialization.json.JSONManager;
	import com.adobe.utils.StringUtil;
	import com.flashfla.net.WebRequest;
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
		
		private var _plIsLoaded:Boolean = false;
		private var _inIsLoaded:Boolean = false;
		private var _laIsLoaded:Boolean = false;
		
		private var _requestParams:Object;
		
		public var isCanon:Boolean = false;
		public var isLegacy:Boolean = false;
		
		public var id:String = "";
		public var name:String = "";
		
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
		
		///- Get Loades Status
		public function get loaded():Boolean
		{
			var load:Boolean = true;
			
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
		
		///- Loader
		public function loadFromConfig(url:String, params:Object = null):void
		{
			if (url != "")
			{
				_requestParams = params;
				url = prepareURL(url);
				var wr:WebRequest = new WebRequest(url, e_configLoad);
				wr.load(_requestParams);
				trace("0:[EngineLoader] Loading Engine Config:", url);
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
					trace("3:[EngineLoader] Malformed XML Config.");
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
					
					trace("0:[EngineLoader] Loaded XML \"" + id + "\" Name:", this.name);
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
					trace("3:[EngineLoader] Malformed JSON Config.");
					return;
				}
				if (this.id == "")
					this.id = json.id + "-external";
				this.name = json.name;
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
				
				trace("0:[EngineLoader] Loaded JSON \"" + id + "\" Name:", this.name);
				_core.registerLoader(this);
			}
		}
		
		//- Playlist
		public function loadPlaylist(url:String, params:Object = null):void
		{
			if (url != "")
			{
				_plURL = prepareURL(url);
				var wr:WebRequest = new WebRequest(_plURL, e_playlistLoad);
				wr.load(params);
				trace("0:[EngineLoader] Loading \"" + id + "\" Playlist:", _plURL);
			}
		}
		
		private function e_playlistLoad(e:Event):void
		{
			trace("0:[EngineLoader] \"" + id + "\" Playlist Loaded!");
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
		}
		
		//- Info
		public function loadInfo(url:String, params:Object = null):void
		{
			if (url != "")
			{
				_inURL = prepareURL(url);
				var wr:WebRequest = new WebRequest(_inURL, e_dataLoad);
				wr.load(params);
				trace("0:[EngineLoader] Loading \"" + id + "\" SiteInfo:", _inURL);
			}
		}
		
		private function e_dataLoad(e:Event):void
		{
			trace("0:[EngineLoader] \"" + id + "\" SiteInfo Loaded!");
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
		}
		
		//- Language
		public function loadLanguage(url:String, params:Object = null):void
		{
			if (url != "")
			{
				_laURL = prepareURL(url);
				var wr:WebRequest = new WebRequest(_laURL, e_languageLoad);
				wr.load(params);
				trace("0:[EngineLoader] Loading \"" + id + "\" Language:", _laURL);
			}
		}
		
		private function e_languageLoad(e:Event):void
		{
			trace("0:[EngineLoader] \"" + id + "\" Language Loaded!");
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
		}
		
		///- Private
		private function prepareURL(url:String):String
		{
			return url + (url.indexOf("?") != -1 ? "&d=" : "?d=") + new Date().getTime();
		}
	
	}

}