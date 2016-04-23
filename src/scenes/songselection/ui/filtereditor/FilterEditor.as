package scenes.songselection.ui.filtereditor 
{
	import classes.engine.EngineCore;
	import classes.engine.EngineLevelFilter;
	import classes.ui.Box;
	import classes.ui.BoxButton;
	import classes.ui.BoxComboOverlay;
	import classes.ui.BoxInput;
	import classes.ui.Label;
	import classes.ui.ScrollPane;
	import classes.ui.ScrollPaneBars;
	import classes.ui.UIComponent;
	import classes.ui.UIOverlay;
	import classes.ui.UIStyle;
	import classes.ui.VScrollBar;
	import com.flashfla.utils.ArrayUtil;
	import flash.display.Graphics;
	import flash.events.Event;
	import scenes.songselection.SceneSongSelection;
	
	public class FilterEditor extends UIOverlay 
	{
		public static const TAB_FILTER:int = 0;
		public static const TAB_LIST:int = 1;
		public static const INDENT_GAP:int = 29;
		
		public var core:EngineCore;
		private var _holder:Box;
		private var _pane:ScrollPaneBars;
		
		private var tabLabel:Label;
		private var filterNameInput:BoxInput;
		
		private var addSavedFilterButton:BoxButton;
		private var clearFilterButton:BoxButton;
		private var filterListButton:BoxButton;
		private var closeButton:BoxButton;
		
		private var filterButtons:Array;
		
		private var SELECTED_FILTER:EngineLevelFilter;
		
		public var DRAW_TAB:int = TAB_FILTER;
		
		public function FilterEditor(core:EngineCore) 
		{
			this.core = core;
			super();
		}
		
		/**
		 * Creates and adds child display objects.
		 */
		override protected function addChildren():void 
		{
			_holder = new Box(this, 5, 5);
			_pane = new ScrollPaneBars(_holder, 5, 41, true, true);
			
			tabLabel = new Label(_holder, 10, 7);
			tabLabel.fontSize = UIStyle.FONT_SIZE + 3;
			filterNameInput = new BoxInput(_holder, 5, 5, "", e_filterNameUpdate);
			addSavedFilterButton = new BoxButton(_holder, 0, 0, "Add Filter", e_addSavedFilterButton);
			addSavedFilterButton.setSize(100, 31);
			clearFilterButton = new BoxButton(_holder, 0, 0, "Clear Filter", e_clearFilterButton);
			clearFilterButton.setSize(100, 31);
			filterListButton = new BoxButton(_holder, 0, 0, "Saved Filters", e_toggleTabButton);
			filterListButton.setSize(100, 31);
			closeButton = new BoxButton(_holder, 0, 0, "Close", e_closeButton);
			closeButton.setSize(100, 31);
		}
		
		/**
		 * Draws the visual ui of the component.
		 */
		override public function draw():void 
		{
			super.draw();
			
			_pane.removeChildren();
			pG.clear();
			filterButtons = [];
			
			// Active Filter Editor
			if (DRAW_TAB == TAB_FILTER)
			{
				filterListButton.label = "Saved Filters";
				if (core.variables.active_filter != null)
				{
					addSavedFilterButton.visible = tabLabel.visible = false;
					filterNameInput.visible = clearFilterButton.visible = true;
					filterNameInput.text = core.variables.active_filter.name;
					
					drawFilter(core.variables.active_filter, 0, 5);
				}
				else {
					tabLabel.text = "No Filter Active";
					addSavedFilterButton.visible = tabLabel.visible = true;
					filterNameInput.visible = clearFilterButton.visible = false;
				}
			}
			// Saved Filters List
			else if (DRAW_TAB == TAB_LIST)
			{
				filterListButton.label = "Active Filter";
				filterNameInput.visible = clearFilterButton.visible = false;
				tabLabel.text = "Saved Filters";
				tabLabel.visible = true;
				
				var yPos:Number = -40;
				for each (var item:EngineLevelFilter in core.user.settings.filters) 
				{
					filterButtons.push(new SavedFilterButton(_pane, 0, yPos += 40, item, this));
				}
			}
			onResize();
		}
		
		/**
		 * Stage resize and child positioning.
		 */
		override public function onResize():void 
		{
			super.onResize();
			
			_holder.setSize(width - 10, height - 10);
			_pane.setSize(_holder.width - 10, _holder.height - 46);
			
			closeButton.move(_holder.width - 105, 5);
			filterListButton.move(closeButton.x - 105, 5);
			clearFilterButton.move(filterListButton.x - 105, 5);
			addSavedFilterButton.move(filterListButton.x - 105, 5);
			filterNameInput.setSize(clearFilterButton.x - 10, 31);
			
			for each (var item:UIComponent in filterButtons) 
			{
				item.setSize(_pane.paneWidth, 33);
			}
		}
		
		///////////////////////////////////
		// private methods
		///////////////////////////////////
		/**
		 * Draws and adds the filter boxes to the scrollpane. This draws filters using recursion for multiple levels.
		 * @param	filter Current Filter to Draw
		 * @param	indent Indentation Level
		 * @param	yPos Starting Y-Position on the scrollpane.
		 * @return Bottom Y-Position of the draw filter.
		 */
		private function drawFilter(filter:EngineLevelFilter, indent:int = 0, yPos:Number = 0):Number 
		{
			var xPos:Number = INDENT_GAP * indent;
			pG.lineStyle(1, 0xFFFFFF, 0.55);
			switch(filter.type)
			{
				case EngineLevelFilter.FILTER_AND:
				case EngineLevelFilter.FILTER_OR:
					// Render AND / OR Label
					if (indent > 0)
					{
						// Dash Line
						pG.moveTo(xPos - 4, yPos + 14);
						pG.lineTo(xPos - INDENT_GAP + 10, yPos + 14);
						
						// AND / OR Label
						new Label(_pane, xPos, yPos + 2, core.getString("filter_type_" + filter.type));
						
						// Remove Filter Button
						var removeFilter:BoxButton = new BoxButton(_pane, xPos + INDENT_GAP + 327, yPos, "X", e_removeFilter);
						removeFilter.setSize(23, 23);
						removeFilter.tag = filter;
						
						yPos -= 8;
					}
					else {
						yPos -= 40; // Filters start with AND filter, so remove starting 40px.
					}
					
					var topYPos:Number = yPos + 46; // Store Starting y Position for Line later.
					
					// Render Filters
					for (var i:int = 0; i < filter.filters.length; i++)
					{
						yPos = drawFilter(filter.filters[i], indent + 1, yPos += 40);
					}
					
					// Add Filter Button
					pG.moveTo(xPos + INDENT_GAP - 4, yPos + 57);
					pG.lineTo(xPos + 10, yPos + 57);
					
					var addFilter:BoxButton = new BoxButton(_pane, xPos + INDENT_GAP, yPos += 44, "+", e_addFilter);
					addFilter.setSize(23, 23);
					addFilter.tag = filter;
					
					pG.moveTo(xPos + 10, topYPos);
					pG.lineTo(xPos + 10, yPos + 14);
					yPos -= 8;
					break;
					
				default:
					pG.moveTo(xPos - 4, yPos + 17);
					pG.lineTo(xPos - INDENT_GAP + 10, yPos + 17);
					new FilterItemButton(_pane, xPos, yPos, filter, this);
					break;
			}
			return yPos;
		}
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		private function e_filterNameUpdate(e:Event):void 
		{
			core.variables.active_filter.name = filterNameInput.text;
		}
		
		private function e_addSavedFilterButton(e:Event):void 
		{
			core.user.settings.filters.push(new EngineLevelFilter(true));
			
			if (DRAW_TAB == TAB_FILTER)
				core.variables.active_filter = core.user.settings.filters[core.user.settings.filters.length - 1];
				
			draw();
		}
		
		/**
		 * Event: CLICK
		 * Clears the active filter.
		 */
		private function e_clearFilterButton(e:Event):void 
		{
			core.variables.active_filter = null;
			draw();
		}
		
		/**
		 * Event: CLICK
		 * Toggles between the Active Filter and Saved Filters list.
		 */
		private function e_toggleTabButton(e:Event):void 
		{
			DRAW_TAB = (DRAW_TAB == TAB_FILTER ? TAB_LIST : TAB_FILTER);
			draw();
		}
		
		/**
		 * Event: CLICK
		 * Closes the filter editor window, and reloads the song selection list is scene currently active.
		 */
		private function e_closeButton(e:Event):void 
		{
			core.ui.removeOverlay(this);
			if (core.scene is SceneSongSelection)
			{
				(core.scene as SceneSongSelection).drawGameList();
			}
		}
		
		/**
		 * Event: CLICK
		 * Show new filter type selection window.
		 */
		private function e_addFilter(e:Event):void 
		{
			SELECTED_FILTER = (e.target as BoxButton).tag;
			core.addOverlay(new BoxComboOverlay(core.getString("filter_editor_add_filter"), EngineLevelFilter.createOptions(core, EngineLevelFilter.FILTERS, "type"), e_addFilterSelection));
		}
		
		/**
		 * Adds a new filter to the selected filter list.
		 * @param	data Data from e_addFilter->BoxComboOverlay
		 */
		private function e_addFilterSelection(data:Object):void 
		{
			var newFilter:EngineLevelFilter = new EngineLevelFilter();
			newFilter.type = data["value"];
			newFilter.parent_filter = SELECTED_FILTER;
			
			SELECTED_FILTER.filters.push(newFilter);
			draw();
		}
		
		/**
		 * Removes the selected filter from the parent filter list.
		 */
		private function e_removeFilter(e:Event):void 
		{
			var filter:EngineLevelFilter = (e.target as BoxButton).tag;
			if(ArrayUtil.remove(filter, filter.parent_filter.filters))
			{
				draw();
			}
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		/** Shortcut for scrollpane graphics.  */
		public function get pG():Graphics
		{
			return _pane.content.graphics;
		}
	}
}