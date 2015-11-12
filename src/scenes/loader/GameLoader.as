package scenes.loader
{
	import assets.menu.FFRDudeCenter;
	import assets.menu.FFRName;
	import assets.sGameBackground;
	import classes.engine.EngineCore;
	import classes.engine.EngineLoader;
	import classes.ui.Label;
	import classes.ui.UICore;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Power2;
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import flash.events.Event;
	import scenes.home.TitleScreen;
	
	public class GameLoader extends UICore
	{
		private var langLoader:EngineLoader;
		private var ffrlogo:FFRDudeCenter;
		private var ffrname:FFRName;
		private var ffrstatus:Label;
		
		public function GameLoader(core:EngineCore)
		{
			super(core);
		}
		
		override public function onStage():void
		{
			draw();
		}
		
		override public function draw():void
		{
			var bg:sGameBackground = new sGameBackground();
			addChild(bg);
			
			// FFR Dude
			ffrlogo = new FFRDudeCenter();
			ffrlogo.x = (Constant.GAME_WIDTH / 2);
			ffrlogo.y = (Constant.GAME_HEIGHT / 2);
			ffrlogo.scaleX = ffrlogo.scaleY = 3;
			ffrlogo.alpha = 0;
			addChild(ffrlogo);
			
			// FFR Name
			ffrname = new FFRName();
			ffrname.x = (Constant.GAME_WIDTH / 2) - 125;
			ffrname.y = (Constant.GAME_HEIGHT / 2);
			ffrname.alpha = 0;
			addChild(ffrname);
			
			// Loading Text
			ffrstatus = new Label(this, 0, 0);
			ffrstatus.alpha = 0;
			
			// Logo Animation
			var logoAnimation:TimelineLite = new TimelineLite({"paused": true, "onComplete":e_timelineComplete});
			logoAnimation.add([new TweenLite(ffrlogo, 0.5, {"alpha": 0.85}), new TweenLite(ffrlogo, 1.5, {"scaleX": 1.5, "scaleY": 1.5, "ease": Elastic.easeOut.config(0.3)})], 0);
			logoAnimation.to(ffrlogo, 1, {"x": "-=125", "ease": Power2.easeInOut}, "-=0.7");
			logoAnimation.add([new TweenLite(ffrname, 0.5, {"alpha": 0.85}), new TweenLite(ffrname, 1.2, {"x": "+=50", "ease": Power2.easeOut})], "-=0.7");
			logoAnimation.to([ffrlogo, ffrname], 0.8, {"y": "-=150", "ease": Power2.easeInOut}, "-=0.25");
			
			// Play Animation only once.
			if (core.flags[Flag.LOGIN_SCREEN_SHOWN])
			{
				logoAnimation.progress(1);
			}
			else
			{
				logoAnimation.play();
			}
		}
		
		/**
		 * Event: TIMELINE_COMPLETE
		 * Logo Animation timeline completion event.
		 */
		private function e_timelineComplete():void 
		{
			ffrstatus.move(ffrname.x + 30, ffrname.y + 30);
			new TweenLite(ffrstatus, 0.5, { "alpha": 0.85 } );
			
			addEventListener(Event.ENTER_FRAME, e_frameLoadingCheck);
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
			if((core.flags[Flag.LOGIN_SCREEN_SHOWN] && !core.user.isLoaded) || (core.user.isLoaded && !core.user.permissions.isGuest))
			{
				ffrstatus.text = "Loading Game Data...";
			}
			else if (!core.user.isLoaded)
			{
				ffrstatus.text = "Loading User Data...";
			}
			
			// Check User Loaded.
			if (core.user.isLoaded)
			{
				// Check for Guest and never attempted Login.
				if (core.user.permissions.isGuest && !core.flags[Flag.LOGIN_SCREEN_SHOWN])
				{
					// Load Language
					if (langLoader == null)
					{
						// Load Basic Language
						Logger.log(this, Logger.WARNING, "Loading temporary FFR Language.");
						langLoader = new EngineLoader(core, Constant.GAME_ENGINE, Constant.GAME_NAME);
						langLoader.loadLanguage(Constant.LANGUAGE_URL);
						return;
					}
					
					// Wait Till Language Loaded
					if (core.getLanguage(Constant.GAME_ENGINE) == null)
						return;
					
					Logger.log(this, Logger.INFO, "User is guest, showing login.");
					removeEventListener(Event.ENTER_FRAME, e_frameLoadingCheck);
					core.scene = new GameLogin(core);
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
						Logger.log(this, Logger.NOTICE, "FFR Core Engine Loaded.");
						removeEventListener(Event.ENTER_FRAME, e_frameLoadingCheck);
						core.scene = new TitleScreen(core);
					}
					if (el != null)
					{
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
			
			//var osLoader:EngineLoader = new EngineLoader(core);
			//osLoader.loadFromConfig("http://keysmashingisawesome.com/r3.xml");
		}
	}

}