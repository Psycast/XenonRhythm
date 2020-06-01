package scenes.songselection
{
	import assets.menu.BrandLogo;

	import classes.engine.EngineCore;
	import classes.engine.EngineLevel;
	import classes.engine.EngineLoader;
	import classes.engine.EnginePlaylist;
	import classes.ui.Box;
	import classes.ui.BoxButton;
	import classes.ui.BoxCombo;
	import classes.ui.BoxInput;
	import classes.ui.FormManager;
	import classes.ui.Label;
	import classes.ui.ScrollPaneBars;
	import classes.ui.UIAnchor;
	import classes.ui.UIComponent;
	import classes.ui.UICore;
	import classes.ui.UISprite;
	import classes.ui.UIStyle;
	import com.flashfla.utils.NumberUtil;
	import com.flashfla.utils.StringUtil;
	import com.flashfla.utils.sprintf;
	import com.greensock.TweenLite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.ui.Keyboard;
	import scenes.songselection.ui.GenreButton;
	import scenes.songselection.ui.SongButton;
	import scenes.songselection.ui.UISongSelector;
	import scenes.songselection.ui.filtereditor.FilterEditor;
	import scenes.songselection.ui.filtereditor.FilterIcon;
	
	public class SceneSongSelection extends UICore
	{
		public const SEARCH_OPTIONS:Array = ["name", "author", "stepauthor", "style"];
		public const DM_STANDARD:String = "normal";
		public const DM_ALL:String = "all";
		public const DM_SEARCH:String = "search";
		
		public const LIST_TOP_BAR:String = "top-bar-buttons";
		public const LIST_SIDEBAR:String = "sidebar-buttons";
		public const LIST_GENRE:String = "genre-list";
		public const LIST_SONG:String = "song-list";
		
		// Data Elements
		/** Engine Playlist Reference */
		private var _playlist:EnginePlaylist;
		
		// UI Elements
		/** Contains all child elements for easy horizontal movement */
		private var shift_plane:UISprite;
		
		private var xenon_logo:UISprite;
		
		/** Genre Selection Scroll Pane */
		private var genre_scrollpane:ScrollPaneBars;
		
		/** Song Selection Background */
		private var top_bar_background:Box;
		
		private var search_input:BoxInput;
		private var search_button:BoxButton;
		private var search_type_combo:BoxCombo;
		private var filters_button:BoxButton;
		
		/** Song Selection */
		private var ss_background:Box;
		private var ss_scrollpane:UISongSelector;
		//private var ss_songButtons:Array;
		
		/** Bottom Area */
		private var bottom_bar_background:Box;
		private var bottom_user_info:Label;
		
		/** Sidebar */
		private var side_bar_background:Box;
		private var options_button:BoxButton;
		
		// UI Variables
		public var DISPLAY_MODE:String = DM_STANDARD;
		public var SELECTED_GENRE:GenreButton;
		public var SELECTED_SONG:SongButton;
		public var CURRENT_PAGE:int = 0;
		public var SEARCH_TEXT:String = "";
		public var SEARCH_TYPE:String = SEARCH_OPTIONS[0];

		//------------------------------------------------------------------------------------------------//
		
		public function SceneSongSelection(core:EngineCore)
		{
			super(core);
		}
		
		override public function init():void
		{
			super.init();
			INPUT_DISABLED = true;
		}
		
		override public function onStage():void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, e_keyboardDown);
			core.addEventListener(EngineCore.LOADERS_UPDATE, e_loadersUpdate);

			// Overall Background
			shift_plane = new UISprite(this);
			shift_plane.alpha = 0;
			TweenLite.to(shift_plane, 0.5, {"alpha": 1, "onComplete": function():void { INPUT_DISABLED = false; }});
			
			// Game Logo
			xenon_logo = new UISprite(shift_plane, new BrandLogo(), 18, 12);
			
			// Setup Genre Selection Pane/Bar
			(genre_scrollpane = new ScrollPaneBars(shift_plane, 5, 125)).setSize(115, 100);
			genre_scrollpane.addEventListener(MouseEvent.CLICK, e_genreSelectionPaneClick);
			
			// Search / Filter Box
			FormManager.registerGroup(this, LIST_TOP_BAR, UIAnchor.NONE);
			top_bar_background = new Box(shift_plane, 145, -1);
			
			search_input = new BoxInput(top_bar_background, 10, 5);
			search_input.group = LIST_TOP_BAR;
			search_button = new BoxButton(top_bar_background, 105, 5, core.getString("song_selection_menu_search"), e_searchClick);
			search_button.group = LIST_TOP_BAR;
			search_type_combo = new BoxCombo(core, top_bar_background, 105, 5, "---", e_searchTypeClick, e_disableInputEvents);
			search_type_combo.options = _createSearchOptions();
			search_type_combo.title = core.getString("song_selection_menu_search_type");
			search_type_combo.selectedIndexString = SEARCH_TYPE;
			search_type_combo.group = LIST_TOP_BAR;
			filters_button = new BoxButton(top_bar_background, 205, 5, core.getString("song_selection_filters"), e_filtersClick);
			filters_button.group = LIST_TOP_BAR;
			
			search_button.fontSize = filters_button.fontSize = search_type_combo.fontSize = UIStyle.FONT_SIZE - 3;
			
			// Setup Song Selection Pane/Bar
			ss_background = new Box(shift_plane, 145, 40);
			ss_scrollpane = new UISongSelector(core, ss_background, 10, 10);
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
			bottom_user_info.fontSize = UIStyle.FONT_SIZE - 1;
			
			// Sidebar
			FormManager.registerGroup(this, LIST_SIDEBAR, UIAnchor.WRAP_VERTICAL);
			side_bar_background = new Box(shift_plane, Constant.GAME_WIDTH - 40, -1);
			options_button = new BoxButton(side_bar_background, 5, 5);
			options_button.setSize(31, 31);
			options_button.group = LIST_SIDEBAR;
			(new FilterIcon(options_button, 3, 3, FilterIcon.ICON_GEAR, false)).setSize(options_button.width - 4, options_button.width - 4);
			
			// Draw All Game List
			drawGameList();
			
			FormManager.selectGroup(LIST_SONG);
			
			super.onStage();
		}
		
		override public function destroy():void
		{
			super.destroy();
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, e_keyboardDown);
			core.removeEventListener(EngineCore.LOADERS_UPDATE, e_loadersUpdate);
		}
		
		override public function position():void
		{
			// Update Genre Scrollbar Size + Position
			genre_scrollpane.setSize(135, Constant.GAME_HEIGHT - 130);
			
			// Top Bar
			top_bar_background.setSize(Constant.GAME_WIDTH - 190, 36);
			filters_button.setSize(75, top_bar_background.height - 11);
			filters_button.x = top_bar_background.width - filters_button.width - 5;
			search_button.setSize(75, top_bar_background.height - 11);
			search_button.x = filters_button.x - search_button.width - 5;
			search_type_combo.setSize(115, top_bar_background.height - 11);
			search_type_combo.x = search_button.x - search_type_combo.width - 5;
			search_input.setSize(search_type_combo.x - 15, top_bar_background.height - 11);
			
			// Update Song Scroll Pane
			var ssPaneSize:int = 350;
			ss_background.setSize(top_bar_background.width, Constant.GAME_HEIGHT - 80);
			ss_scrollpane.setSize(ss_background.width - ssPaneSize - 20, ss_background.height - 20);
			
			// Update Song Button Widths
			ss_scrollpane.updateWidths();
			
			// Scroll Pane Size
			bottom_bar_background.setSize(top_bar_background.width, 36);
			bottom_bar_background.y = Constant.GAME_HEIGHT - 35;
			bottom_user_info.setSize(bottom_bar_background.width - 10, bottom_bar_background.height - 11);
			
			// Sidebar
			side_bar_background.setSize(41, Constant.GAME_HEIGHT + 2);
			side_bar_background.x = Constant.GAME_WIDTH - 40;
			options_button.y = 5; // Constant.GAME_HEIGHT - options_button.height - 4;
		}
		
		override public function doInputNavigation(action:String, index:Number = 0):void
		{
			if (INPUT_DISABLED)
				return;
			
			var lastActiveElement:UIComponent = FormManager.getLastHighlight();
			var activeElement:UIComponent;
			
			// Check for 
			if (action == "confirm" && stage.focus is TextField)
			{
				if (stage.focus == search_input.textField)
					e_searchClick();
			}
			else if ((action == "left" || action == "right" || action == "click") && !(stage.focus is TextField))
				activeElement = FormManager.handleAction(action, index);
			else
				activeElement = FormManager.handleAction(action, index);
			
			if (activeElement)
				_handleInputEvent(activeElement, action, lastActiveElement);
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
			position();
		}
		
		/**
		 * Creates the Genre Buttons.
		 */
		public function drawGenreList():void
		{
			genre_scrollpane.removeChildren();
			genre_scrollpane.content.graphics.clear();
			(FormManager.registerGroup(this, LIST_GENRE, UIAnchor.WRAP_VERTICAL)).setClipFromComponent(genre_scrollpane.pane);
			
			var selected_genre_id:int = (SELECTED_GENRE ? SELECTED_GENRE.genre : 1);
			var genreButton:GenreButton;
			var genreYPosition:int = 0;
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
				genreButton = new GenreButton(genre_scrollpane, 0, genreYPosition, core.getString("search"));
				genreButton.engine = core.source;
				genreButton.genre = GenreButton.SEARCH;
				genreButton.setSize(genre_scrollpane.paneWidth, 0);
				genreButton.fontSize = UIStyle.FONT_SIZE + 4;
				genreButton.group = LIST_GENRE;
				genreButton.isSelected = true;
				genreYPosition += genreButton.height + 2;
			}
			
			// Draw Genre Labels
			var engineSource:Array;
			for (var engine:int = 0; engine < engineSources.length; engine++)
			{
				engineSource = engineSources[engine];
				
				// Draw Dividing Border
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
					genreButton = new GenreButton(genre_scrollpane, 0, genreYPosition, '<font color="' + UIStyle.ACTIVE_FONT_COLOR + '">' + engineSource[1] + '</font>', true);
					genreButton.setSize(genre_scrollpane.paneWidth, 0);
					genreButton.fontSize = UIStyle.FONT_SIZE + 4;
					genreYPosition += genreButton.height + 2;
				}
				
				// All Genre
				genreButton = new GenreButton(genre_scrollpane, 0, genreYPosition, core.getStringSource(engineSource[2], "genre_-1"), true);
				genreButton.engine = engineSource[2];
				genreButton.genre = GenreButton.ALL;
				genreButton.setSize(genre_scrollpane.paneWidth, 20);
				genreButton.mouseEnabled = true;
				genreButton.group = LIST_GENRE;
				if (core.source == engineSource[2] && DISPLAY_MODE == DM_ALL)
				{
					genreButton.fontSize = UIStyle.FONT_SIZE + 2;
					genreButton.isSelected = true;
					SELECTED_GENRE = genreButton;
				}
				genreYPosition += genreButton.height + 5;
				
				// Genre Labels
				for (var genre_id:String in core.getPlaylist(engineSource[2]).genre_list)
				{
					var genre_int:int = parseInt(genre_id);
					genreButton = new GenreButton(genre_scrollpane, 0, genreYPosition, core.getStringSource(engineSource[2], "genre_" + (genre_int - 1)), true);
					genreButton.engine = engineSource[2];
					genreButton.genre = genre_int;
					genreButton.setSize(genre_scrollpane.paneWidth, 20);
					genreButton.mouseEnabled = true;
					genreButton.group = LIST_GENRE;
					if (core.source == engineSource[2] && genre_int == selected_genre_id)
					{
						genreButton.fontSize = UIStyle.FONT_SIZE + 2;
						genreButton.isSelected = true;
						SELECTED_GENRE = genreButton;
					}
					
					genreYPosition += genreButton.height + 5;
				}
			}
			FormManager.getGroup(this, LIST_GENRE).last_highlight = SELECTED_GENRE;
			
			if (FormManager.active_group.group_name == LIST_GENRE)
				FormManager.active_group.last_highlight.highlight = true;
			
			// Reset Scroll
			genre_scrollpane.scrollReset();
		}
		
		/**
		 * Creates the Song Buttons
		 */
		public function drawSongList():void
		{
			// Clear Up Old Elements
			ss_scrollpane.clear();
			
			var i:int;
			var list:Array;
			
			// Search Mode
			if (DISPLAY_MODE == DM_SEARCH)
			{
				// Filter
				list = _playlist.index_list.filter(function(item:EngineLevel, index:int, array:Array):Boolean
				{
					return item[SEARCH_TYPE].toLowerCase().indexOf(SEARCH_TEXT) != -1;
				}).sortOn("name", Array.CASEINSENSITIVE);
			}
			// Display All
			else if (DISPLAY_MODE == DM_ALL)
			{
				list = _playlist.index_list;
			}
			// Standard Display
			else
			{
				list = _playlist.genre_list[SELECTED_GENRE.genre];
			}
			
			// User Filter
			if (core.variables.active_filter != null && list != null)
			{
				list = list.filter(function(item:EngineLevel, index:int, array:Array):Boolean
				{
					return core.variables.active_filter.process(item, core.user);
				});
			}

			if (list != null && list.length > 0)
			{
				ss_scrollpane.setRenderList(list);
				_changeSelectedSong(ss_scrollpane.findSongButton(list[0]));
			}
			else
				ss_scrollpane.clear();
		}

		//------------------------------------------------------------------------------------------------//
		
		///////////////////////////////////
		// private methods
		///////////////////////////////////
		
		/**
		 * Creates the search type options for the BoxCombo
		 * @return Array of options with correct language strings.
		 */
		private function _createSearchOptions():Array
		{
			var options:Array = [];
			for (var i:int = 0; i < SEARCH_OPTIONS.length; i++)
			{
				options.push([core.getString("song_value_" + SEARCH_OPTIONS[i]), SEARCH_OPTIONS[i]]);
			}
			
			return options;
		}
		
		/**
		 * Gets the Genre Button that matchs the requested ID from the current engine source.
		 * @param	index Genre ID to find.
		 * @return GenreButton of matching ID.
		 */
		private function _getGenreButtonByID(index:int):GenreButton
		{
			var items:Vector.<UIComponent> = FormManager.getGroup(this, LIST_GENRE).items;
			for each (var item:GenreButton in items)
			{
				if (item.genre == index && core.source == item.engine)
					return item;
			}
			return null;
		}
		
		/**
		 * Changes the current genre using the provided tag for information.
		 * @param	tag
		 */
		private function _changeGenre(genreButton:GenreButton):void
		{
			if (genreButton.engine != core.source)
				core.source = genreButton.engine;
			
			// All Genre
			if (genreButton.genre == GenreButton.ALL)
				DISPLAY_MODE = DM_ALL;
			
			// Normal Genres
			else
				DISPLAY_MODE = DM_STANDARD;
			
			SELECTED_GENRE = genreButton;
			drawGameList();
		}
		
		/**
		 * Changes the selected/highlighted song to the provided song button.
		 * @param	songButton Song to set as active.
		 */
		private function _changeSelectedSong(songButton:SongButton):void
		{
			if (SELECTED_SONG != null)
				SELECTED_SONG.highlight = false;
			if (songButton == null)
				return;
			(SELECTED_SONG = songButton).highlight = true;
			ss_scrollpane.selectedSongData = songButton.songData;
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
					_closeScene(0);
			}
		}
		
		/**
		 * Does the scene closing animation before switching scene.
		 * @param	sceneIndex Scene Index to jump to.
		 */
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
		
		/**
		 * Handles logic based on elements from the doInputNavigation. This uses the new highlight item and the action preformed, while optionally having the previous element.
		 * @param	activeElement The New Highlighted UIComponent
		 * @param	action Form Action Preformed
		 * @param	lastElement Last Highlighted UIComponent.
		 */
		private function _handleInputEvent(activeElement:UIComponent, action:String, lastElement:UIComponent = null):void
		{
			if (INPUT_DISABLED)
				return;
			
			if (activeElement)
			{
				// Song Button
				if (activeElement is SongButton)
				{
					if (ss_scrollpane.selectedSongData == (activeElement as SongButton).songData)
						_addSelectedSongToQueue(true);
					else
						_changeSelectedSong(activeElement as SongButton);
					
					if(action != "click")
						ss_scrollpane.scrollChild(activeElement);
				}

				// Genre Button
				if (activeElement is GenreButton)
				{
					if (action == "click")
					{
						if (lastElement is GenreButton)
							(lastElement as GenreButton).isSelected = false;
						_changeGenre(activeElement as GenreButton);
					}
					genre_scrollpane.scrollChild(activeElement);
				}
			}
		}
		
		//------------------------------------------------------------------------------------------------//
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		/**
		 * Event: Any
		 * Called by objects to disable input.
		 * @param	e
		 */
		private function e_disableInputEvents(e:Event = null):void 
		{
			INPUT_DISABLED = true;
		}
		
		/**
		 * Event: KEY_DOWN
		 * Used to navigate the menu using the arrow keys or user set keys
		 */
		private function e_keyboardDown(e:KeyboardEvent):void
		{
			if (INPUT_DISABLED)
				return;
			
			// Special Case for Search Inputfield
			if (stage.focus is TextField && !e.shiftKey)
			{
				if (e.keyCode == Keyboard.ENTER)
				{
					doInputNavigation("confirm");
					stage.focus = null;
				}
			}
			else
			{
				if (core.user.settings.menu_keys.isPressed("down", e.keyCode))
					doInputNavigation("down");
				else if (core.user.settings.menu_keys.isPressed("up", e.keyCode))
					doInputNavigation("up");
				else if (core.user.settings.menu_keys.isPressed("left", e.keyCode) && (!(stage.focus is TextField) || e.shiftKey))
					doInputNavigation("left");
				else if (core.user.settings.menu_keys.isPressed("right", e.keyCode) && (!(stage.focus is TextField) || e.shiftKey))
					doInputNavigation("right");
				
				else if (e.keyCode == Keyboard.PAGE_DOWN)
					doInputNavigation("down", 9);
				else if (e.keyCode == Keyboard.PAGE_UP)
					doInputNavigation("up", 9);
				
				else if (core.user.settings.menu_keys.isPressed("select", e.keyCode) && !(stage.focus is TextField))
					doInputNavigation("click");
					
				e.stopPropagation();
			}
		}
		
		/**
		 * Event: EngineCore.LOADERS_UPDATE
		 * Called when a engine loader is added or removed from the core.
		 */
		private function e_loadersUpdate(e:Event):void
		{
			// Current Playlist got removed.
			if (!core.engineLoaders[_playlist.id])
			{
				SELECTED_GENRE = _getGenreButtonByID(1);
			}
			drawGameList();
		}
		
		/**
		 * Event: MOUSE_CLICK
		 * Genre Scrollpane Click
		 */
		private function e_genreSelectionPaneClick(e:MouseEvent):void
		{
			if (e.target is GenreButton)
				_handleInputEvent(e.target as GenreButton, "click");
		}
		
		/**
		 * Event: MOUSE_CLICK
		 * Song Selection Scrollpane Click
		 */
		private function e_songSelectionPaneClick(e:MouseEvent):void
		{
			if (e.target is SongButton)
				_handleInputEvent(e.target as SongButton, "click");
		}
		
		/**
		 * Event: BoxCombo Change
		 * @param	e Object containing the selected option.
		 */
		private function e_searchTypeClick(e:Object):void
		{
			SEARCH_TYPE = e["value"];
			INPUT_DISABLED = false;
			FormManager.selectGroup(LIST_TOP_BAR, this);
		}
		
		/**
		 * Event: MOUSE_CLICK
		 * Search Button Click Event
		 */
		private function e_searchClick(e:Event = null):void
		{
			if (INPUT_DISABLED)
				return;
			
			SEARCH_TEXT = StringUtil.trim(search_input.text.toLowerCase());
			if (SEARCH_TEXT != "")
			{
				DISPLAY_MODE = DM_SEARCH;
				SELECTED_GENRE = _getGenreButtonByID(GenreButton.SEARCH);
				
				drawGameList();
			}
		}
		
		/**
		 * Event: MOUSE_CLICK
		 * Search Button Click Event
		 */
		private function e_filtersClick(e:Event):void
		{
			if (INPUT_DISABLED)
				return;
				
			e_disableInputEvents(e);
			
			core.addOverlay(new FilterEditor(core));
		}
	}
}