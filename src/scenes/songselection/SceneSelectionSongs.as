package scenes.songselection
{
	import assets.menu.FFRDude;
	import classes.engine.EngineCore;
	import classes.engine.EngineLoader;
	import classes.engine.EnginePlaylist;
	import classes.ui.Box;
	import classes.ui.Label;
	import classes.ui.ScrollPane;
	import classes.ui.UICore;
	import classes.ui.UISprite;
	import classes.ui.UIStyle;
	import classes.ui.VScrollBar;
	import com.greensock.easing.Power2;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import scenes.songselection.ui_songselection.FilterIcon;
	import scenes.songselection.ui_songselection.SongButton;
	
	public class SceneSelectionSongs extends UICore
	{
		// Data Elements
		/** Engine Playlist Reference */
		private var _playlist:EnginePlaylist;
		
		private var icons:Array = ["ArrowCount", "Artist", "BPM", "Difficulty", "Genre", "ID", "Name", "NPS", "Rank", "Score", "Stats", "StepArtist", "Time"];
		
		// UI Elements
		/** Contains all child elements for easy horizontal movement */
		private var shift_plane:UISprite;
		
		private var ffr_logo:UISprite;
		
		/** Genre Selection Scroll Pane */
		private var genre_scrollpane:ScrollPane;
		
		/** Genre Selection Scroll Bar */
		private var genre_scrollbar:VScrollBar;
		
		/** Genre Selection Song Buttons */
		private var genre_songButtons:Array;
		
		/** Song Selection Background */
		private var search_background:Box;
		
		/** Song Selection Background */
		private var ss_background:Box;
		
		/** Song Selection Scroll Pane */
		private var ss_scrollpane:ScrollPane;
		
		/** Song Selection Scroll Bar */
		private var ss_scrollbar:VScrollBar;
		
		/** Song Selection Song Buttons */
		private var ss_songButtons:Array;
		
		
		// UI Variables
		/** Active Genre ID */
		public var SELECTED_GENRE:int = 1;
		
		//------------------------------------------------------------------------------------------------//
		
		public function SceneSelectionSongs(core:EngineCore)
		{
			super(core);
		}
		
		override public function onStage():void
		{
			super.onStage();
			stage.addEventListener(KeyboardEvent.KEY_DOWN, e_keyboardDown);
		}
		
		override public function draw():void
		{
			// Overall Background
			shift_plane = new UISprite(this);
			shift_plane.alpha = 0;
			TweenLite.to(shift_plane, 1, {"delay": 0.5, "alpha": 1});
			
			// Game Logo
			ffr_logo = new UISprite(shift_plane, new FFRDude(), 22, 12);

			// Setup Genre Selection Pane/Bar
			(genre_scrollpane = new ScrollPane(shift_plane, 5, 125)).setSize(115, 100);
			genre_scrollbar = new VScrollBar(shift_plane);
			genre_scrollbar.move(genre_scrollpane.x + genre_scrollpane.width + 5, genre_scrollpane.y);
			genre_scrollbar.addEventListener(Event.CHANGE, e_scrollGenreUpdate);
			genre_scrollpane.addEventListener(MouseEvent.CLICK, e_genreSelectionPaneClick);
			
			// Search / Filter Box
			search_background = new Box(shift_plane, 145, -1);
			
			// Setup Song Selection Pane/Bar
			ss_background = new Box(shift_plane, 145, 40);
			ss_scrollpane = new ScrollPane(ss_background, 5, 5);
			ss_scrollbar = new VScrollBar(ss_background);
			ss_scrollbar.addEventListener(Event.CHANGE, e_scrollSongUpdate);
			ss_scrollpane.addEventListener(MouseEvent.CLICK, e_songSelectionPaneClick);
			
			// Draw All Game List
			drawGameList();
		}
		
		override public function onResize():void
		{
			// Scroll Pane Size
			search_background.setSizeInstant(Constant.GAME_WIDTH - 150, 36);
			
			// Update Genre Scrollbar Size + Position
			genre_scrollpane.setSizeInstant(115, Constant.GAME_HEIGHT - 130);
			genre_scrollbar.setSizeInstant(15, genre_scrollpane.height);
			genre_scrollbar.scrollFactor = genre_scrollpane.scrollFactor;
			genre_scrollbar.visible = genre_scrollpane.doScroll;
			
			// Update Song Scroll Pane
			ss_background.setSizeInstant(search_background.width, Constant.GAME_HEIGHT - 75);
			ss_scrollpane.setSizeInstant(ss_background.width - 30, ss_background.height - 10);
			
			// Position Song Buttons
			var songButtonYPosition:int = 0;
			for each (var item:SongButton in ss_songButtons)
			{
				item.y = songButtonYPosition;
				item.setSizeInstant(ss_scrollpane.width, 31);
				songButtonYPosition += item.height + 5;
			}
			
			// Update Song Scroll Bar
			ss_scrollbar.setSizeInstant(15, ss_scrollpane.height);
			ss_scrollbar.move(ss_scrollpane.x + ss_scrollpane.width + 5, ss_scrollpane.y);
			ss_scrollbar.scrollFactor = ss_scrollpane.scrollFactor;
			ss_scrollbar.showDragger = ss_scrollpane.doScroll;
		
		}
		
		//------------------------------------------------------------------------------------------------//
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		/**
		 * Draws all the important game list that need refreshing.
		 */
		public function drawGameList():void
		{
			// Get Updated Playlist Reference
			_playlist = core.getCurrentPlaylist();
			
			drawGenreList();
			drawSongList();
			
			// Size / Position
			onResize();
		}
		
		/**
		 * Creates the Song Buttons
		 */
		public function drawSongList():void
		{
			ss_scrollpane.removeChildren();
			ss_scrollbar.scroll = 0;
			ss_songButtons = [];
			/*
			for (var i:int = 0; i < _playlist.genre_list[SELECTED_GENRE].length; i++)
			{
				ss_songButtons.push(new SongButton(ss_scrollpane, 0, i * 30, core, _playlist.genre_list[SELECTED_GENRE][i]));
			}
			*/
			for (var i:int = 0; i < icons.length; i++) 
			{
				new FilterIcon(ss_scrollpane, 5, i * 30 + 5, icons[i]);
				new Label(ss_scrollpane, 35, i * 30 + 5, icons[i]);
			}
		}
		
		/**
		 * Creates the Genre Buttons.
		 */
		public function drawGenreList():void
		{
			genre_scrollpane.removeChildren();
			genre_scrollpane.content.graphics.clear();
			genre_songButtons = [];
			
			var genreLabel:Label;
			var genreYPosition:int = 0;
			
			// Get Engine Sources
			var engineSources:Array = [];
			for each (var item:EngineLoader in core.engineLoaders) 
			{
				if (item.isCanon) continue; // Skip FFR for now.
				engineSources.push(item.infoArray);
			}
			engineSources = engineSources.sort();
			engineSources.unshift(core.canonLoader.infoArray); // Place FFR first.
			
			// Draw Search Tag// Engine Label
			genreLabel = new Label(genre_scrollpane, 0, genreYPosition, 'Search');
			genreLabel.tag = {"engine": core.source, "genre": "search"};
			genreLabel.setSize(genre_scrollpane.width, 0);
			genreLabel.fontSize = 18;
			genreYPosition += genreLabel.height + 2;
			
			// Draw Genre Labels
			var engineSource:Array;
			for (var engine:int = 0; engine < engineSources.length; engine++)
			{
				engineSource = engineSources[engine];
				
				// Draw Diving Border
				if (genreYPosition != 0)
				{
					with (genre_scrollpane.content.graphics)
					{
						lineStyle(1, 0xFFFFFFF, 0.5);
						moveTo(0, genreYPosition);
						lineTo(genre_scrollpane.width, genreYPosition);
					}
				}
				// Engine Label
				genreLabel = new Label(genre_scrollpane, 0, genreYPosition, '<font color="' + UIStyle.selectedFontColor + '">' + engineSource[1] + '</font>', true);
				genreLabel.tag = {"engine": engineSource[1], "genre": genre_id};
				genreLabel.setSize(genre_scrollpane.width, 0);
				genreLabel.fontSize = 18;
				
				genreYPosition += genreLabel.height + 2;
				
				// Genre Labels
				for (var genre_id:String in core.getPlaylist(engineSource[2]).genre_list)
				{
					var genre_int:int = parseInt(genre_id);
					genreLabel = new Label(genre_scrollpane, 0, genreYPosition, core.getStringSource(engineSource[2], "genre_" + (genre_int - 1)), true);
					genreLabel.tag = {"engine": engineSource[2], "genre": genre_id};
					genreLabel.setSize(genre_scrollpane.width, 20);
					genreLabel.mouseEnabled = true;
					
					if (core.source == engineSource[2] && genre_int == SELECTED_GENRE)
					{
						genreLabel.fontSize = 16;
						with (genre_scrollpane.content.graphics)
						{
							lineStyle(1, 0xFFFFFFF, 0.5);
							beginFill(0xFFFFFF, 0.25);
							drawRect(0, genreYPosition, genre_scrollpane.width, genreLabel.height);
							endFill();
						}
					}
					
					genreYPosition += genreLabel.height + 5;
					genre_songButtons.push(genreLabel);
				}
			}
			
		}
		
		//------------------------------------------------------------------------------------------------//
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		/**
		 * Genre Scrollpane Click
		 */
		private function e_genreSelectionPaneClick(e:MouseEvent):void
		{
			var target:* = e.target;
			if (target is Label)
			{
				var tag:Object = (target as Label).tag;
				if (tag.engine != core.source)
				{
					core.source = tag.engine;
				}
				SELECTED_GENRE = parseInt(tag.genre);
				drawGameList();
			}
		}
		
		/**
		 * Song Selection Scrollpane Click 
		 */
		private function e_songSelectionPaneClick(e:MouseEvent):void
		{
			var target:* = e.target;
			if (target is SongButton)
			{
				trace((e.target as SongButton).songData.name);
			}
		}
		
		private function e_scrollGenreUpdate(e:Event):void
		{
			genre_scrollpane.scroll = genre_scrollbar.scroll;
		}
		
		private function e_scrollSongUpdate(e:Event):void
		{
			ss_scrollpane.scroll = ss_scrollbar.scroll;
		}
		
		private function e_keyboardDown(e:KeyboardEvent):void 
		{

		}
		
	
	}

}