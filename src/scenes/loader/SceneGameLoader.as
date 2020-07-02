package scenes.loader
{
	import assets.menu.BrandLogoCenter;
	import assets.menu.BrandName;
	import classes.engine.EngineCore;
	import classes.engine.EngineLanguage;
	import classes.engine.EngineLoader;
	import classes.ui.Label;
	import classes.ui.UIAnchor;
	import classes.ui.UICore;
	import classes.ui.UISprite;
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Power2;
	import flash.events.Event;
	import scenes.songselection.SceneSongSelection;
	import flash.text.TextFieldAutoSize;
	import classes.engine.EngineConfigLoader;
	import classes.user.User;
	
	public class SceneGameLoader extends UICore
	{
		private var animation_finished:Boolean = false;
		private var xenonlogo:UISprite;
		private var xenonname:UISprite;
		private var ffrstatus:Label;
		
		public function SceneGameLoader(core:EngineCore)
		{
			super(core);

			// Load Core Config before anything else.
			Logger.log(this, Logger.NOTICE, "Loading " + Constant.GAME_NAME + " Engine.");
			_loadConfigs();
		}
		
		override public function onStage():void
		{
			// Engine Logo
			xenonlogo = new UISprite(this, new BrandLogoCenter());
			xenonlogo.anchor = UIAnchor.MIDDLE_CENTER;
			xenonlogo.scaleX = xenonlogo.scaleY = 3;
			xenonlogo.alpha = 0;
			
			// Engine Name
			xenonname = new UISprite(this, new BrandName(), -90, 0);
			xenonname.anchor = UIAnchor.MIDDLE_CENTER;
			xenonname.alpha = 0;
			
			// Loading Text
			ffrstatus = new Label(this, 0, 20);
			ffrstatus.anchor = UIAnchor.MIDDLE_CENTER;
			ffrstatus.autoSize = TextFieldAutoSize.CENTER;
			ffrstatus.alpha = 0;
			
			super.onStage();
			
			getChildAt(0).alpha = 0;

			addEventListener(Event.ENTER_FRAME, e_frameLoadingCheck);
			
			// Logo Animation
			var logoAnimation:TimelineLite = new TimelineLite({"paused": true, "onComplete": e_timelineComplete});
			logoAnimation.to(getChildAt(0), 0.5, {"alpha": 1});
			logoAnimation.add([new TweenLite(xenonlogo, 0.5, {"alpha": 1}), new TweenLite(xenonlogo, 1.5, {"scaleX": 1.5, "scaleY": 1.5, "ease": Elastic.easeOut.config(0.3)})], "+=0.5");
			logoAnimation.to(xenonlogo, 1, {"x": "-=65", "ease": Power2.easeInOut}, "-=0.7");
			logoAnimation.add([new TweenLite(xenonname, 0.5, {"alpha": 1}), new TweenLite(xenonname, 1.2, {"x": "+=55", "ease": Power2.easeOut})], "-=0.7");
			logoAnimation.to([xenonlogo, xenonname], 0.8, {"y": "-=50", "ease": Power2.easeInOut}, "-=0.25");
			
			// Play Animation only once.
			if (core.flags[Flag.LOGIN_SCREEN_SHOWN])
				logoAnimation.progress(1);
			else
				logoAnimation.play();
		}
		
		/**
		 * Event: TIMELINE_COMPLETE
		 * Logo Animation timeline completion event.
		 */
		private function e_timelineComplete():void
		{
			new TweenLite(ffrstatus, 0.5, {"alpha": 0.85});

			animation_finished = true;
		}
		
		//------------------------------------------------------------------------------------------------//
		/**
		 * Event: ENTER_FRAME:
		 * Handles the progress bar and load checks.
		 * @param	e Frame Event
		 */
		private function e_frameLoadingCheck(e:Event):void
		{
			// Loading Game Config
			if(core.loaderCount == 0 || core.canonLoader == null)
			{
				ffrstatus.text = "Loading Game Configuration...";
				return;
			}

			// Load User Data
			if(core.user == null)
			{
				core.user = new User(core, true, true);
				return;
			}

			// Update Status Text
			if ((core.flags[Flag.LOGIN_SCREEN_SHOWN] && !core.user.isLoaded) || (core.user.isLoaded && !core.user.permissions.isGuest))
				ffrstatus.text = "Loading Game Data...";
			else if (!core.user.isLoaded)
				ffrstatus.text = "Loading User Data...";
			
			// Get Active Loader
			var el:EngineLoader = core.canonLoader;

			// Check User Loaded.
			if (core.user.isLoaded)
			{
				// Check for Guest and never attempted Login.
				if (core.user.permissions.isGuest && !core.flags[Flag.LOGIN_SCREEN_SHOWN])
				{
					// Wait For Animation
					if(!animation_finished)
						return;
					
					// Load Language
					if (core.getLanguage(Constant.GAME_ENGINE) == null)
					{
						// Load Basic Language
						Logger.log(this, Logger.WARNING, "Loading temporary Language.");
						el.language = new EngineLanguage(el.id);
						el.language.loadLoginText();
					}
					
					Logger.log(this, Logger.INFO, "User is guest, showing login.");
					removeEventListener(Event.ENTER_FRAME, e_frameLoadingCheck);
					core.scene = new SceneGameLogin(core);
				}
				// Engine Loading
				else
				{
					if(el == null)
					{
						// Do nothing when no active engine loaders.
					}
					else if(!el.isLoading)
					{
						_loadEngines();
					}
					else if (el.loaded)
					{
						// Wait For Animation
						if(!animation_finished)
							return;
						
						Logger.log(this, Logger.NOTICE, Constant.GAME_NAME + " Engine Loaded.");
						removeEventListener(Event.ENTER_FRAME, e_frameLoadingCheck);
						core.scene = new SceneSongSelection(core);
					}
					else
					{
						ffrstatus.htmlText = "Loading Game Data... (<font face=\"Consolas\">" + 
								(el.playlist && el.playlist.valid ? "P" : "-") + 
								(el.info && el.info.valid ? "I" : "-") + 
								(el.language && el.language.valid ? "L" : "-") + 
							"</font>)";
					}
				}
			}
		}
		
		//------------------------------------------------------------------------------------------------//
		/**
		 * Loads the default engines used for the game engine.
		 */
		private function _loadConfigs():void
		{
			if(core.loaderCount == 0)
			{
				// Load FFR Playlist, Site Data, Language Text
				var requestParams:Object = {"session": Session.SESSION_ID, "ver": Constant.VERSION}; // "debugLimited": true
				var canonLoader:EngineConfigLoader = new EngineConfigLoader(core);
				canonLoader.id = Constant.GAME_ENGINE;
				canonLoader.isCanon = true;
				canonLoader.loadFromConfig(Constant.SITE_CONFIG_URL, requestParams);
				
				//var os1Loader:EngineLoader = new EngineLoader(core);
				//os1Loader.loadFromConfig("http://keysmashingisawesome.com/r3.xml");
				
				var os2Loader:EngineConfigLoader = new EngineConfigLoader(core);
				os2Loader.loadFromConfig("https://prawnskunk.com/ffrmania/r3.xml");
			}
		}
		/**
		 * Loads the default engines used for the game engine.
		 */
		private function _loadEngines():void
		{
			for each(var loader:EngineLoader in core.engineLoaders)
			{
				if(!loader.isLoading && !loader.loaded)
				{
					if(loader.isCanon)
						loader.load({"session": Session.SESSION_ID, "ver": Constant.VERSION});
					else
						loader.load();
				}
			}
		}
	}
}