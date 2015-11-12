package scenes.songselection
{
	import assets.menu.icons.*;
	import classes.ui.UIComponent;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	
	public class FilterIcon extends UIComponent
	{
		
		protected var _icon:MovieClip;
		
		public function FilterIcon(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, icon:String = "Unknown"):void
		{
			_icon = getIconFromString(icon);
			super(parent, xpos, ypos);
		}
		
		/**
		 * Initializes the component.
		 */
		override protected function init():void
		{
			setSize(20, 20);
			super.init();
		}
		
		/**
		 * Creates and adds the child display objects of this component.
		 */
		override protected function addChildren():void
		{
			_icon.width = width;
			_icon.height = height;
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
			_icon.width = width;
			_icon.height = height;
		}
		
		protected function getIconFromString(icon:String):MovieClip
		{
			switch (icon)
			{
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
				case "NPS": 
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