package scenes.songselection
{
	import assets.menu.FFRDude;
	import classes.engine.EngineCore;
	import classes.engine.EngineLevel;
	import classes.engine.EngineLoader;
	import classes.engine.EnginePlaylist;
	import classes.ui.Box;
	import classes.ui.BoxButton;
	import classes.ui.BoxInput;
	import classes.ui.Label;
	import classes.ui.ScrollPaneBars;
	import classes.ui.UICore;
	import classes.ui.UISprite;
	import classes.ui.UIStyle;
	import com.flashfla.utils.ArrayUtil;
	import com.flashfla.utils.NumberUtil;
	import com.flashfla.utils.StringUtil;
	import com.flashfla.utils.sprintf;
	import com.greensock.TweenLite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	import flash.ui.Keyboard;
	import scenes.songselection.ui.SongButton;
	import scenes.songselection.ui.filtereditor.FilterEditor;
	import scenes.songselection.ui.filtereditor.FilterIcon;
	
	public class SceneSongSelection extends UICore
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
		private var genre_scrollpane:ScrollPaneBars;
		private var genre_songButtons:Array;
		
		/** Song Selection Background */
		private var top_bar_background:Box;
		
		private var search_input:BoxInput;
		private var search_button:BoxButton;
		private var filters_button:BoxButton;
		private var options_button:BoxButton;
		
		/** Song Selection */
		private var ss_background:Box;
		private var ss_scrollpane:ScrollPaneBars;
		private var ss_songButtons:Array;
		
		/** Bottom Area */
		private var bottom_bar_background:Box;
		
		private var bottom_user_info:Label;
		
		// UI Variables
		/** Active Genre ID */
		public var DISPLAY_MODE:String = DM_STANDARD;
		public var SELECTED_GENRE:int = 1;
		public var SELECTED_SONG:SongButton;
		public var CURRENT_PAGE:int = 0;
		public var SEARCH_TEXT:String = "";
		
		//------------------------------------------------------------------------------------------------//
		
		public function SceneSongSelection(core:EngineCore)
		{
			super(core);
		}
		
		override public function onStage():void
		{
			super.onStage();
			stage.addEventListener(KeyboardEvent.KEY_DOWN, e_keyboardDown);
			core.addEventListener(EngineCore.LOADERS_UPDATE, e_loadersUpdate);
		}
		
		override public function destroy():void
		{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, e_keyboardDown);
			core.removeEventListener(EngineCore.LOADERS_UPDATE, e_loadersUpdate);
		}
		
		override public function draw():void
		{
			// Overall Background
			shift_plane = new UISprite(this);
			shift_plane.alpha = 0;
			TweenLite.to(shift_plane, 0.5, {"delay": 0.5, "alpha": 1});
			
			// Game Logo
			ffr_logo = new UISprite(shift_plane, new FFRDude(), 22, 12);
			
			// Setup Genre Selection Pane/Bar
			(genre_scrollpane = new ScrollPaneBars(shift_plane, 5, 125)).setSize(115, 100);
			genre_scrollpane.addEventListener(MouseEvent.CLICK, e_genreSelectionPaneClick);
			
			// Search / Filter Box
			top_bar_background = new Box(shift_plane, 145, -1);
			
			search_input = new BoxInput(top_bar_background, 5, 5);
			search_button = new BoxButton(top_bar_background, 105, 5, core.getString("song_selection_menu_search"), e_searchClick);
			filters_button = new BoxButton(top_bar_background, 205, 5, core.getString("song_selection_filters"), e_filtersClick);
			options_button = new BoxButton(top_bar_background, 305, 5);
			(new FilterIcon(options_button, 3, 3, "Gear", false)).setSize(21, 21);
			search_button.fontSize = filters_button.fontSize = UIStyle.FONT_SIZE - 3;
			
			// Setup Song Selection Pane/Bar
			ss_background = new Box(shift_plane, 145, 40);
			ss_scrollpane = new ScrollPaneBars(ss_background, 10, 10);
			ss_scrollpane.addEventListener(MouseEvent.CLICK, e_songSelectionPaneClick);
			
			// Search / Filter Box
			bottom_bar_background = new Box(shift_plane, 145, Constant.GAME_HEIGHT - 36);
			bottom_user_info = new Label(bottom_bar_background, 5, 5, sprintf(core.getString("main_menu_userbar"), {"player_name": core.user.name, "games_played": NumberUtil.numberFormat(core.user.info.games_played), "grand_total": NumberUtil.numberFormat(core.user.info.grand_total), "rank": NumberUtil.numberFormat(core.user.info.game_rank), "avg_rank": NumberUtil.numberFormat(core.user.levelranks.getAverageRank(core.canonLoader), 3, true)}));
			bottom_user_info.autoSize = TextFieldAutoSize.CENTER;
			bottom_user_info.fontSize = UIStyle.FONT_SIZE - 1;
			
			// Draw All Game List
			drawGameList();
		}
		
		override public function onResize():void
		{
			// Update Genre Scrollbar Size + Position
			genre_scrollpane.setSize(135, Constant.GAME_HEIGHT - 130);
			
			// Top Bar
			top_bar_background.setSize(Constant.GAME_WIDTH - 150, 36);
			options_button.setSize(top_bar_background.height - 11, top_bar_background.height - 11);
			options_button.x = top_bar_background.width - options_button.width - 5;
			filters_button.setSize(75, top_bar_background.height - 11);
			filters_button.x = options_button.x - filters_button.width - 5;
			search_button.setSize(75, top_bar_background.height - 11);
			search_button.x = filters_button.x - search_button.width - 5;
			search_input.setSize(search_button.x - 10, top_bar_background.height - 11);
			
			// Update Song Scroll Pane
			ss_background.setSize(top_bar_background.width, Constant.GAME_HEIGHT - 80);
			ss_scrollpane.setSize(ss_background.width - 20, ss_background.height - 20);
			
			// Update Song Button Widths
			for each (var item:SongButton in ss_songButtons)
			{
				item.width = ss_scrollpane.paneWidth;
			}
			
			// Scroll Pane Size
			bottom_bar_background.setSize(Constant.GAME_WIDTH - 150, 36);
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
		 * Creates the Genre Buttons.
		 */
		public function drawGenreList():void
		{
			genre_scrollpane.removeChildren();
			genre_scrollpane.content.graphics.clear();
			genre_songButtons = [];
			
			var genreLabel:Label;
			var genreYPosition:int = 0;
			var drawPosition:Object = {"y": 0, "height": 10};
			var displayAltEngines:Boolean = (core.loaderCount > 1 && core.user.settings.display_alt_engines);
			
			// Get Engine Sources
			var engineSources:Array = [];
			if (displayAltEngines)
			{
				for each (var item:EngineLoader in core.engineLoaders)
				{
					if (item.isCanon || !item.loaded)
						continue; // Skip FFR/Non-loaded engines for now.
					engineSources.push(item.infoArray);
				}
				engineSources = engineSources.sort();
			}
			engineSources.unshift(core.canonLoader.infoArray); // Place FFR first.
			
			// Draw Search Tag / Engine Label
			if (DISPLAY_MODE == DM_SEARCH)
			{
				genreLabel = new Label(genre_scrollpane, 0, genreYPosition, 'Search');
				genreLabel.tag = {"engine": core.source, "genre": "search"};
				genreLabel.setSize(genre_scrollpane.paneWidth, 0);
				genreLabel.fontSize = UIStyle.FONT_SIZE + 4;
				drawPosition = {"y": genreYPosition, "height": genreLabel.height};
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
						moveTo(0, genreYPosition + 1);
						lineTo(genre_scrollpane.paneWidth, genreYPosition + 1);
					}
				}
				
				// Engine Label
				if (displayAltEngines)
				{
					genreLabel = new Label(genre_scrollpane, 0, genreYPosition, '<font color="' + UIStyle.ACTIVE_FONT_COLOR + '">' + engineSource[1] + '</font>', true);
					genreLabel.tag = {"engine": engineSource[1], "genre": genre_id};
					genreLabel.setSize(genre_scrollpane.paneWidth, 0);
					genreLabel.fontSize = UIStyle.FONT_SIZE + 4;
					genreYPosition += genreLabel.height + 2;
				}
				
				// All Genre
				genreLabel = new Label(genre_scrollpane, 0, genreYPosition, core.getStringSource(engineSource[2], "genre_-1"), true);
				genreLabel.tag = {"engine": engineSource[2], "genre": "all"};
				genreLabel.setSize(genre_scrollpane.paneWidth, 20);
				genreLabel.mouseEnabled = true;
				if (core.source == engineSource[2] && DISPLAY_MODE == DM_ALL)
				{
					genreLabel.fontSize = UIStyle.FONT_SIZE + 2;
					drawPosition = {"y": genreYPosition, "height": genreLabel.height};
				}
				genreYPosition += genreLabel.height + 5;
				
				// Genre Labels
				for (var genre_id:String in core.getPlaylist(engineSource[2]).genre_list)
				{
					var genre_int:int = parseInt(genre_id);
					genreLabel = new Label(genre_scrollpane, 0, genreYPosition, core.getStringSource(engineSource[2], "genre_" + (genre_int - 1)), true);
					genreLabel.tag = {"engine": engineSource[2], "genre": genre_id};
					genreLabel.setSize(genre_scrollpane.paneWidth, 20);
					genreLabel.mouseEnabled = true;
					
					if (core.source == engineSource[2] && genre_int == SELECTED_GENRE)
					{
						genreLabel.fontSize = UIStyle.FONT_SIZE + 2;
						drawPosition = {"y": genreYPosition, "height": genreLabel.height};
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
				drawRect(0, drawPosition.y, genre_scrollpane.paneWidth, drawPosition.height);
				endFill();
			}
			
			// Reset Scroll
			genre_scrollpane.scrollReset();
		}
		
		/**
		 * Creates the Song Buttons
		 */
		public function drawSongList():void
		{
			ss_scrollpane.removeChildren();
			ss_songButtons = [];
			
			var i:int;
			var list:Array;
			
			// Search Mode
			if (DISPLAY_MODE == DM_SEARCH)
			{
				// Filter
				list = _playlist.index_list.filter(function(item:EngineLevel, index:int, array:Array):Boolean
				{
					return item.name.toLowerCase().indexOf(SEARCH_TEXT) != -1;
				}).sortOn("name");
				
			}
			// Display All
			else if (DISPLAY_MODE == DM_ALL)
			{
				list = _playlist.index_list;
				
				// User Filter
				if (core.variables.active_filter != null)
				{
					list = list.filter(function(item:EngineLevel, index:int, array:Array):Boolean
					{
						return core.variables.active_filter.process(item, core.user);
					});
				}
				list = list.slice(CURRENT_PAGE * 500, (CURRENT_PAGE + 1) * 500);
			}
			// Standard Display
			else
			{
				list = _playlist.genre_list[SELECTED_GENRE];
			}
			
			// User Filter
			if (core.variables.active_filter != null && list != null && DISPLAY_MODE != DM_ALL)
			{
				list = list.filter(function(item:EngineLevel, index:int, array:Array):Boolean
				{
					return core.variables.active_filter.process(item, core.user);
				});
			}
			
			// Display
			if (list != null)
			{
				var songButtonYPosition:int = 0;
				for (i = 0; i < list.length; i++)
				{
					ss_songButtons.push(new SongButton(ss_scrollpane, 0, songButtonYPosition, core, list[i]));
					songButtonYPosition += ss_songButtons[ss_songButtons.length - 1].height + 5;
				}
			}
			
			// Select First Song
			changeSelectedSong(ss_songButtons[0]);
			
			// Reset Scroll
			ss_scrollpane.scrollReset();
		}
		
		/**
		 * Changes the selected/highlighted song to the provided song button.
		 * @param	songButton Song to set as active.
		 */
		private function changeSelectedSong(songButton:SongButton):void
		{
			if (SELECTED_SONG != null)
				SELECTED_SONG.highlight = false;
			if (songButton == null)
				return;
			(SELECTED_SONG = songButton).highlight = true;
		}
		
		/**
		 * Adds the currently selected song
		 * @param	goToLoader Jump to song loader scene after adding to queue.
		 */
		private function _addSelectedSongToQueue(goToLoader:Boolean = false):void
		{
			if (SELECTED_SONG)
			{
				core.variables.song_queue.push(SELECTED_SONG.songData);
				if (goToLoader)
				{
					_closeScene(0);
				}
			}
		}
		
		private function _closeScene(sceneIndex:int):void
		{
			INPUT_DISABLED = true;
			TweenLite.to(shift_plane, 0.5, {"alpha": 0, "onComplete": function():void
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
			// Switch to Intended UI scene
			switch (sceneIndex)
			{
				case 0: 
					core.scene = new SceneSongLoader(core);
					break;
			}
		}
		
		//------------------------------------------------------------------------------------------------//
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		/**
		 * Event: EngineCore.LOADERS_UPDATE
		 * Called when a engine loader is added or removed from the core.
		 */
		private function e_loadersUpdate(e:Event):void
		{
			// Current Playlist got removed.
			if (!core.engineLoaders[_playlist.id])
			{
				SELECTED_GENRE = 1;
			}
			drawGameList();
		}
		
		/**
		 * Event: MOUSE_CLICK
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
		 * Event: MOUSE_CLICK
		 * Search Button Click Event
		 */
		private function e_searchClick(e:Event):void
		{
			SEARCH_TEXT = StringUtil.trim(search_input.text.toLowerCase());
			if (SEARCH_TEXT != "")
			{
				DISPLAY_MODE = DM_SEARCH;
				SELECTED_GENRE = -1;
				
				drawGameList();
			}
		}
		
		/**
		 * Event: MOUSE_CLICK
		 * Search Button Click Event
		 */
		private function e_filtersClick(e:Event):void
		{
			core.addOverlay(new FilterEditor(core));
		}
		
		/**
		 * Event: MOUSE_CLICK
		 * Song Selection Scrollpane Click
		 */
		private function e_songSelectionPaneClick(e:MouseEvent):void
		{
			var target:* = e.target;
			if (target is SongButton)
			{
				changeSelectedSong(e.target as SongButton);
			}
		}
		
		/**
		 * Event: KEY_DOWN
		 * Used to navigate the menu using the arrow keys or user set keys
		 */
		private function e_keyboardDown(e:KeyboardEvent):void
		{
			if (INPUT_DISABLED)
				return;
			
			// Focus is Search Input
			if (stage.focus == search_input.textField)
			{
				if (e.keyCode == Keyboard.ENTER)
				{
					e_searchClick(e);
				}
				return;
			}
			
			// No Stage Focus
			if (!stage.focus)
			{
				// Check for Song Items
				if (ss_songButtons.length == 0)
					return;
				
				var selectedIndex:int = SELECTED_SONG ? ss_songButtons.indexOf(SELECTED_SONG) : 0;
				var newIndex:int = selectedIndex;
				
				// Select Song
				if (e.keyCode == Keyboard.ENTER)
				{
					_addSelectedSongToQueue(true);
				}
				// Menu Navigation
				else if (e.keyCode == core.user.settings.key_down || e.keyCode == Keyboard.DOWN || e.keyCode == Keyboard.NUMPAD_2)
				{
					newIndex++;
				}
				else if (e.keyCode == core.user.settings.key_up || e.keyCode == Keyboard.UP || e.keyCode == Keyboard.NUMPAD_8)
				{
					newIndex--;
				}
				else if (e.keyCode == Keyboard.PAGE_DOWN)
				{
					newIndex += 10;
				}
				else if (e.keyCode == Keyboard.PAGE_UP)
				{
					newIndex -= 10;
				}
				
				// New Index
				if (newIndex != selectedIndex)
				{
					// Find First Menu Item
					newIndex = ArrayUtil.find_next_index(newIndex < selectedIndex, newIndex, ss_songButtons, function(n:SongButton):Boolean
					{
						return !n.songData.is_title_only;
					});
					
					changeSelectedSong(ss_songButtons[newIndex]);
					ss_scrollpane.scrollChild(SELECTED_SONG);
				}
				return;
			}
		}
	
	}

}