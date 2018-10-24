package scenes.songselection.ui.filtereditor
{
	import assets.menu.icons.*;
	import classes.engine.EngineLevelFilter;
	import classes.ui.UIComponent;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	
	public class FilterIcon extends UIComponent
	{
		public static const ICON_GEAR:String = "gear";
		public static const ICON_STYLE:String = "style";
		public static const ICON_NAME:String = "name";
		public static const ICON_ARTIST:String = "artist";
		public static const ICON_STEPARTIST:String = "stepartist";
		public static const ICON_BPM:String = "bpm";
		public static const ICON_DIFFICULTY:String = "difficulty";
		public static const ICON_ARROWCOUNT:String = "arrows";
		public static const ICON_ID:String = "id";
		public static const ICON_MIN_NPS:String = "min_nps";
		public static const ICON_MAX_NPS:String = "max_nps";
		public static const ICON_RANK:String = "rank";
		public static const ICON_SCORE:String = "score";
		public static const ICON_STATS:String = "stats";
		public static const ICON_TIME:String = "time";
		
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
				//case ICON_GEAR: 
				//	return new iconGear();
					
				// Engine Filters
				case ICON_ARROWCOUNT: 
					return new iconFilterArrowCount();
				case ICON_ARTIST: 
					return new iconFilterArtist();
				case ICON_BPM: 
					return new iconFilterBPM();
				case ICON_DIFFICULTY: 
					return new iconFilterDifficulty();
				case ICON_STYLE: 
					return new iconFilterGenre();
				case ICON_ID: 
					return new iconFilterID();
				case ICON_NAME: 
					return new iconFilterName();
				case ICON_MAX_NPS: 
				case ICON_MIN_NPS: 
					return new iconFilterNPS();
				case ICON_RANK: 
					return new iconFilterRank();
				case ICON_SCORE: 
					return new iconFilterScore();
				case ICON_STATS: 
					return new iconFilterStats();
				case ICON_STEPARTIST: 
					return new iconFilterStepArtist();
				case ICON_TIME: 
					return new iconFilterTime();
			}
			return new iconFilterUnknown();
		}
	
	}

}