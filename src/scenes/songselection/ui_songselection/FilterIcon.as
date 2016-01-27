package scenes.songselection.ui_songselection
{
	import assets.menu.icons.*;
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
				case "ArrowCount": 
					return new iconFilterArrowCount();
				case "Artist": 
					return new iconFilterArtist();
				case "BPM": 
					return new iconFilterBPM();
				case "Difficulty": 
					return new iconFilterDifficulty();
				case "Genre": 
					return new iconFilterGenre();
				case "ID": 
					return new iconFilterID();
				case "Name": 
					return new iconFilterName();
				case "MIN_NPS": 
				case "MAX_NPS": 
					return new iconFilterNPS();
				case "Rank": 
					return new iconFilterRank();
				case "Score": 
					return new iconFilterScore();
				case "Stats": 
					return new iconFilterStats();
				case "StepArtist": 
					return new iconFilterStepArtist();
				case "Time": 
					return new iconFilterTime();
			}
			return new iconFilterUnknown();
		}
	
	}

}