package scenes.songselection.ui.filtereditor
{
	import classes.engine.EngineCore;
	import classes.engine.EngineLevelFilter;
	import classes.ui.Box;
	import classes.ui.BoxButton;
	import classes.ui.BoxCombo;
	import classes.ui.BoxInput;
	import classes.ui.Label;
	import com.flashfla.utils.ArrayUtil;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	public class FilterItemButton extends Box
	{
		private var core:EngineCore;
		private var updater:FilterEditor;
		private var filter:EngineLevelFilter;
		
		private var filterIcon:FilterIcon;
		private var combo_stat:BoxCombo;
		private var input_box:BoxInput;
		private var combo_compare:BoxCombo;
		private var remove_button:BoxButton;
		
		public function FilterItemButton(parent:DisplayObjectContainer, xpos:Number, ypos:Number, filter:EngineLevelFilter, updater:FilterEditor)
		{
			this.filter = filter;
			this.updater = updater;
			this.core = updater.core;
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
			
			switch (filter.type)
			{
				case EngineLevelFilter.FILTER_STATS: 
					combo_stat = new BoxCombo(core, this, 5, 5, filter.input_stat, e_valueStatChange);
					combo_stat.options = EngineLevelFilter.createOptions(core, EngineLevelFilter.FILTERS_STAT, "compare_stat");
					combo_stat.title = core.getString("filter_editor_comparison");
					combo_stat.selectedIndexString = filter.input_stat;
					combo_stat.setSize(120, 23); // 90
					
					combo_compare = new BoxCombo(core, this, 130, 5, filter.comparison, e_valueCompareChange);
					combo_compare.options = EngineLevelFilter.FILTERS_NUMBER;
					combo_compare.title = core.getString("filter_editor_comparison");
					combo_compare.selectedIndexString = filter.comparison;
					combo_compare.setSize(80, 23);
					
					input_box = new BoxInput(this, 215, 5, filter.input_number.toString(), e_valueNumberChange);
					input_box.setSize(107, 23);
					break;
				
				case EngineLevelFilter.FILTER_ARROWCOUNT: 
				case EngineLevelFilter.FILTER_BPM: 
				case EngineLevelFilter.FILTER_DIFFICULTY: 
				case EngineLevelFilter.FILTER_MAX_NPS: 
				case EngineLevelFilter.FILTER_MIN_NPS: 
				case EngineLevelFilter.FILTER_RANK: 
				case EngineLevelFilter.FILTER_SCORE: 
				case EngineLevelFilter.FILTER_TIME: 
					new Label(this, 5, 6, core.getString("filter_type_" + filter.type));
					
					combo_compare = new BoxCombo(core, this, 100, 5, filter.comparison, e_valueCompareChange);
					combo_compare.options = EngineLevelFilter.FILTERS_NUMBER;
					combo_compare.title = core.getString("filter_editor_comparison");
					combo_compare.selectedIndexString = filter.comparison;
					combo_compare.setSize(110, 23);
					
					input_box = new BoxInput(this, 215, 5, filter.input_number.toString(), e_valueNumberChange);
					input_box.setSize(107, 23);
					break;
				
				case EngineLevelFilter.FILTER_ID: 
				case EngineLevelFilter.FILTER_NAME: 
				case EngineLevelFilter.FILTER_STYLE: 
				case EngineLevelFilter.FILTER_ARTIST: 
				case EngineLevelFilter.FILTER_STEPARTIST: 
					new Label(this, 5, 6, core.getString("filter_type_" + filter.type));
					
					combo_compare = new BoxCombo(core, this, 100, 5, filter.comparison, e_valueCompareChange);
					combo_compare.options = EngineLevelFilter.createOptions(core, EngineLevelFilter.FILTERS_STRING, "compare_string");
					combo_compare.title = core.getString("filter_editor_comparison");
					combo_compare.selectedIndexString = filter.comparison;
					combo_compare.setSize(110, 23);
					
					input_box = new BoxInput(this, 215, 5, filter.input_string, e_valueStringChange);
					input_box.setSize(107, 23);
					break;
				
				default: 
					new Label(this, 5, 6, filter.type);
					break;
			}
		}
		
		private function e_valueCompareChange(e:Object):void
		{
			filter.comparison = e["value"];
		}
		
		private function e_valueStatChange(e:Object):void
		{
			filter.input_stat = e["value"];
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
		
		private function e_clickRemovefilter(e:Event):void
		{
			if(ArrayUtil.remove(filter, filter.parent_filter.filters))
				updater.draw();
		}
	}

}