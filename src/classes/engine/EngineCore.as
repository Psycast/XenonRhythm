package classes.engine
{
	import be.aboutme.airserver.AIRServer;
	import be.aboutme.airserver.endpoints.socket.SocketEndPoint;
	import be.aboutme.airserver.endpoints.socket.handlers.websocket.WebSocketClientHandlerFactory;
	import be.aboutme.airserver.messages.Message;
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

		// HTTP Status Server
		private var server:AIRServer;
		private var server_message:Message = new Message();
		private var server_port:int = 21235;

		// Engine Source
		private var _source:String;
		
		// Engine Loaders
		private var loaders:Vector.<EngineLoader> = new <EngineLoader>[];
		private var loadersIndex:int = 0;
		
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

			// HTTP Status Server
			server = new AIRServer();
			server.addEndPoint(new SocketEndPoint(server_port, new WebSocketClientHandlerFactory()));
			server.start();
		}

		public function onProcessExit():void
		{
			if(server != null)
			{
				server.stop();
			}
		}
		
		/**
		 * Send a message using WebSockets to connected clients.
		 * @param cmd Command ID
		 * @param data Object with data.
		 */
		public function sendServerObject(cmd:String, data:Object):void
		{
			if(server != null)
			{
				server_message.command = cmd;
				server_message.data = data;
				server.sendMessageToAllClients(server_message);
			}
		}
		
		///- Engine Content Source
		// Set Engine Source for Content.
		public function set source(id:String):void
		{
			for(var i:int = loaders.length - 1; i >= 0; i--)
			{
				if(loaders[i].id == id)
				{
					loadersIndex = i;
					_source = id;
					Logger.log(this, Logger.INFO, "Changed Default Engine: " + id);
				}
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
			return loaders.length;
		}
		
		/**
		 * Gets the current active EngineLoader, or the main engine if missing.
		 * @return 
		 */
		public function getCurrentLoader():EngineLoader
		{
			if(loadersIndex > loaders.length || loadersIndex < 0)
				return null;

			return loaders[loadersIndex];
		}
		
		/**
		 * Gets the main engine only.
		 * @return 
		 */
		public function get canonLoader():EngineLoader
		{
			if(loaders.length <= 0)
				return null;

			for(var i:int = 0; i < loaders.length; i++)
				if(loaders[i].isCanon)
					return loaders[i];
			
			return null;
		}
		
		/**
		 * Registers the EngineLoader after it's been validated so it can be used.
		 * @param loader 
		 */
		public function registerLoader(loader:EngineLoader):void
		{
			// Canon Loader should always be first.
			if(loader.isCanon)
				loaders.unshift(loader);
			else
				loaders.push(loader);
				
			Logger.log(this, Logger.INFO, "Registered EngineLoader: " + loader.id);
		}
		
		/**
		 * Remove a a loaded EngineLoader and it's respective pieces.
		 * @param loader 
		 */
		public function removeLoader(loader:EngineLoader):void
		{
			// Remove Loader itself.
			var idx:int = loaders.indexOf(loader);
			if(idx != -1)
				loaders.splice(idx, 1);
			
			// Reset Source if active source was removed.
			if (source == loader.id)
				source = Constant.GAME_ENGINE;
			
			if(loader.loaded)
				dispatchEvent(new Event(LOADERS_UPDATE));
				
			Logger.log(this, Logger.INFO, "Removed EngineLoader: " + loader.id);
		}

		public function clearLoaders():void
		{
			loaders.length = 0;
			source = Constant.GAME_ENGINE;
			Logger.log(this, Logger.INFO, "Cleared all Engineloaders");
		}
		
		public function loaderInitialized(loader:EngineLoader):void
		{
			dispatchEvent(new Event(LOADERS_UPDATE));
		}
		
		public function get engineLoaders():Vector.<EngineLoader>
		{
			return loaders;
		}
		
		/**
		 * Gets the current active playlist.
		 * @return 
		 */
		public function getCurrentPlaylist():EnginePlaylist
		{
			if(loaders[loadersIndex].playlist != null)
				return loaders[loadersIndex].playlist;

			return loaders[0].playlist;
		}
		
		/**
		 * Get the request playlist.
		 * @param id Source Engine ID
		 * @return 
		 */
		public function getPlaylist(id:String):EnginePlaylist
		{
			for(var i:int = loaders.length - 1; i >= 0; i--)
				if(loaders[i].id == id)
					return loaders[i].playlist;

			return null;
		}
		
		///- Engine Info
		// Get Active Engine Language.
		public function getCurrentInfo():EngineSiteInfo
		{
			if(loaders[loadersIndex].playlist != null)
				return loaders[loadersIndex].info;

			return loaders[0].info;
		}
		
		// Get Engine Playlist.
		public function getInfo(id:String):EngineSiteInfo
		{
			for(var i:int = loaders.length - 1; i >= 0; i--)
				if(loaders[i].id == id)
					return loaders[i].info;

			return null;
		}
		
		///- Engine Language
		// Get Active Engine Language.
		public function getCurrentLanguage():EngineLanguage
		{
			if(loaders[loadersIndex].playlist != null)
				return loaders[loadersIndex].language;

			return loaders[0].language;
		}
		
		// Get Engine Language.
		public function getLanguage(id:String):EngineLanguage
		{
			for(var i:int = loaders.length - 1; i >= 0; i--)
				if(loaders[i].id == id)
					return loaders[i].language;

			return null;
		}
		
		///- Engine Language Text
		/**
		 * Returns the translated text for the given string_id for the optionally provided text.
		 * @param string_id
		 * @param lang 
		 * @return 
		 */
		public function getString(string_id:String, lang:String = "us"):String
		{
			return getStringSource(source, string_id, lang);
		}
		
		public function getStringSource(engineSource:String, string_id:String, lang:String = "us"):String
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
						if ((out = el.getString(string_id, lang)) != "")
						{
							return out;
						}
					}
				}
			}
			
			// No Text, Return ID
			return string_id;
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