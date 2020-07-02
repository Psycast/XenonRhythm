package classes.engine
{
	import com.flashfla.utils.StringUtil;
	import com.flashfla.net.WebRequest;
	import com.flashfla.utils.ArrayUtil;
	import flash.events.Event;
	
	public class EngineLoader
	{
		private var core:EngineCore;
		
		public var config:EngineConfigLoader;
		public var playlist:EnginePlaylist;
		public var info:EngineSiteInfo;
		public var language:EngineLanguage;

		public var id:String;
		
		private var init:Boolean = false;
		
		public var isCanon:Boolean = false;
		public var isLoading:Boolean = false;
		
		public function EngineLoader(config:EngineConfigLoader)
		{
			this.config = config;
			this.core = config.core
			this.id = config.id;
			this.isCanon = config.isCanon;
		}
		
		/** Contains [name, short_name, id]  */
		public function get infoArray():Array
		{
			return [config.name, config.short_name, config.id];
		}
		
		///- Get Loaded Status
		public function get loaded():Boolean
		{
			var load:Boolean = init;
			
			// A Engine source requires a playlist to be valid.
			if (config.playlist_url == null)
				load = false;
			
			// Check Sources
			if (config.playlist_url != null && playlist != null && !playlist.valid)
				load = false;

			if (config.site_info_url != null && info != null && !info.valid)
				load = false;

			if (config.language_url != null && language != null && !language.valid)
				load = false;
			
			return load;
		}
		
		///- Loader
		public function load(params:Object = null):void
		{
			if(!isLoading)
			{
				Logger.log(this, Logger.INFO, "Starting Loaders for \"" + id + "\"");
				loadPlaylist(params);
				loadInfo(params);
				loadLanguage(params);
				isLoading = true;
			}
		}

		//- Playlist
		public function loadPlaylist(params:Object = null):void
		{
			if (config.playlist_url != null)
			{
				var wr:WebRequest = new WebRequest(config.playlist_url, e_playlistLoad);
				wr.load(params);
				Logger.log(this, Logger.INFO, "Loading \"" + id + "\" Playlist: " + config.playlist_url);
			}
		}
		
		private function e_playlistLoad(e:Event):void
		{
			Logger.log(this, Logger.INFO, "\"" + id + "\" Playlist Loaded!");
			playlist = new EnginePlaylist(id);
			playlist.parseData(e.target.data);
			playlist.setLoadPath(config.song_play_url);
			playlist.setPreviewPath(config.song_preview_url != null ? config.song_preview_url : config.song_play_url);
			playlist.isCanon = this.isCanon;
			
			if (!playlist.valid)
			{
				playlist = null;
				config.playlist_url = null;
			}
			_doLoadCompleteInit();
		}
		
		//- Info
		public function loadInfo(params:Object = null):void
		{
			if (config.site_info_url)
			{
				var wr:WebRequest = new WebRequest(config.site_info_url, e_dataLoad);
				wr.load(params);
				Logger.log(this, Logger.INFO, "Loading \"" + id + "\" SiteInfo: " + config.site_info_url);
			}
		}
		
		private function e_dataLoad(e:Event):void
		{
			Logger.log(this, Logger.INFO, "\"" + id + "\" SiteInfo Loaded!");
			info = new EngineSiteInfo(id);
			info.parseData(e.target.data);
			
			if (!info.valid)
			{
				info = null;
				config.site_info_url = null;
			}
			_doLoadCompleteInit();
		}
		
		//- Language
		public function loadLanguage(params:Object = null):void
		{
			if (config.language_url != null)
			{
				var wr:WebRequest = new WebRequest(config.language_url, e_languageLoad);
				wr.load(params);
				Logger.log(this, Logger.INFO, "Loading \"" + id + "\" Language: " + config.language_url);
			}
		}
		
		private function e_languageLoad(e:Event):void
		{
			Logger.log(this, Logger.INFO, "\"" + id + "\" Language Loaded!");
			language = new EngineLanguage(id);
			language.parseData(e.target.data);
			
			if (!language.valid)
			{
				language = null;
				config.language_url = null;
			}
			_doLoadCompleteInit();
		}
		
		private function _doLoadCompleteInit():void
		{
			// Load Checks, check if things are loaded and playlist exist.
			if(config.playlist_url != null && (playlist == null || !playlist.valid))
				return;
			if(config.site_info_url != null && (info == null || !info.valid))
				return;
			if(config.language_url != null && (language == null || !language.valid))
				return;
				
			// Check Playlist is Valid and contains atleast one song.
			if (playlist == null || !playlist.valid || playlist.index_list.length <= 0)
			{
				Logger.log(this, Logger.ERROR, "\"" + id + "\" - Load Init Failure - Playlist Invalid");
				core.removeLoader(this);
				
				return;
			}
			
			// Playlist
			playlist.total_songs = playlist.total_public_songs = playlist.index_list.length;
			playlist.total_genres = ArrayUtil.count(playlist.genre_list);
			
			if (info != null)
			{
				// Excluded Genres from Public count
				var nonpublic_genres:Array = info.getData("game_nonpublic_genres");
				if (nonpublic_genres != null)
				{
					playlist.total_public_songs = playlist.index_list.filter(function(item:*, index:int, array:Array):Boolean
					{
						return !ArrayUtil.in_array([item.genre], nonpublic_genres)
					}).length;
				}
			}
			
			// Site
			
			// Language
			
			// Finished
			Logger.log(this, Logger.NOTICE, "Load Init: " + config.name + " (" + (playlist ? "P" : "-") + (info ? "I" : "-") + (language ? "L" : "-") + ")");
			Logger.log(this, Logger.NOTICE, "Total Songs: " + playlist.total_songs);
			Logger.log(this, Logger.NOTICE, "Total Public Songs: " + playlist.total_public_songs);
			Logger.log(this, Logger.NOTICE, "Total Genres: " + playlist.total_genres);
			init = true;
			core.loaderInitialized(this);
		}
	}
}