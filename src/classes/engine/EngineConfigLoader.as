package classes.engine
{
	import com.flashfla.net.WebRequest;
	import flash.events.Event;
	import com.flashfla.utils.StringUtil;

	public class EngineConfigLoader
	{
		public var core:EngineCore;

		private var requestParams:Object;
		
		public var config_url:String;
		public var id:String;
		public var name:String;
		private var _short_name:String;

		public var domain:String;

		public var user_login_url:String;
		public var user_info_url:String;
		public var user_ranks_url:String;

		public var playlist_url:String;
		public var site_info_url:String;
		public var language_url:String;

		public var song_play_url:String;
		public var song_preview_url:String;
		public var song_default_format:String = "SWF";

		public var isCanon:Boolean = false;

		public function get short_name():String
		{
			return _short_name != null && _short_name != "" ? _short_name : name;
		}
		
		public function set short_name(value:String):void
		{
			_short_name = value;
		}
		
		public function EngineConfigLoader(core:EngineCore, id:String = null):void
		{
			this.core = core;

			if(id)
				this.id = id;
		}

		public function loadFromConfig(url:String, params:Object = null):void
		{
			if (url != "")
			{
				config_url = url;
				requestParams = params;
				var wr:WebRequest = new WebRequest(prepareURL(url), e_configLoad, e_configError);
				wr.load(requestParams);
				Logger.log(this, Logger.INFO, "Loading Engine Config: " + url);
			}
		
		}
		
		private function e_configError(e:Event):void 
		{
			Logger.log(this, Logger.ERROR, "Loading Engine Config Error: " + config_url);
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
					if (node.id == undefined)
						continue;
					
					if (node.playlistURL == undefined)
						return;
					
					// Load Data
					if (this.id == null && node.id != undefined)
						this.id = node.id.toString() + "-external";

					if (node.name != undefined)
						this.name = node.name.toString();

					if (node.shortName != undefined)
						this.short_name = node.shortName.toString();

					if (node.domain != undefined)
						this.domain = node.domain.toString();

					if (node.playlistURL != undefined)
						this.playlist_url = cleanURL(node.playlistURL.toString());

					if (node.infoURL != undefined)
						this.site_info_url = cleanURL(node.infoURL.toString());

					if (node.languageURL != undefined)
						this.language_url = cleanURL(node.languageURL.toString());

					if (node.songURL != undefined)
						this.song_play_url = cleanURL(node.songURL.toString());

					if (node.previewURL != undefined)
						this.song_preview_url = cleanURL(node.previewURL.toString());

					if (node.loginURL != undefined)
						this.user_login_url = cleanURL(node.loginURL.toString());

					if (node.userURL != undefined)
						this.user_info_url = cleanURL(node.userURL.toString());

					if (node.userRankURL != undefined)
						this.user_ranks_url = cleanURL(node.userRankURL.toString());
					
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

					createEngineLoader();

					break;
				}
			}
			
			// Data is JSON - R^3 Type
			if (data.charAt(0) == "{" || data.charAt(0) == "[")
			{
				try
				{
					var json:Object = JSON.parse(data);
				}
				catch (e:Error)
				{
					Logger.log(this, Logger.ERROR, "Malformed JSON Config.");
					return;
				}

				// Load Data
				if (this.id == null && json.id != null)
					this.id = json.id + "-external";
				
				if (json.name != null)
					this.name = json.name;

				if (json.short_name != null)
					this.short_name = json.short_name;

				if (json.domain != null)
					this.domain = json.domain;

				if (json.playlistURL != null)
					this.playlist_url = cleanURL(json.playlistURL);

				if (json.siteinfoURL != null)
					this.site_info_url = cleanURL(json.siteinfoURL);

				if (json.languageURL != null)
					this.language_url = cleanURL(json.languageURL);

				if (json.songURL != null)
					this.song_play_url = cleanURL(json.songURL);

				if (json.previewURL != null)
					this.song_preview_url = cleanURL(json.previewURL);

				if (json.loginURL != null)
					this.user_login_url = cleanURL(json.loginURL);

				if (json.userURL != null)
					this.user_info_url = cleanURL(json.userURL);

				if (json.userRankURL != null)
					this.user_ranks_url = cleanURL(json.userRankURL);
				
				Logger.log(this, Logger.INFO, "Loaded JSON \"" + id + "\" Name: " + this.name);
				createEngineLoader();
			}
		}

		private function createEngineLoader():void
		{
			core.registerLoader(new EngineLoader(this));
		}

		///- Private
		private function prepareURL(url:String):String
		{
			return url + (url.indexOf("?") != -1 ? "&d=" : "?d=") + new Date().getTime();
		}

		private function cleanURL(url:String):String
		{
			var str:String = StringUtil.trim(url);
			if(str.length > 0)
				return str;

			return null;
		}
	}
}