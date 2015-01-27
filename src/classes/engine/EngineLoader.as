package classes.engine
{
	import com.flashfla.net.WebRequest;
	import flash.events.Event;
	
	public class EngineLoader
	{
		private var _core:EngineCore;
		
		private var _playlist:EnginePlaylist;
		private var _info:EngineSiteInfo;
		private var _language:EngineLanguage;
		
		private var _plURL:String = "";
		private var _inURL:String = "";
		private var _laURL:String = "";
		
		private var _plIsLoaded:Boolean = false;
		private var _inIsLoaded:Boolean = false;
		private var _laIsLoaded:Boolean = false;
		
		public var isCanon:Boolean = false;
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
		public function loadFromXML(url:String):void
		{
			if (url != "")
			{
				url = prepareURL(url);
				var wr:WebRequest = new WebRequest(url, e_xmlLoad);
				wr.load();
				trace("0:[EngineLoader] Loading XML Playlist:", url);
			}
		
		}
		
		private function e_xmlLoad(e:Event):void
		{
			var xml:XML = new XML(e.target.data);
			
			// Check if FFR Engine XML
			if (xml.localName() != "ffr_engines" && xml.localName() != "arc_engines")
				return;
				
			for each (var node:XML in xml.children())
			{
				if (node.id == null)
					continue;
				
				if (node.playlistURL == null)
					return;
				
				this.id = node.id.toString();
				this.name = node.name.toString();
				
				// Load Playlist
				loadPlaylist(node.playlistURL.toString());
				
				// Load Site Info is existing.
				if (node.siteinfoURL != null)
					loadInfo(node.siteinfoURL.toString());
					
					
				// Load Language is existing.
				if (node.languageURL != null)
					loadLanguage(node.languageURL.toString());
				
				//this.domain = node.domain.toString();
				//engine.songURL = node.songURL.toString();
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