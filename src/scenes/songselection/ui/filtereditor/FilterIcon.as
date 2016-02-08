package scenes.songselection.ui.filtereditor
{
	import assets.menu.icons.*;
	import classes.engine.EngineLevelFilter;
	import classes.ui.UIComponent;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	
	public class FilterIcon extends UIComponent
	{
		protected var _border:Boolean;
		protected var _icon:MovieClip;
		
		public function FilterIcon(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, icon:String = "Unknown", border:Boolean = true):void
		{
			_icon = getIconFromString(icon);
			_border = border;
			super(parent, xpos, ypos);
		}
		
		/**
		 * Initializes the component.
		 */
		override protected function init():void
		{
			setSize(24, 24);
			super.init();
		}
		
		/**
		 * Creates and adds the child display objects of this component.
		 */
		override protected function addChildren():void
		{
			_icon.width = width - 4;
			_icon.height = height - 4;
			_icon.x = 2;
			_icon.y = 2;
			addChild(_icon);
		}
		
		///////////////////////////////////
		// public methods
		///////////////////////////////////
		
		/**
		 * Draws the visual ui of the component.
		 */
		override public function draw():void
		{
			super.draw();
			_icon.width = width - 4;
			_icon.height = height - 4;
			
			graphics.clear();
			if(_border)graphics.lineStyle(1, 0xffffff, 1, true);
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, width - 1, height - 1);
			graphics.endFill()
		}
		
		protected function getIconFromString(icon:String):MovieClip
		{
			switch (icon)
			{
				case "Gear": 
					return new iconGear();
					
				// Engine Filters
				case EngineLevelFilter.FILTER_ARROWCOUNT: 
					return new iconFilterArrowCount();
				case EngineLevelFilter.FILTER_ARTIST: 
					return new iconFilterArtist();
				case EngineLevelFilter.FILTER_BPM: 
					return new iconFilterBPM();
				case EngineLevelFilter.FILTER_DIFFICULTY: 
					return new iconFilterDifficulty();
				case EngineLevelFilter.FILTER_STYLE: 
					return new iconFilterGenre();
				case EngineLevelFilter.FILTER_ID: 
					return new iconFilterID();
				case EngineLevelFilter.FILTER_NAME: 
					return new iconFilterName();
				case EngineLevelFilter.FILTER_MAX_NPS: 
				case EngineLevelFilter.FILTER_MIN_NPS: 
					return new iconFilterNPS();
				case EngineLevelFilter.FILTER_RANK: 
					return new iconFilterRank();
				case EngineLevelFilter.FILTER_SCORE: 
					return new iconFilterScore();
				case EngineLevelFilter.FILTER_STATS: 
					return new iconFilterStats();
				case EngineLevelFilter.FILTER_STEPARTIST: 
					return new iconFilterStepArtist();
				case EngineLevelFilter.FILTER_TIME: 
					return new iconFilterTime();
			}
			return new iconFilterUnknown();
		}
	
	}

}