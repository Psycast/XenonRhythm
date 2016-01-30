package scenes.songselection.ui_songselection 
{
	import classes.engine.EngineCore;
	import classes.engine.EngineLevelFilter;
	import classes.ui.Box;
	import classes.ui.BoxButton;
	import classes.ui.BoxComboOverlay;
	import classes.ui.Label;
	import classes.ui.ScrollPane;
	import classes.ui.UIAnchor;
	import classes.ui.UIOverlay;
	import classes.ui.UIStyle;
	import classes.ui.VScrollBar;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.events.Event;
	
	public class FilterEditor extends UIOverlay 
	{
		public const TAB_FILTER:int = 0;
		public const TAB_LIST:int = 1;
		public const INDENT_GAP:int = 21;
		
		public var core:EngineCore;
		private var _holder:Box;
		private var _pane:ScrollPane;
		private var _scrollbar:VScrollBar;
		private var closeButton:BoxButton;
		
		private var SELECTED_FILTER:EngineLevelFilter;
		
		private var DRAW_TAB:int = TAB_FILTER;
		
		public function FilterEditor(core:EngineCore) 
		{
			this.core = core;
			super();
		}
		
		override protected function addChildren():void 
		{
			_holder = new Box(this, 5, 5);
			_pane = new ScrollPane(_holder, 5, 41);
			_scrollbar = new VScrollBar(_holder, 50, 41);
			_scrollbar.addEventListener(Event.CHANGE, e_scrollUpdate);
			
			closeButton = new BoxButton(_holder, 0, 0, "Close", e_closeButton);
			closeButton.setSize(100, 31);
		}
		
		override public function draw():void 
		{
			super.draw();
			
			pG.clear();
			_pane.removeChildren();
			
			if (DRAW_TAB == TAB_FILTER)
			{
				if (core.variables.active_filter != null)
				{
					(new Label(_holder, 5, 5, core.variables.active_filter.name)).fontSize = UIStyle.FONT_SIZE + 3;
					
					drawFilter(core.variables.active_filter);
				}
				else {
					(new Label(_holder, 5, 5, "No Filter Active")).fontSize = UIStyle.FONT_SIZE + 3;
				}
			}
			onResize();
		}
		
		override public function onResize():void 
		{
			super.onResize();
			
			_holder.setSize(width - 10, height - 10);
			_pane.setSize(_holder.width - 30, _holder.height - 46);
			_scrollbar.setSize(15, _pane.height);
			_scrollbar.move(_pane.x + _pane.width + 5, _pane.y);
			_scrollbar.scrollFactor = _pane.scrollFactor;
			_scrollbar.showDragger = _pane.doScroll;
			_scrollbar.scroll = _pane.scroll;
			closeButton.move(_holder.width - 110, 5);
		}
		
		///////////////////////////////////
		// private methods
		///////////////////////////////////
		
		private function drawFilter(filter:EngineLevelFilter, upperFilter:EngineLevelFilter = null, indent:int = 0, yPos:Number = 0):Number 
		{
			var xPos:Number = 10 + INDENT_GAP * indent;
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
						pG.lineTo(xPos - (INDENT_GAP / 2), yPos + 14);
						
						// AND / OR Label
						new Label(_pane, xPos, yPos + 2, filter.type.toUpperCase());
						
						// Remove Filter Button
						var removeFilter:BoxButton = new BoxButton(_pane, xPos + INDENT_GAP + 327, yPos, "X", e_removeFilter);
						removeFilter.setSize(23, 23);
						removeFilter.tag = { "f": filter, "pf": upperFilter };
						
						yPos -= 8;
					}
					else {
						yPos -= 40; // Filters start with AND filter, so remove starting 40px.
					}
					
					var topYPos:Number = yPos + 46; // Store Starting y Position for Line later.
					
					// Render Filters
					for (var i:int = 0; i < filter.filters.length; i++)
					{
						yPos = drawFilter(filter.filters[i], filter, indent + 1, yPos += 40);
					}
					
					// Add Filter Button
					pG.moveTo(xPos + INDENT_GAP - 4, yPos + 57);
					pG.lineTo(xPos + (INDENT_GAP / 2), yPos + 57);
					
					var addFilter:BoxButton = new BoxButton(_pane, xPos + INDENT_GAP, yPos += 44, "+", e_addFilter);
					addFilter.setSize(23, 23);
					addFilter.tag = { "f": filter, "pf": upperFilter };
					
					pG.moveTo(xPos + (INDENT_GAP / 2), topYPos);
					pG.lineTo(xPos + (INDENT_GAP / 2), yPos + 14);
					yPos -= 8;
					break;
					
				default:
					pG.moveTo(xPos - 4, yPos + 17);
					pG.lineTo(xPos - (INDENT_GAP / 2), yPos + 17);
					new FilterButton(_pane, xPos, yPos, filter, upperFilter, this);
					break;
			}
			return yPos;
		}
		
		///////////////////////////////////
		// event handlers
		///////////////////////////////////
		
		private function e_closeButton(e:Event):void 
		{
			core.ui.removeOverlay(this);
		}
		
		private function e_addFilter(e:Event):void 
		{
			SELECTED_FILTER = (e.target as BoxButton).tag["f"];
			core.addOverlay(new BoxComboOverlay("Add Filter Type:", EngineLevelFilter.FILTERS, e_addFilterSelection, UIAnchor.TOP_RIGHT));
		}
		
		private function e_addFilterSelection(e:String):void 
		{
			var newFilter:EngineLevelFilter = new EngineLevelFilter();
			newFilter.type = e;
			
			// Set Default
			if (e == EngineLevelFilter.FILTER_STATS)
				newFilter.input_stat = "perfect";
				
			SELECTED_FILTER.filters.push(newFilter);
			draw();
		}
		
		private function e_removeFilter(e:Event):void 
		{
			var filter:EngineLevelFilter = (e.target as BoxButton).tag["f"];
			var parentFilter:EngineLevelFilter = (e.target as BoxButton).tag["pf"];
			
			if (parentFilter != null && parentFilter.filters.length > 0)
			{
				var ind:int;
				if ((ind = parentFilter.filters.indexOf(filter)) != -1)
				{
					parentFilter.filters.splice(ind, 1);
					draw();
				}
			}
		}
		
		private function e_scrollUpdate(e:Event):void 
		{
			_pane.scroll = _scrollbar.scroll;
		}
		
		///////////////////////////////////
		// getter/setters
		///////////////////////////////////
		
		public function get pG():Graphics
		{
			return _pane.content.graphics;
		}
		
	}

}
import classes.engine.EngineCore;
import classes.engine.EngineLevelFilter;
import classes.ui.Box;
import classes.ui.BoxButton;
import classes.ui.BoxCombo;
import classes.ui.BoxInput;
import classes.ui.Label;
import classes.ui.UIComponent;
import classes.ui.UIOverlay;
import scenes.songselection.ui_songselection.FilterIcon;
import flash.display.DisplayObjectContainer;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.text.TextFieldAutoSize;

internal class FilterButton extends Box
{
	private var core:EngineCore;
	private var updater:UIComponent;
	private var filter:EngineLevelFilter;
	private var parentFilter:EngineLevelFilter;
	
	private var filterIcon:FilterIcon;
	private var combo_stat:BoxCombo;
	private var input_box:BoxInput;
	private var combo_compare:BoxCombo;
	private var remove_button:BoxButton;
	
	public function FilterButton(parent:DisplayObjectContainer, xpos:Number, ypos:Number, filter:EngineLevelFilter, parentFilter:EngineLevelFilter, updater:UIComponent) 
	{
		this.filter = filter;
		this.parentFilter = parentFilter;
		this.updater = updater;
		this.core = updater["core"];
		super(parent, xpos, ypos);
	}
	
	override protected function init():void 
	{
		setSize(327, 33, false);
		addChildren();
		draw();
	}
	
	override protected function addChildren():void 
	{
		remove_button = new BoxButton(this, width, 0, "X", e_clickRemovefilter);
		remove_button.setSize(23, height);
		
		filterIcon = new FilterIcon(this, 5, 6, filter.type, false);
		filterIcon.setSize(23, 23);
		
		switch(filter.type)
		{
			case EngineLevelFilter.FILTER_STATS:
				combo_stat = new BoxCombo(updater["core"], this, 33, 5, filter.input_stat, e_valueStatChange);
				combo_stat.options = EngineLevelFilter.FILTERS_STAT;
				combo_stat.title = "Select Stat for Comparison:";
				combo_stat.label = filter.input_stat;
				combo_stat.setSize(90, 23);
				
				combo_compare = new BoxCombo(updater["core"], this, 128, 5, filter.comparison, e_valueCompareChange);
				combo_compare.options = EngineLevelFilter.FILTERS_NUMBER;
				combo_compare.title = "Comparison:";
				combo_compare.label = (filter.comparison != "" ? filter.comparison : combo_compare.options[0]);
				combo_compare.setSize(80, 23);
				
				input_box = new BoxInput(this, 213, 5, filter.input_number.toString(), e_valueNumberChange);
				input_box.setSize(109, 23);
				break;
				
			case EngineLevelFilter.FILTER_ARROWCOUNT:
			case EngineLevelFilter.FILTER_BPM:
			case EngineLevelFilter.FILTER_DIFFICULTY:
			case EngineLevelFilter.FILTER_ID:
			case EngineLevelFilter.FILTER_MAX_NPS:
			case EngineLevelFilter.FILTER_MIN_NPS:
			case EngineLevelFilter.FILTER_RANK:
			case EngineLevelFilter.FILTER_SCORE:
			case EngineLevelFilter.FILTER_TIME:
				new Label(this, 30, 6, core.getString("filter_type_" + filter.type));
				
				combo_compare = new BoxCombo(updater["core"], this, 110, 5, filter.comparison, e_valueCompareChange);
				combo_compare.options = EngineLevelFilter.FILTERS_NUMBER;
				combo_compare.title = "Comparison:";
				combo_compare.label = (filter.comparison != "" ? filter.comparison : combo_compare.options[0]);
				combo_compare.setSize(100, 23);
				
				input_box = new BoxInput(this, 215, 5, filter.input_number.toString(), e_valueNumberChange);
				input_box.setSize(107, 23);
				break;
				
			case EngineLevelFilter.FILTER_NAME:
			case EngineLevelFilter.FILTER_STYLE:
			case EngineLevelFilter.FILTER_ARTIST:
			case EngineLevelFilter.FILTER_STEPARTIST:
				new Label(this, 30, 6, core.getString("filter_type_" + filter.type));
				
				combo_compare = new BoxCombo(core, this, 110, 5, filter.comparison, e_valueCompareChange);
				combo_compare.options = EngineLevelFilter.FILTERS_STRING;
				combo_compare.title = "Comparison:";
				combo_compare.label = (filter.comparison != "" ? filter.comparison : combo_compare.options[0][0]);
				combo_compare.setSize(100, 23);
				
				input_box = new BoxInput(this, 215, 5, filter.input_string, e_valueStringChange);
				input_box.setSize(107, 23);
				break;
				
			default:
				new Label(this, 5, 6, filter.type);
				break;
		}
	}
	
	private function e_clickRemovefilter(e:Event):void 
	{
		if (parentFilter != null && parentFilter.filters.length > 0)
		{
			var ind:int;
			if ((ind = parentFilter.filters.indexOf(filter)) != -1)
			{
				parentFilter.filters.splice(ind, 1);
				updater.draw();
			}
		}
	}
	
	private function e_valueCompareChange(e:String):void 
	{
		filter.comparison = e;
	}
	
	private function e_valueStatChange(e:String):void 
	{
		filter.input_stat = e;
	}
	
	private function e_valueStringChange(e:Event):void 
	{
		filter.input_string = input_box.text;
	}
	
	private function e_valueNumberChange(e:Event):void 
	{
		var newNumber:Number = Number(input_box.text)
		if (isNaN(newNumber))
			newNumber = 0;
		filter.input_number = newNumber;
	}
}