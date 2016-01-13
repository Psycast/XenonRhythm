package scenes.songselection
{
	import assets.menu.FFRDude;
	import assets.menu.icons.iconGear;
	import classes.engine.EngineCore;
	import classes.engine.EngineLevel;
	import classes.engine.EngineLoader;
	import classes.engine.EnginePlaylist;
	import classes.ui.Box;
	import classes.ui.BoxButton;
	import classes.ui.BoxInput;
	import classes.ui.Label;
	import classes.ui.ScrollPane;
	import classes.ui.UICore;
	import classes.ui.UISprite;
	import classes.ui.UIStyle;
	import classes.ui.VScrollBar;
	import com.flashfla.utils.NumberUtil;
	import com.flashfla.utils.sprintf;
	import com.greensock.easing.Power2;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	import flash.ui.Keyboard;
	import scenes.songselection.ui_songselection.FilterIcon;
	import scenes.songselection.ui_songselection.SongButton;
	
	public class SceneSelectionSongs extends UICore
	{
		public const DM_STANDARD:String = "normal";
		public const DM_ALL:String = "all";
		public const DM_SEARCH:String = "search";
		
		// Data Elements
		/** Engine Playlist Reference */
		private var _playlist:EnginePlaylist;
		
		// UI Elements
		/** Contains all child elements for easy horizontal movement */
		private var shift_plane:UISprite;
		
		private var ffr_logo:UISprite;
		
		/** Genre Selection Scroll Pane */
		private var genre_scrollpane:ScrollPane;
		private var genre_scrollbar:VScrollBar;
		private var genre_songButtons:Array;
		
		/** Song Selection Background */
		private var top_bar_background:Box;
		
		private var search_input:BoxInput;
		private var search_button:BoxButton;
		private var filters_button:BoxButton;
		private var options_button:BoxButton;
		
		/** Song Selection */
		private var ss_background:Box;
		private var ss_scrollpane:ScrollPane;
		private var ss_scrollbar:VScrollBar;
		private var ss_songButtons:Array;
		
		/** Bottom Area */
		private var bottom_bar_background:Box;
		
		private var bottom_user_info:Label;
		
		
		// UI Variables
		/** Active Genre ID */
		public var DISPLAY_MODE:String = DM_STANDARD;
		public var SELECTED_GENRE:int = 1;
		public var SEARCH_TEXT:String = "";
		
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
			top_bar_background = new Box(shift_plane, 145, -1);
			
			search_input = new BoxInput(top_bar_background, 5, 5);
			search_button = new BoxButton(top_bar_background, 105, 5, core.getString("song_selection_menu_search"), e_searchClick);
			filters_button = new BoxButton(top_bar_background, 205, 5, core.getString("song_selection_filters"));
			options_button = new BoxButton(top_bar_background, 305, 5);
			(new FilterIcon(options_button, 3, 3, "Gear", false)).setSize(21, 21);
			search_button.fontSize = filters_button.fontSize = UIStyle.fontSize - 3;
			
			// Setup Song Selection Pane/Bar
			ss_background = new Box(shift_plane, 145, 40);
			ss_scrollpane = new ScrollPane(ss_background, 10, 10);
			ss_scrollbar = new VScrollBar(ss_background);
			ss_scrollbar.addEventListener(Event.CHANGE, e_scrollSongUpdate);
			ss_scrollpane.addEventListener(MouseEvent.CLICK, e_songSelectionPaneClick);
			
			// Search / Filter Box
			bottom_bar_background = new Box(shift_plane, 145, Constant.GAME_HEIGHT - 36);
			bottom_user_info = new Label(bottom_bar_background, 5, 5, sprintf(core.getString("main_menu_userbar"), {
					"player_name": core.user.name,  
					"games_played": NumberUtil.numberFormat(core.user.info.games_played), 
					"grand_total": NumberUtil.numberFormat(core.user.info.grand_total), 
					"rank": NumberUtil.numberFormat(core.user.info.game_rank), 
					"avg_rank": NumberUtil.numberFormat(core.user.levelranks.getAverageRank(core.canonLoader), 3, true)
				}));
			bottom_user_info.autoSize = TextFieldAutoSize.CENTER;
			bottom_user_info.fontSize = UIStyle.fontSize - 1;
			
			// Draw All Game List
			drawGameList();
		}
		
		override public function onResize():void
		{
			// Update Genre Scrollbar Size + Position
			genre_scrollpane.setSizeInstant(115, Constant.GAME_HEIGHT - 130);
			genre_scrollbar.setSizeInstant(15, genre_scrollpane.height);
			genre_scrollbar.scrollFactor = genre_scrollpane.scrollFactor;
			genre_scrollbar.visible = genre_scrollpane.doScroll;
			
			// Top Bar
			top_bar_background.setSizeInstant(Constant.GAME_WIDTH - 150, 36);
			options_button.setSizeInstant(top_bar_background.height - 11, top_bar_background.height - 11);
			options_button.x = top_bar_background.width - options_button.width - 5;
			filters_button.setSizeInstant(75, top_bar_background.height - 11);
			filters_button.x = options_button.x -  filters_button.width - 5;
			search_button.setSizeInstant(75, top_bar_background.height - 11);
			search_button.x = filters_button.x - search_button.width - 5;
			search_input.setSizeInstant(search_button.x - 10, top_bar_background.height - 11);
			
			// Update Song Scroll Pane
			ss_background.setSizeInstant(top_bar_background.width, Constant.GAME_HEIGHT - 80);
			ss_scrollpane.setSizeInstant(ss_background.width - 40, ss_background.height - 20);
			
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
			
			// Scroll Pane Size
			bottom_bar_background.setSizeInstant(Constant.GAME_WIDTH - 150, 36);
			bottom_bar_background.y = Constant.GAME_HEIGHT - 35;
			bottom_user_info.setSize(bottom_bar_background.width - 10, bottom_bar_background.height - 11);
		
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
			
			var i:int;
			
			// Search Mode
			if (DISPLAY_MODE == DM_SEARCH)
			{
				// Filter
				var searchedPlaylist:Array = _playlist.index_list.filter(function(item:EngineLevel, index:int, array:Array):Boolean
						{
							return item.name.toLowerCase().indexOf(SEARCH_TEXT) != -1;
						}).sortOn("name");
						
				// Display
				for (i = 0; i < searchedPlaylist.length; i++)
				{
					ss_songButtons.push(new SongButton(ss_scrollpane, 0, i * 30, core, searchedPlaylist[i]));
				}
			}
			
			// Display All
			if (DISPLAY_MODE == DM_ALL)
			{
			
			}
			// Standard Display
			else
			{
				// Check
				if (_playlist.genre_list[SELECTED_GENRE] != null)
				{
					// Display
					for (i = 0; i < _playlist.genre_list[SELECTED_GENRE].length; i++)
					{
						ss_songButtons.push(new SongButton(ss_scrollpane, 0, i * 30, core, _playlist.genre_list[SELECTED_GENRE][i]));
					}
				}
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
			var drawPosition:Object = { "y": 0, "height": 10 };
			
			// Get Engine Sources
			var engineSources:Array = [];
			for each (var item:EngineLoader in core.engineLoaders) 
			{
				if (item.isCanon) continue; // Skip FFR for now.
				engineSources.push(item.infoArray);
			}
			engineSources = engineSources.sort();
			engineSources.unshift(core.canonLoader.infoArray); // Place FFR first.
			
			// Draw Search Tag / Engine Label
			if (DISPLAY_MODE == DM_SEARCH)
			{
				genreLabel = new Label(genre_scrollpane, 0, genreYPosition, 'Search');
				genreLabel.tag = {"engine": core.source, "genre": "search"};
				genreLabel.setSize(genre_scrollpane.width, 0);
				genreLabel.fontSize = UIStyle.fontSize + 4;
				drawPosition = { "y": genreYPosition, "height": genreLabel.height };
				genreYPosition += genreLabel.height + 2;
			}
			
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
						moveTo(0, genreYPosition+1);
						lineTo(genre_scrollpane.width, genreYPosition+1);
					}
				}
				// Engine Label
				genreLabel = new Label(genre_scrollpane, 0, genreYPosition, '<font color="' + UIStyle.activeFontColor + '">' + engineSource[1] + '</font>', true);
				genreLabel.tag = {"engine": engineSource[1], "genre": genre_id};
				genreLabel.setSize(genre_scrollpane.width, 0);
				genreLabel.fontSize = UIStyle.fontSize + 4;
				genreYPosition += genreLabel.height + 2;
				
				// All Genre
				
				genreLabel = new Label(genre_scrollpane, 0, genreYPosition, core.getStringSource(engineSource[2], "genre_-1"), true);
				genreLabel.tag = {"engine": engineSource[2], "genre": "all"};
				genreLabel.setSize(genre_scrollpane.width, 20);
				genreLabel.mouseEnabled = true;
				if (core.source == engineSource[2] && DISPLAY_MODE == DM_ALL)
				{
					genreLabel.fontSize = UIStyle.fontSize + 2;
					drawPosition = { "y": genreYPosition, "height": genreLabel.height };
				}
				genreYPosition += genreLabel.height + 5;
				
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
						genreLabel.fontSize = UIStyle.fontSize + 2;
						drawPosition = { "y": genreYPosition, "height": genreLabel.height };
					}
					
					genreYPosition += genreLabel.height + 5;
					genre_songButtons.push(genreLabel);
				}
			}
			
			// Draw Active Genre
			with (genre_scrollpane.content.graphics)
			{
				lineStyle(1, 0xFFFFFFF, 0.5);
				beginFill(0xFFFFFF, 0.25);
				drawRect(0, drawPosition.y, genre_scrollpane.width, drawPosition.height);
				endFill();
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
				
				// All Genre
				if (tag.genre == "all")
				{
					DISPLAY_MODE = DM_ALL;
					SELECTED_GENRE = -1;
				}
				// Normal Genres
				else
				{
					DISPLAY_MODE = DM_STANDARD;
					SELECTED_GENRE = parseInt(tag.genre);
				}
				drawGameList();
			}
		}
		
		/**
		 * Search Button Click Event
		 */
		private function e_searchClick(e:Event):void 
		{
			SEARCH_TEXT = search_input.text.toLowerCase();
			DISPLAY_MODE = DM_SEARCH;
			SELECTED_GENRE = -1;
			
			drawGameList();
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