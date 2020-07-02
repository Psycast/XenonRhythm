package scenes.songselection.ui
{
	import classes.ui.Label;
	import flash.display.DisplayObjectContainer;
	
	public class GenreButton extends Label
	{
		public static const SEARCH:int = -9999;
		public static const ALL:int = -9999;
		
		private var _isSelected:Boolean = false;
		public var genre:int;
		public var engine:String;
		
		public function GenreButton(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, text:String = "", useHtml:Boolean = false)
		{
			super(parent, xpos, ypos, text, useHtml);
			this.buttonMode = true;
			this.useHandCursor = true;
		}
		
		override public function set highlight(value:Boolean):void
		{
			super.highlight = value;
			updateSelectedBox();
		}
		
		public function get isSelected():Boolean 
		{
			return _isSelected;
		}
		
		public function set isSelected(value:Boolean):void 
		{
			_isSelected = value;
			updateSelectedBox();
		}
		
		private function updateSelectedBox():void 
		{
			graphics.clear();
			if (isSelected || highlight)
			{
				with (graphics)
				{
					lineStyle(1, 0xFFFFFFF, highlight ? 0.7 : 0.3);
					beginFill(0xFFFFFF, highlight ? 0.25 : 0.1);
					drawRect(0, 0, width, height);
					endFill();
				}
			}
		}
	}
}