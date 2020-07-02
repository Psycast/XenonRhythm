package scenes.songselection
{
	import classes.Song;
	import classes.engine.EngineCore;
	import classes.engine.EngineLevel;
	import classes.engine.EngineRanksLevel;
	import classes.ui.BoxButton;
	import classes.ui.Label;
	import classes.ui.UIAnchor;
	import classes.ui.UICore;
	import classes.ui.UISprite;
	import classes.ui.UIStyle;
	import com.flashfla.utils.NumberUtil;
	import com.flashfla.utils.SpriteUtil;
	import com.flashfla.utils.StringUtil;
	import com.greensock.TweenLite;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.geom.Matrix;
	import flash.text.TextFieldAutoSize;
	import scenes.gameplay.SceneGamePlay;
	
	public class SceneSongLoader extends UICore
	{
		private var songData:EngineLevel;
		private var song:Song;
		private var _matrix:Matrix = new Matrix();
		
		private var loaderBackground:UISprite;
		private var queueBox:UISprite;
		private var songName:Label;
		private var songAuthor:Label;
		private var songStats:UISprite;
		private var cancelLoadButton:BoxButton;
		
		private var loadedRatio:Number = 0;
		private var tweenRatio:Number = 0;
		private var fadeInDone:Boolean = false;
		
		//------------------------------------------------------------------------------------------------//
		
		public function SceneSongLoader(core:EngineCore)
		{
			super(core);
		}
		
		override public function init():void
		{
			super.init();
			
			if (core.variables.song_queue.length > 0)
			{
				songData = core.variables.song_queue[0];
			}
			
			if (songData)
			{
				song = core.song_loader.getSong(songData);
				song.addEventListener(ProgressEvent.PROGRESS, e_songLoadProgress);
				song.addEventListener(ErrorEvent.ERROR, e_songLoadError);
				
				if (!song.loaded)
					song.load();
			}
		}
		
		override public function destroy():void 
		{
			super.destroy();
			stage.removeEventListener(Event.ENTER_FRAME, e_enterFrame);
			if (song)
			{
				song.removeEventListener(ProgressEvent.PROGRESS, e_songLoadProgress);
				song.removeEventListener(ErrorEvent.ERROR, e_songLoadError);
			}
		}
		
		override public function onStage():void
		{
			if (!songData)
				_switchScene(0);
				
			stage.addEventListener(Event.ENTER_FRAME, e_enterFrame);
			
			// Create Loader Bar Background Plate
			loaderBackground = new UISprite(this, null, 0, 0);
			loaderBackground.anchor = UIAnchor.MIDDLE_LEFT;
			loaderBackground.alpha = 0;
			TweenLite.to(loaderBackground, 1, { "delay": 1, "alpha": 1, "onComplete":function():void { fadeInDone = true;} } );
			
			// Create Song Data Background Plate
			queueBox = new UISprite(this, null, 0, -35);
			queueBox.setSize(100, 300);
			queueBox.anchor = UIAnchor.MIDDLE_LEFT;
			queueBox.alpha = 0;
			TweenLite.to(queueBox, 1, {"alpha": 1, "y": "-25"});
			
			// Song Details
			songName = new Label(queueBox, 5, 5, songData.name, true);
			songName.setSize(100, (songData.author != "" ? 45 : 90), false);
			songName.fontSize = UIStyle.FONT_SIZE + 15;
			songName.autoSize = TextFieldAutoSize.CENTER;
			
			if (songData.author != "")
			{
				songAuthor = new Label(queueBox, 5, 45, songData.author);
				songAuthor.setSize(100, 45, false);
				songAuthor.fontSize = UIStyle.FONT_SIZE + 4;
				songAuthor.autoSize = TextFieldAutoSize.CENTER;
			}
			
			// User Info
			if (!core.user.permissions.isGuest)
			{
				// Display Level Ranks
				var levelRanks:EngineRanksLevel = core.user.levelranks.getEngineRanks(songData.source).getRank(songData.id);
				if (levelRanks != null && levelRanks.score > 0)
				{
					songStats = new UISprite(this, null, -210, 0);
					songStats.anchor = UIAnchor.BOTTOM_CENTER;
					songStats.alpha = 0;
					TweenLite.to(songStats, 1, {"delay": 1, "alpha": 1, "y": "-25"});
					
					songStats.graphics.lineStyle(1, 0x000000, 0);
					
					var userAvatar:DisplayObject;
					
					// Song Stats
					var statLabel:Label;
					var offset:int = 0;
					var gap:int = 22;
					for each (var stat:String in["amazing", "perfect", "good", "average", "miss", "boo", "combo", "score"])
					{
						statLabel = new Label(songStats, 5, offset * gap, StringUtil.upperCase(core.getStringSource(songData.source, "game_" + stat)));
						statLabel.setSize(80, gap - 2);
						
						statLabel = new Label(songStats, 90, offset * gap, NumberUtil.numberFormat(levelRanks[stat]));
						statLabel.setSize(105, gap - 2);
						statLabel.autoSize = TextFieldAutoSize.RIGHT;
						
						if (stat == "amazing" && levelRanks["amazing"] == 0)
							statLabel.text = "---";
						
						if (offset & 1)
						{
							songStats.graphics.beginFill(0x000000, 0.10);
							songStats.graphics.drawRect(0, offset * gap + 1, 200, gap);
							songStats.graphics.endFill();
						}
						offset++;
					}
					
					var boxHeight:Number = offset * gap + 5;
					
					songStats.graphics.beginFill(0x000000, 0.25);
					songStats.graphics.drawRect(0, 0, 200, boxHeight);
					songStats.graphics.endFill();
					
					// User Avatar
					if (core.user.avatar != null)
					{
						userAvatar = core.user.avatar.content;
						if (userAvatar.height > 0 && userAvatar.width > 0)
						{
							SpriteUtil.scaleTo(userAvatar, 190, (boxHeight - 52));
							userAvatar.x = 320 - (userAvatar.width / 2);
							userAvatar.y = boxHeight - 53 - userAvatar.height;
							songStats.addChild(userAvatar);
						}
					}
					
					// Username
					statLabel = new Label(songStats, 225, boxHeight - 53, core.user.name);
					statLabel.setSize(190, 23);
					statLabel.fontSize = UIStyle.FONT_SIZE + 2;
					statLabel.autoSize = TextFieldAutoSize.CENTER;
					
					// Rank
					statLabel = new Label(songStats, 225, boxHeight - 27, core.getStringSource(songData.source, "results_best_rank") + ": " + NumberUtil.numberFormat(levelRanks.rank));
					statLabel.setSize(190, 20);
					statLabel.autoSize = TextFieldAutoSize.CENTER;
					
					songStats.graphics.beginFill(0x000000, 0.25);
					songStats.graphics.drawRect(220, 0, 200, Math.max(139, boxHeight));
					songStats.graphics.endFill();
					
					// Set Position
					songStats.y = -(Math.max(139, offset * gap + 5) - 25);
				}
				
				// No Level Ranks, Just Display User
				else
				{
					songStats = new UISprite(this, null, -125, -139);
					songStats.anchor = UIAnchor.BOTTOM_CENTER;
					songStats.alpha = 0;
					TweenLite.to(songStats, 1, {"delay": 1, "alpha": 1});
					
					songStats.graphics.lineStyle(1, 0x000000, 0);
					
					// User Avatar
					if (core.user.avatar != null)
					{
						userAvatar = core.user.avatar.content;
						if (userAvatar.height > 0 && userAvatar.width > 0)
						{
							SpriteUtil.scaleTo(userAvatar, 99, 99);
							userAvatar.x = 125 - (userAvatar.width / 2);
							userAvatar.y = 104 - userAvatar.height;
							songStats.addChild(userAvatar);
						}
					}
					
					// Username
					statLabel = new Label(songStats, 5, 106, core.user.name);
					statLabel.setSize(240, 23);
					statLabel.fontSize = UIStyle.FONT_SIZE + 2;
					statLabel.autoSize = TextFieldAutoSize.CENTER;
					
					songStats.graphics.beginFill(0x000000, 0.25);
					songStats.graphics.drawRect(0, 0, 250, 139);
					songStats.graphics.endFill();
				}
			}
			
			// Cancel Button
			cancelLoadButton = new BoxButton(this, -75, -30, "CANCEL", e_cancelSongLoad);
			cancelLoadButton.setSize(70, 25);
			cancelLoadButton.anchor = UIAnchor.BOTTOM_RIGHT;
			cancelLoadButton.group = "buttons";
			super.onStage();
		}
		
		override public function draw():void
		{
			// Update Queue Box Background Graphic
			_matrix.createGradientBox(Constant.GAME_WIDTH, Constant.GAME_HEIGHT, 0);
			queueBox.graphics.clear();
			queueBox.graphics.lineStyle(1, 0x000000, 0);
			queueBox.graphics.beginGradientFill(GradientType.LINEAR, [0, 0, 0, 0], [0, 0.5, 0.5, 0], [0, 32, 222, 255], _matrix);
			queueBox.graphics.drawRect(0, 0, Constant.GAME_WIDTH, 90);
			queueBox.graphics.endFill();
			
			// Update Loader Bar
			_drawSongLoadingBar();
		}
		
		override public function position():void
		{
			songName.width = Constant.GAME_WIDTH;
			
			if (songAuthor)
				songAuthor.width = Constant.GAME_WIDTH;
		}
		
		override public function onResize():void
		{
			super.onResize();
			draw();
		}
		
		//------------------------------------------------------------------------------------------------//
		
		///////////////////////////////////
		// private methods
		///////////////////////////////////
		
		private function _drawSongLoadingBar():void
		{
			var LOAD_BAR_X:Number = Constant.GAME_WIDTH * tweenRatio;
			
			loaderBackground.graphics.clear();
			loaderBackground.graphics.lineStyle(1, 0x000000, 0);
			loaderBackground.graphics.beginFill(0x000000, 0.25);
			loaderBackground.graphics.drawRect(0, 30, Constant.GAME_WIDTH, 8);
			loaderBackground.graphics.endFill();
			
			loaderBackground.graphics.beginFill(0x1DBA77, 0.75);
			loaderBackground.graphics.drawRect(0, 30, LOAD_BAR_X, 8);
			loaderBackground.graphics.endFill();
			
			loaderBackground.graphics.beginFill(0x000000, 0.5);
			loaderBackground.graphics.moveTo(LOAD_BAR_X, 40);
			loaderBackground.graphics.lineTo(LOAD_BAR_X + 7, 47);
			loaderBackground.graphics.lineTo(LOAD_BAR_X - 7, 47);
			loaderBackground.graphics.lineTo(LOAD_BAR_X, 40);
			loaderBackground.graphics.endFill();
		}
		
		private function _cancelBackToMenu():void 
		{
			if (song && !song.load_failed)
			{
				song.markAsFailed();
				core.variables.song_queue.shift();
			}
			_switchScene(0);
		}
		
		/**
		 * Does the scene closing animation before switching scene.
		 * @param	sceneIndex Scene Index to jump to.
		 */
		private function _closeScene(sceneIndex:int):void
		{
			INPUT_DISABLED = true;
			
			if(songStats)
				TweenLite.to(songStats, 1, {"alpha": 0, "y": "25"});
				
			TweenLite.to([queueBox, loaderBackground], 1, {"alpha": 0, "y": "-25"});
			TweenLite.to(getChildAt(0), 1, {"delay": 0.5, "alpha": 0, "onComplete": function():void
			{
				_switchScene(sceneIndex);
			}});
		}
		
		/**
		 * Changes scenes based on ID.
		 * @param	menuIndex Scene ID to change to.
		 */
		private function _switchScene(sceneIndex:int):void
		{
			if(!SCENE_SWITCHING) {
				SCENE_SWITCHING = true;
				
				// Switch to Intended UI scene
				switch (sceneIndex)
				{
					case 0: 
						core.scene = new SceneSongSelection(core);
						break;
						
					case 1:
						core.scene = new SceneGamePlay(core);
				}
			}
		}
		
		//------------------------------------------------------------------------------------------------//
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		//------------------------------------------------------------------------------------------------//
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		private function e_cancelSongLoad(e:Event):void 
		{
			_cancelBackToMenu();
		}
		
		private function e_enterFrame(e:Event):void
		{
			if ((tweenRatio < 0.999 && !song.loaded) || !fadeInDone)
			{
				tweenRatio += (loadedRatio - tweenRatio) * 0.05;
				_drawSongLoadingBar();
			}
			else
			{
				stage.removeEventListener(Event.ENTER_FRAME, e_enterFrame);
				tweenRatio = 1;
				_drawSongLoadingBar();
				_closeScene(1);
			}
		}
		
		private function e_songLoadError(e:Event):void
		{
			Logger.log(this, Logger.ERROR, "Song Load Failed, returning to Song Selection...");
			_cancelBackToMenu();
		}
		
		private function e_songLoadProgress(e:ProgressEvent):void
		{
			loadedRatio = (e.bytesLoaded / e.bytesTotal);
		}
	
	}

}