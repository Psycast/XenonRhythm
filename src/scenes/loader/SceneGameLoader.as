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
	
	public class SceneGameLoader extends UICore
	{
		private var animation_finished:Boolean = false;
		private var xenonlogo:UISprite;
		private var xenonname:UISprite;
		private var ffrstatus:Label;
		
		public function SceneGameLoader(core:EngineCore)
		{
			super(core);
		}
		
		override public function onStage():void
		{
			// FFR Dude
			xenonlogo = new UISprite(this, new BrandLogoCenter());
			xenonlogo.anchor = UIAnchor.MIDDLE_CENTER;
			xenonlogo.scaleX = xenonlogo.scaleY = 3;
			xenonlogo.alpha = 0;
			
			// FFR Name
			xenonname = new UISprite(this, new BrandName(), -90, 0);
			xenonname.anchor = UIAnchor.MIDDLE_CENTER;
			xenonname.alpha = 0;
			
			// Loading Text
			ffrstatus = new Label(this, 0, 40);
			ffrstatus.anchor = UIAnchor.MIDDLE_CENTER;
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
			// Update Status Text
			if ((core.flags[Flag.LOGIN_SCREEN_SHOWN] && !core.user.isLoaded) || (core.user.isLoaded && !core.user.permissions.isGuest))
				ffrstatus.text = "Loading Game Data...";
			else if (!core.user.isLoaded)
				ffrstatus.text = "Loading User Data...";
			
			// Check User Loaded.
			if (core.user.isLoaded)
			{
				// Check for Guest and never attempted Login.
				if (false && core.user.permissions.isGuest && !core.flags[Flag.LOGIN_SCREEN_SHOWN])
				{
					// Wait For Animation
					if(!animation_finished)
						return;
					
					// Load Language
					if (core.getLanguage(Constant.GAME_ENGINE) == null)
					{
						// Load Basic Language
						Logger.log(this, Logger.WARNING, "Loading temporary FFR Language.");

						var loginText:EngineLanguage = new EngineLanguage(Constant.GAME_ENGINE);
						loginText.loadLoginText();
						core.registerLanguage(loginText);
					}
					
					Logger.log(this, Logger.INFO, "User is guest, showing login.");
					removeEventListener(Event.ENTER_FRAME, e_frameLoadingCheck);
					core.scene = new SceneGameLogin(core);
				}
				// Engine Loading
				else
				{
					var el:EngineLoader = core.getCurrentLoader();
					if (el == null)
					{
						Logger.log(this, Logger.NOTICE, "Loading FFR Core Engine.");
						core.flags[Flag.LOGIN_SCREEN_SHOWN] = true;
						_loadEngines();
					}
					else if (el.loaded)
					{
						// Wait For Animation
						if(!animation_finished)
							return;
						
						Logger.log(this, Logger.NOTICE, "FFR Core Engine Loaded.");
						removeEventListener(Event.ENTER_FRAME, e_frameLoadingCheck);
						core.scene = new SceneSongSelection(core);
					}
					if (el != null)
					{
						if (el.playlist == null && el.loaded_playlist)
							ffrstatus.htmlText = "Loading Game Config...";
						else
							ffrstatus.htmlText = "Loading Game Data... (<font face=\"Consolas\">" + (el.loaded_playlist ? "P" : "-") + (el.loaded_info ? "I" : "-") + (el.loaded_language ? "L" : "-") + "</font>)";
					}
				}
			}
		}
		
		//------------------------------------------------------------------------------------------------//
		/**
		 * Loads the default engines used for the game engine.
		 */
		private function _loadEngines():void
		{
			// Load FFR Playlist, Site Data, Language Text
			var requestParams:Object = {"session": Session.SESSION_ID, "ver": Constant.VERSION}; // "debugLimited": true
			var canonLoader:EngineLoader = new EngineLoader(core, Constant.GAME_ENGINE, Constant.GAME_NAME);
			canonLoader.isCanon = true;
			canonLoader.loadFromConfig(Constant.SITE_CONFIG_URL, requestParams);
			
			//var os1Loader:EngineLoader = new EngineLoader(core);
			//os1Loader.loadFromConfig("http://keysmashingisawesome.com/r3.xml");
			
			var os2Loader:EngineLoader = new EngineLoader(core);
			os2Loader.loadFromConfig("https://prawnskunk.com/ffrmania/r3.xml");
		}
	}

}